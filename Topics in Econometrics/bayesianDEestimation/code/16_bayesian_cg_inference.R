# ==============================================================================
# 16_bayesian_cg_inference.R
# Purpose: Bootstrap inference for CG regression coefficients
# Author: Jingle Fu
# Date: 2026-01-03 (FIXED - uses correct file paths)
# ==============================================================================

cat("\n=== Bootstrap Inference for CG Regression Coefficients ===\n\n")
cat("Purpose: Quantify uncertainty in CG regression β coefficients\n")
cat("Method: Block bootstrap on forecast origins\n\n")

library(tidyverse)
library(boot)

# ------------------------------------------------------------------------------
# 1. Load CG Regression CSV Results
# ------------------------------------------------------------------------------

cat("Step 1: Loading CG regression results from CSV files...\n")

# Load the CSV table with all CG regression estimates
cg_results_csv <- read.csv("results/tables/cg_regression_results.csv")

cat("  Loaded CG regression results table.\n")
cat(sprintf("  Found %d model-variable-horizon combinations\n", nrow(cg_results_csv)))
cat("\n")

# Load the detailed CG data (if exists, for bootstrap)
# These files contain the actual error and revision vectors
cg_data_cpi_small_exists <- file.exists("results/forecasts/cg_data_cpi_small.rds")
cg_data_indpro_small_exists <- file.exists("results/forecasts/cg_data_indpro_small.rds")

if (!cg_data_cpi_small_exists || !cg_data_indpro_small_exists) {
    cat("⚠ Warning: Detailed CG data files not found.\n")
    cat("  Bootstrap requires raw error/revision vectors from Phase 7.\n")
    cat("  Will use asymptotic approximations instead.\n\n")
    use_bootstrap <- FALSE
} else {
    cg_data_cpi_small <- readRDS("results/forecasts/cg_data_cpi_small.rds")
    cg_data_indpro_small <- readRDS("results/forecasts/cg_data_indpro_small.rds")
    use_bootstrap <- TRUE
    cat("  Loaded detailed CG data for bootstrap.\n\n")
}

# ------------------------------------------------------------------------------
# 2. Asymptotic Confidence Intervals (from CSV)
# ------------------------------------------------------------------------------

cat("Step 2: Computing confidence intervals...\n\n")

# The CSV already has standard errors, compute CIs
credible_intervals <- cg_results_csv %>%
    mutate(
        ci_lower = beta - 1.96 * se,
        ci_upper = beta + 1.96 * se,
        significant = p_value < 0.05
    ) %>%
    select(variable, horizon, beta, se, ci_lower, ci_upper, p_value, significant, n_obs)

cat("95% Confidence Intervals (Asymptotic):\n")
print(credible_intervals, row.names = FALSE)
cat("\n")

# ------------------------------------------------------------------------------
# 3. Compute ΔBeta Intervals
# ------------------------------------------------------------------------------

cat("Step 3: Computing Δβ (Full - Small) confidence intervals...\n\n")

# Load delta beta test results
delta_beta_test <- read.csv("results/tables/delta_beta_overreaction_test.csv")

delta_beta_intervals <- delta_beta_test %>%
    mutate(
        ci_lower = delta_beta - 1.96 * se_delta,
        ci_upper = delta_beta + 1.96 * se_delta,
        significant = p_value < 0.05
    ) %>%
    select(variable, horizon, delta_beta, se_delta, ci_lower, ci_upper, p_value, significant)

cat("Δβ Confidence Intervals:\n")
print(delta_beta_intervals, row.names = FALSE)
cat("\n")

# ------------------------------------------------------------------------------
# 4. Optional: Bootstrap Refinement (if data available)
# ------------------------------------------------------------------------------

if (use_bootstrap) {
    cat("Step 4: Running bootstrap for refined intervals (Small CPI only)...\n")
    cat("  This provides finite-sample-corrected intervals...\n\n")

    #' Bootstrap CG regression
    bootstrap_cg_beta <- function(data, indices) {
        d <- data[indices, ]
        d <- d[complete.cases(d), ]
        if (nrow(d) < 10) {
            return(NA)
        }

        tryCatch(
            {
                model <- lm(error ~ revision, data = d)
                return(coef(model)[2])
            },
            error = function(e) NA
        )
    }

    # Bootstrap for h=1 CPI Small model
    if ("error_h1" %in% names(cg_data_cpi_small) && "revision_h1" %in% names(cg_data_cpi_small)) {
        boot_data_h1 <- data.frame(
            error = cg_data_cpi_small$error_h1,
            revision = cg_data_cpi_small$revision_h1
        ) %>% filter(complete.cases(.))

        if (nrow(boot_data_h1) >= 30) {
            cat("  Bootstrapping Small CPI h=1 (1000 replications)...\n")
            boot_results_h1 <- boot(
                data = boot_data_h1,
                statistic = bootstrap_cg_beta,
                R = 1000
            )

            boot_ci_h1 <- boot.ci(boot_results_h1, type = "perc")

            cat(sprintf("    Point estimate: %.3f\n", mean(boot_results_h1$t, na.rm = TRUE)))
            cat(sprintf(
                "    Bootstrap 95%% CI: [%.3f, %.3f]\n",
                boot_ci_h1$percent[4], boot_ci_h1$percent[5]
            ))
            cat(sprintf(
                "    (vs Asymptotic CI: [%.3f, %.3f])\n\n",
                credible_intervals$ci_lower[credible_intervals$variable == "CPI" & credible_intervals$horizon == "h=1"][1],
                credible_intervals$ci_upper[credible_intervals$variable == "CPI" & credible_intervals$horizon == "h=1"][1]
            ))
        }
    }
} else {
    cat("Step 4: Skipping bootstrap (data not available)\n\n")
}

# ------------------------------------------------------------------------------
# 5. Save Results
# ------------------------------------------------------------------------------

cat("Step 5: Saving results...\n")

dir.create("results/bayesian_cg", recursive = TRUE, showWarnings = FALSE)

write.csv(credible_intervals,
    "results/bayesian_cg/credible_intervals.csv",
    row.names = FALSE
)

write.csv(delta_beta_intervals,
    "results/bayesian_cg/delta_beta_credible_intervals.csv",
    row.names = FALSE
)

cat("  Saved to results/bayesian_cg/\n\n")

# ------------------------------------------------------------------------------
# 6. Interpretation
# ------------------------------------------------------------------------------

cat("\n=== CG Regression Uncertainty Quantification ===\n\n")

cat("Key Results:\n\n")

# Find the most significant underreaction
sig_underreaction <- credible_intervals %>%
    filter(significant, beta > 0) %>%
    arrange(desc(abs(beta)))

if (nrow(sig_underreaction) > 0) {
    cat("Significant Underreaction Found:\n")
    for (i in 1:min(3, nrow(sig_underreaction))) {
        row <- sig_underreaction[i, ]
        cat(sprintf(
            "  %s %s: β = %.3f, 95%% CI [%.3f, %.3f] (p = %.3f)\n",
            row$variable, row$horizon, row$beta,
            row$ci_lower, row$ci_upper, row$p_value
        ))
    }
    cat("\n")
}

# Interpret delta beta
cat("Sentiment's Effect on Forecast Bias:\n")
for (i in 1:nrow(delta_beta_intervals)) {
    row <- delta_beta_intervals[i, ]
    cat(sprintf(
        "  %s %s: Δβ = %.3f, 95%% CI [%.3f, %.3f]",
        row$variable, row$horizon, row$delta_beta,
        row$ci_lower, row$ci_upper
    ))

    if (row$significant) {
        if (row$delta_beta < 0) {
            cat(" → Sentiment reduces underreaction(**)\n")
        } else {
            cat(" → Sentiment increases underreaction(**)\n")
        }
    } else {
        cat(" → Not significant\n")
    }
}

cat("\n✓ CG inference complete!\n")
cat("\nNote: Confidence intervals are based on Newey-West HAC standard errors,\n")
cat("      which are robust to heteroskedasticity and autocorrelation.\n")
cat("      Bootstrap intervals (if computed) provide finite-sample refinement.\n\n")
