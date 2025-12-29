# ============================================================================== 
# 07_cg_regression.R
# Purpose: Coibion-Gorodnichenko regression to identify behavioral biases
# Author: Jingle Fu
# Date: 2025-12-26
# ==============================================================================

cat("\n=== Coibion-Gorodnichenko Regression Analysis ===\n\n")

library(tidyverse)
library(lmtest)
library(sandwich)

# ------------------------------------------------------------------------------
# 1. Load Forecast Data
# ------------------------------------------------------------------------------

cat("Step 1: Loading forecast results...\n")

# Forecast results (for revisions)
forecasts_small <- readRDS("results/forecasts/small_model_forecasts.rds")
forecasts_medium <- readRDS("results/forecasts/medium_model_forecasts.rds")
forecasts_full <- readRDS("results/forecasts/full_model_forecasts.rds")

# Load aligned forecasts and actuals
aligned_data <- readRDS("results/forecasts/aligned_forecasts_actuals.rds")

cat("  Data loaded.\n\n")

# ------------------------------------------------------------------------------
# 2. Compute Forecast Revisions
# ------------------------------------------------------------------------------

cat("Step 2: Computing forecast revisions...\n")
cat("  Revision = F_{t+h|t} - F_{t+h|t-1}\n\n")

#' Compute forecast revisions from recursive forecasts
#' Revision definition: F_{t+h|t} - F_{t+h|t-1}
#' For origin t-1, this is (h+1)-step ahead forecast.
compute_forecast_revisions <- function(forecast_results, data_est, var_name, is_log = TRUE) {
    var_idx_default <- which(colnames(data_est) == var_name)

    forecast_list <- lapply(forecast_results, function(x) {
        if (!x[["success"]] || is.null(x$forecasts$all_horizons)) {
            return(NULL)
        }

        var_idx <- var_idx_default
        if (!is.null(x$forecasts$var_names)) {
            var_idx <- which(x$forecasts$var_names == var_name)
        }
        if (length(var_idx) != 1) {
            return(NULL)
        }

        all_horizons <- x$forecasts$all_horizons
        if (is.null(dim(all_horizons))) {
            return(NULL)
        }

        n_vars <- if (!is.null(x$forecasts$var_names)) length(x$forecasts$var_names) else ncol(data_est)
        if (nrow(all_horizons) >= 13 && ncol(all_horizons) == n_vars) {
            all_fcast <- all_horizons[, var_idx]
        } else if (ncol(all_horizons) >= 13 && nrow(all_horizons) == n_vars) {
            all_fcast <- all_horizons[var_idx, ]
        } else {
            return(NULL)
        }

        all_fcast <- as.numeric(all_fcast)
        base_t0 <- coredata(data_est)[x$origin_idx, var_idx]

        forecast_growth <- function(h) {
            if (is_log) {
                (1200 / h) * (all_fcast[h] - base_t0)
            } else {
                (all_fcast[h] - base_t0) / h
            }
        }

        data.frame(
            origin_idx = x$origin_idx,
            origin_date = x$origin_date,
            h1_forecast = forecast_growth(1),
            h2_forecast = forecast_growth(2),
            h3_forecast = forecast_growth(3),
            h4_forecast = forecast_growth(4),
            h12_forecast = forecast_growth(12),
            h13_forecast = forecast_growth(13)
        )
    })

    forecast_list <- forecast_list[!sapply(forecast_list, is.null)]
    if (length(forecast_list) == 0) {
        return(data.frame())
    }

    forecast_df <- do.call(rbind, forecast_list) %>%
        arrange(origin_idx) %>%
        mutate(
            h1_revision_growth = h1_forecast - lag(h2_forecast, n = 1),
            h3_revision_growth = h3_forecast - lag(h4_forecast, n = 1),
            h12_revision_growth = h12_forecast - lag(h13_forecast, n = 1)
        ) %>%
        select(origin_idx, origin_date, ends_with("revision_growth"))

    return(forecast_df)
}

# Load estimation data
data_small_est <- readRDS("data/processed/data_small_estimation.rds")
data_medium_est <- readRDS("data/processed/data_medium_estimation.rds")
data_full_est <- readRDS("data/processed/data_full_estimation.rds")

# Compute revisions for all models (CPI)
rev_cpi_small <- compute_forecast_revisions(forecasts_small, data_small_est, "CPIAUCSL", TRUE)
rev_cpi_medium <- compute_forecast_revisions(forecasts_medium, data_medium_est, "CPIAUCSL", TRUE)
rev_cpi_full <- compute_forecast_revisions(forecasts_full, data_full_est, "CPIAUCSL", TRUE)

# Compute revisions for all models (INDPRO)
rev_indpro_small <- compute_forecast_revisions(forecasts_small, data_small_est, "INDPRO", TRUE)
rev_indpro_medium <- compute_forecast_revisions(forecasts_medium, data_medium_est, "INDPRO", TRUE)
rev_indpro_full <- compute_forecast_revisions(forecasts_full, data_full_est, "INDPRO", TRUE)

cat("  Forecast revisions computed.\n\n")

# ------------------------------------------------------------------------------
# 3. Merge Errors and Revisions
# ------------------------------------------------------------------------------

cat("Step 3: Merging forecast errors with revisions...\n")

#' Create CG regression dataset
#' @param forecast_actual_df Data frame with forecasts and actuals
#' @param revision_df Data frame with forecast revisions
#' @return Data frame ready for CG regression
create_cg_dataset <- function(forecast_actual_df, revision_df) {
    # Compute forecast errors
    error_df <- forecast_actual_df %>%
        mutate(
            h1_error = h1_actual - h1_forecast,
            h3_error = h3_actual - h3_forecast,
            h12_error = h12_actual - h12_forecast
        ) %>%
        select(origin_idx, origin_date, contains("error"))

    # Merge with revisions
    cg_data <- error_df %>%
        left_join(
            revision_df %>% select(origin_idx, contains("revision_growth")),
            by = "origin_idx"
        ) %>%
        na.omit() # Remove NAs from lag operations

    return(cg_data)
}

# ------------------------------------------------------------------------------
# 4. Estimate CG Regressions
# ------------------------------------------------------------------------------

cat("Step 4: Estimating CG regressions...\n")
cat("  Regression: (Actual - Forecast) = alpha + beta * (Forecast_t - Forecast_{t-1}) + eps\n")
cat("  Using Newey-West HAC standard errors\n\n")

#' Estimate CG regression for one horizon
#' @param error Vector of forecast errors
#' @param revision Vector of forecast revisions
#' @param horizon Forecast horizon (for HAC lag selection)
#' @return List with regression results
estimate_cg <- function(error, revision, horizon) {
    # Create regression data
    reg_data <- data.frame(
        error = error,
        revision = revision
    ) %>% na.omit()

    if (nrow(reg_data) < 10) {
        return(list(
            beta = NA,
            se = NA,
            t_stat = NA,
            p_value = NA,
            n_obs = nrow(reg_data)
        ))
    }

    # Estimate regression
    model <- lm(error ~ revision, data = reg_data)

    # Newey-West HAC standard errors (lag = horizon)
    vcov_hac <- NeweyWest(model, lag = horizon, prewhite = FALSE)
    coef_test <- coeftest(model, vcov = vcov_hac)

    # Extract results
    list(
        beta = coef(model)[2],
        se = coef_test[2, "Std. Error"],
        t_stat = coef_test[2, "t value"],
        p_value = coef_test[2, "Pr(>|t|)"],
        r_squared = summary(model)$r.squared,
        n_obs = nrow(reg_data),
        alpha = coef(model)[1]
    )
}

run_cg_model <- function(aligned_df, revision_df, model_label, variable_label) {
    cg_data <- create_cg_dataset(aligned_df, revision_df)
    res_h1 <- estimate_cg(cg_data$h1_error, cg_data$h1_revision_growth, horizon = 1)
    res_h3 <- estimate_cg(cg_data$h3_error, cg_data$h3_revision_growth, horizon = 3)
    res_h12 <- estimate_cg(cg_data$h12_error, cg_data$h12_revision_growth, horizon = 12)

    summary_df <- data.frame(
        model = model_label,
        variable = variable_label,
        horizon = c("h=1", "h=3", "h=12"),
        beta = c(res_h1$beta, res_h3$beta, res_h12$beta),
        se = c(res_h1$se, res_h3$se, res_h12$se),
        t_stat = c(res_h1$t_stat, res_h3$t_stat, res_h12$t_stat),
        p_value = c(res_h1$p_value, res_h3$p_value, res_h12$p_value),
        n_obs = c(res_h1$n_obs, res_h3$n_obs, res_h12$n_obs)
    )

    list(summary = summary_df, data = cg_data, results = list(h1 = res_h1, h3 = res_h3, h12 = res_h12))
}

cg_small_cpi <- run_cg_model(aligned_data$cpi_small, rev_cpi_small, "Small", "CPI")
cg_small_indpro <- run_cg_model(aligned_data$indpro_small, rev_indpro_small, "Small", "INDPRO")

cg_medium_cpi <- run_cg_model(aligned_data$cpi_medium, rev_cpi_medium, "Medium", "CPI")
cg_medium_indpro <- run_cg_model(aligned_data$indpro_medium, rev_indpro_medium, "Medium", "INDPRO")

cg_full_cpi <- run_cg_model(aligned_data$cpi_full, rev_cpi_full, "Full", "CPI")
cg_full_indpro <- run_cg_model(aligned_data$indpro_full, rev_indpro_full, "Full", "INDPRO")

cg_summary <- bind_rows(
    cg_small_cpi$summary,
    cg_small_indpro$summary,
    cg_medium_cpi$summary,
    cg_medium_indpro$summary,
    cg_full_cpi$summary,
    cg_full_indpro$summary
)

cat("\n=== CG Regression Results (Small Model) ===\n\n")
print(
    cg_summary %>%
        filter(model == "Small") %>%
        select(variable, horizon, beta, se, t_stat, p_value, n_obs),
    row.names = FALSE
)
cat("\n")

# ------------------------------------------------------------------------------
# 5. Interpretation
# ------------------------------------------------------------------------------

cat("Step 5: Interpretation of beta coefficients:\n\n")

interpret_beta <- function(beta, se, label) {
    if (is.na(beta)) {
        cat("  Insufficient data for interpretation.\n")
        return()
    }

    # Confidence interval
    ci_lower <- beta - 1.96 * se
    ci_upper <- beta + 1.96 * se

    cat("Model: ", label, "\n")
    cat(sprintf("  beta = %.4f (SE = %.4f)\n", beta, se))
    cat(sprintf("  95%% CI: [%.4f, %.4f]\n", ci_lower, ci_upper))

    if (abs(beta) < 1.96 * se) {
        cat("  -> Not significantly different from 0 (rational expectations)\n")
    } else if (beta > 0) {
        cat("  -> beta > 0: Under-reaction to news (sticky information)\n")
    } else {
        cat("  -> beta < 0: Over-reaction to news (diagnostic expectations)\n")
    }
    cat("\n")
}

interpret_sets <- list(
    list(model = "Small", variable = "CPI", results = cg_small_cpi$results),
    list(model = "Small", variable = "INDPRO", results = cg_small_indpro$results),
    list(model = "Medium", variable = "CPI", results = cg_medium_cpi$results),
    list(model = "Medium", variable = "INDPRO", results = cg_medium_indpro$results),
    list(model = "Full", variable = "CPI", results = cg_full_cpi$results),
    list(model = "Full", variable = "INDPRO", results = cg_full_indpro$results)
)

for (h in c(1, 3, 12)) {
    cat(sprintf("h=%d:\n", h))
    for (entry in interpret_sets) {
        label <- paste(entry$model, entry$variable)
        res <- entry$results[[paste0("h", h)]]
        interpret_beta(res$beta, res$se, label)
    }
}

# ------------------------------------------------------------------------------
# 6. Save Results
# ------------------------------------------------------------------------------

cat("Step 6: Saving CG regression results...\n")

write.csv(cg_summary, "results/tables/cg_regression_results.csv", row.names = FALSE)

# Save full datasets for visualization
saveRDS(cg_small_cpi$data, "results/forecasts/cg_data_cpi_small.rds")
saveRDS(cg_small_indpro$data, "results/forecasts/cg_data_indpro_small.rds")

cat("  Saved to results/tables/ and results/forecasts.\n\n")

# ------------------------------------------------------------------------------
# 7. Overreaction Test: DeltaBeta_h Analysis
# ------------------------------------------------------------------------------
cat("\n=== Testing for Overreaction: DeltaBeta_h = beta_Full - beta_Small ===\n\n")

compute_delta_beta <- function(results_full, results_small, horizon_name, variable) {
    delta <- results_full$beta - results_small$beta

    # Standard error of difference (assuming independence)
    se_delta <- sqrt(results_full$se^2 + results_small$se^2)

    # t-statistic
    t_stat <- delta / se_delta

    # p-value (two-tailed)
    p_value <- 2 * pt(-abs(t_stat), df = min(results_full$n_obs, results_small$n_obs) - 2)

    list(
        variable = variable,
        horizon = horizon_name,
        beta_full = results_full$beta,
        beta_small = results_small$beta,
        delta_beta = delta,
        se_delta = se_delta,
        t_stat = t_stat,
        p_value = p_value,
        interpretation = if (delta < 0) "More overreaction in Full model" else "Less overreaction in Full model"
    )
}

delta_beta_summary <- bind_rows(
    as.data.frame(compute_delta_beta(cg_full_cpi$results$h1, cg_small_cpi$results$h1, "h=1", "CPI")),
    as.data.frame(compute_delta_beta(cg_full_cpi$results$h3, cg_small_cpi$results$h3, "h=3", "CPI")),
    as.data.frame(compute_delta_beta(cg_full_cpi$results$h12, cg_small_cpi$results$h12, "h=12", "CPI")),
    as.data.frame(compute_delta_beta(cg_full_indpro$results$h1, cg_small_indpro$results$h1, "h=1", "INDPRO")),
    as.data.frame(compute_delta_beta(cg_full_indpro$results$h3, cg_small_indpro$results$h3, "h=3", "INDPRO")),
    as.data.frame(compute_delta_beta(cg_full_indpro$results$h12, cg_small_indpro$results$h12, "h=12", "INDPRO"))
)

cat("\nDeltaBeta_h = beta_Full - beta_Small:\n")
print(delta_beta_summary, row.names = FALSE)
cat("\n")

cat("Interpretation:\n")
for (i in 1:nrow(delta_beta_summary)) {
    var_label <- delta_beta_summary$variable[i]
    h <- delta_beta_summary$horizon[i]
    delta <- delta_beta_summary$delta_beta[i]
    p <- delta_beta_summary$p_value[i]

    cat(sprintf("  %s %s: DeltaBeta = %.4f", var_label, h, delta))

    if (p < 0.05) {
        if (delta < 0) {
            cat(" *** Significant overreaction in Full model\n")
        } else {
            cat(" *** Significant under-reaction in Full model\n")
        }
    } else {
        cat(sprintf(" (p = %.3f, not significant)\n", p))
    }
}

write.csv(delta_beta_summary, "results/tables/delta_beta_overreaction_test.csv", row.names = FALSE)
cat("\nSaved to results/tables/delta_beta_overreaction_test.csv\n\n")

cat("\nNext Steps:\n")
cat("  2. Run 08_visualization.R to create figures\n")
