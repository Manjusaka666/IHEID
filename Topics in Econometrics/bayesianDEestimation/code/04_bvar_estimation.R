# ==============================================================================
# 04_bvar_estimation.R
# Purpose: Hierarchical BVAR estimation with optimal hyperparameter selection
# Author: Jingle Fu
# Date: 2025-12-26
# ==============================================================================

cat("\n=== Hierarchical BVAR Estimation Setup ===\n\n")

library(BVAR)
library(tidyverse)
library(xts)

# ------------------------------------------------------------------------------
# 1. Configure Hierarchical Priors
# ------------------------------------------------------------------------------

cat("Step 1: Configuring hierarchical priors...\n\n")

# Set up Minnesota prior with hierarchical hyperparameter selection
setup_hierarchical_priors <- function() {
    # Calibrated to reflect information rigidities in realistic forecasting environments
    # Lambda: Stronger shrinkage (0.05) mimics institutional inertia and delayed information processing
    # Alpha: Higher lag decay (3.0) can induce trend-chasing behavior (overreaction at long horizons)
    lambda_mode <- getOption("bayesian_de.lambda_mode", 0.05)
    lambda_sd <- getOption("bayesian_de.lambda_sd", 0.2)
    lambda_min <- getOption("bayesian_de.lambda_min", 1e-3)
    lambda_max <- getOption("bayesian_de.lambda_max", 2.0)

    alpha_mode <- getOption("bayesian_de.alpha_mode", 3.0)
    alpha_sd <- getOption("bayesian_de.alpha_sd", 0.25)
    alpha_min <- getOption("bayesian_de.alpha_min", 1)
    alpha_max <- getOption("bayesian_de.alpha_max", 3)

    priors <- bv_priors(
        hyper = "auto", # Automatic hierarchical selection
        mn = bv_mn(
            # Overall tightness (lambda): data-driven selection
            lambda = bv_lambda(
                mode = lambda_mode,
                sd = lambda_sd,
                min = lambda_min,
                max = lambda_max
            ),
            # Lag decay (alpha): paper baseline is approximately 1/ℓ^2 (alpha≈2)
            alpha = bv_alpha(
                mode = alpha_mode,
                sd = alpha_sd,
                min = alpha_min,
                max = alpha_max
            ),
            # Cross-variable shrinkage (psi)
            # Use auto mode to match dimensions consistently across models.
            psi = bv_psi(mode = "auto")
            # Cross-variable shrinkage (psi): not used in standard setup
            #     psi = bv_psi(mode = "auto")
        ),
        # Sum-of-coefficients prior (helps with unit roots)
        soc = bv_soc(
            mode = 1,
            sd = 1,
            min = 1e-4,
            max = 50
        ),
        # Dummy-initial-observation prior
        sur = bv_sur(
            mode = 1,
            sd = 1,
            min = 1e-4,
            max = 50
        )
    )

    cat("  ✓ Hierarchical priors configured:\n")
    cat(sprintf("    - Minnesota: lambda ~ Gamma(mode=%.3f, sd=%.3f) with bounds [%.4f, %.2f]\n", lambda_mode, lambda_sd, lambda_min, lambda_max))
    cat(sprintf("    - Minnesota: alpha fixed at %.3f (bounds [%.2f, %.2f])\n", alpha_mode, alpha_min, alpha_max))
    cat("    - Sum-of-coefficients prior (unit-root accommodation)\n")
    cat("    - Dummy-initial-observation prior\n\n")

    return(priors)
}

priors_config <- setup_hierarchical_priors()

# ------------------------------------------------------------------------------
# 2. Set MCMC Parameters
# ------------------------------------------------------------------------------

cat("Step 2: Configuring MCMC parameters...\n")

mcmc_config <- list(
    n_draw = getOption("bayesian_de.n_draw", 10000L), # Total MCMC draws
    n_burn = getOption("bayesian_de.n_burn", 5000L), # Burn-in period
    n_thin = 1, # Thinning (1 = no thinning)
    verbose = FALSE # Suppress iteration output
)

cat(sprintf("  Total draws: %d\n", mcmc_config$n_draw))
cat(sprintf("  Burn-in: %d\n", mcmc_config$n_burn))
cat(sprintf("  Effective draws: %d\n\n", mcmc_config$n_draw - mcmc_config$n_burn))

# ------------------------------------------------------------------------------
# 3. BVAR Estimation Function
# ------------------------------------------------------------------------------

cat("Step 3: Defining BVAR estimation function...\n\n")

#' Estimate Hierarchical BVAR
#'
#' @param data xts object with variables in columns
#' @param lags Number of lags (default: 12)
#' @param priors Prior specification from bv_priors()
#' @param n_draw Number of MCMC draws
#' @param n_burn Burn-in draws
#' @return BVAR object with posterior draws and optimal hyperparameters
estimate_bvar_model <- function(data,
                                lags = 12,
                                priors = NULL,
                                n_draw = 10000,
                                n_burn = 5000) {
    # Use default priors if none provided
    if (is.null(priors)) {
        priors <- setup_hierarchical_priors()
    }

    # Convert xts to matrix if needed
    if (inherits(data, "xts") || inherits(data, "zoo")) {
        data_matrix <- coredata(data)
    } else {
        data_matrix <- as.matrix(data)
    }

    # Estimate BVAR
    bvar_fit <- bvar(
        data = data_matrix,
        lags = lags,
        n_draw = n_draw,
        n_burn = n_burn,
        priors = priors,
        mh = bv_mh(), # Metropolis-Hastings for hyperparameters
        fcast = NULL, # Don't compute forecasts yet (do separately)
        irf = NULL, # No IRFs needed for forecasting
        verbose = FALSE
    )

    return(bvar_fit)
}

# ------------------------------------------------------------------------------
# 4. Test Estimation on Full Sample
# ------------------------------------------------------------------------------

cat("Step 4: Testing BVAR estimation on full sample...\n")
cat("  (This verifies the setup before recursive forecasting)\n\n")

# Load processed data
data_small <- readRDS("data/processed/data_small_estimation.rds")
data_medium <- readRDS("data/processed/data_medium_estimation.rds")
data_full <- readRDS("data/processed/data_full_estimation.rds")

cat("Data loaded. Estimating small model on full sample...\n")

# Estimate small model (fastest for testing)
test_fit <- suppressWarnings(
    estimate_bvar_model(
        data = data_small,
        lags = 12,
        priors = priors_config,
        n_draw = mcmc_config$n_draw,
        n_burn = mcmc_config$n_burn
    )
)

cat("✓ Estimation successful!\n")

# ------------------------------------------------------------------------------
# 5. Extract and Display Hyperparameters
# ------------------------------------------------------------------------------

cat("Step 5: Optimal hyperparameters from test estimation:\n\n")

cat("Minnesota Prior:\n")
cat("  Hyperparameters auto-optimized via marginal likelihood\n")

# Extract hyperparameters
if (is.matrix(test_fit$hyper)) {
    hyper_means <- colMeans(test_fit$hyper)

    cat("Minnesota Prior (Posterior Means):\n")

    # 提取各个超参数
    if ("lambda" %in% names(hyper_means)) {
        cat(sprintf("  Lambda (tightness): %.4f\n", hyper_means["lambda"]))
    }
    if ("alpha" %in% names(hyper_means)) {
        cat(sprintf("  Alpha (lag decay): %.4f\n", hyper_means["alpha"]))
    }
    if ("psi" %in% names(hyper_means)) {
        cat(sprintf("  Psi (cross-variable): %.4f\n", hyper_means["psi"]))
    }

    cat("\nOther Priors (Posterior Means):\n")
    if ("soc" %in% names(hyper_means)) {
        cat(sprintf("  SOC (sum-of-coef): %.4f\n", hyper_means["soc"]))
    }
    if ("sur" %in% names(hyper_means)) {
        cat(sprintf("  SUR (dummy-init-obs): %.4f\n", hyper_means["sur"]))
    }
} else {
    cat("⚠ Warning: Unexpected hyper structure\n")
    print(str(test_fit$hyper))
}
cat("\n")
if (!is.null(test_fit$ml)) {
    # Only take the final value
    final_ml <- tail(test_fit$ml, 1)
    cat(sprintf("  Log-marginal likelihood (final): %.2f\n", final_ml))
} else if (!is.null(test_fit$log_ml)) {
    # If log_ml is a vector, also take the final value
    final_ml <- tail(test_fit$log_ml, 1)
    cat(sprintf("  Log-marginal likelihood (final): %.2f\n", final_ml))
} else {
    cat("  Log-marginal likelihood: not available\n")
}
cat("✓ Test estimation complete!\n")
cat("  BVAR setup verified and ready for recursive forecasting.\n\n")

# ------------------------------------------------------------------------------
# 6. Generate Test Forecast
# ------------------------------------------------------------------------------

cat("Step 6: Generating test forecasts (h=1,3,12)...\n")

test_fcast <- predict(test_fit, horizon = 13, conf_bands = 0.68)

cat("✓ Forecast generated.\n")
cat(sprintf(
    "  Forecast dimensions: %d horizons × %d variables\n",
    dim(test_fcast$fcast)[1], dim(test_fcast$fcast)[2]
))

# Display forecast for CPI at different horizons
cpi_idx <- which(colnames(data_small) == "CPIAUCSL")
if (length(cpi_idx) > 0) {
    cat("\nExample: CPI forecasts (log-level):\n")
    cat(sprintf("  h=1:  %.4f\n", test_fcast$fcast[1, cpi_idx, 1]))
    cat(sprintf("  h=3:  %.4f\n", test_fcast$fcast[3, cpi_idx, 1]))
    cat(sprintf("  h=12: %.4f\n", test_fcast$fcast[12, cpi_idx, 1]))
}

cat("\n")

# ------------------------------------------------------------------------------
# 7. Save Test Results
# ------------------------------------------------------------------------------

cat("Step 7: Saving test estimation results...\n")

saveRDS(test_fit, "results/diagnostics/test_bvar_fit.rds")
saveRDS(test_fcast, "results/diagnostics/test_forecast.rds")

if (is.matrix(test_fit$hyper)) {
    hyper_means <- colMeans(test_fit$hyper)

    # Save hyperparameters
    hyperparams_summary <- data.frame(
        parameter = names(hyper_means),
        posterior_mean = as.numeric(hyper_means),
        stringsAsFactors = FALSE
    )
} else {
    hyperparams_summary <- data.frame(
        parameter = names(test_fit$hyper),
        value = as.numeric(test_fit$hyper),
        stringsAsFactors = FALSE
    )
}

write.csv(hyperparams_summary,
    "results/diagnostics/test_hyperparameters.csv",
    row.names = FALSE
)

cat("  ✓ Saved to results/diagnostics/\n\n")

# ------------------------------------------------------------------------------
# 8. Summary
# ------------------------------------------------------------------------------

cat("=== BVAR Estimation Setup Complete ===\n\n")
cat("Key points:\n")
cat("  ✓ Hierarchical priors configured with automatic hyperparameter selection\n")
cat("  ✓ MCMC settings: 10000 draws with 5000 burn-in\n")
cat("  ✓ Test estimation successful on full sample\n")
cat(sprintf("  ✓ Optimal lambda: %.4f\n", hyper_means["lambda"]))
