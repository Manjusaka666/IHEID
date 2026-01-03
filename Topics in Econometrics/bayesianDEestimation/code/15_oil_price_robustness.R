# ==============================================================================
# 15_oil_price_robustness.R
# Purpose: Test whether sentiment retains predictive power after controlling
#          for oil prices (robustness check)
# Author: Jingle Fu
# Date: 2026-01-02
# ==============================================================================

cat("\n=== Oil Price Robustness Check ===\n\n")
cat("Research Question: Does sentiment contain information beyond oil prices?\n")
cat("Approach: Compare Small vs Small+Oil and Full vs Full-Oil (excl. sentiment)\n\n")

library(tidyverse)
library(BVAR)

# ------------------------------------------------------------------------------
# 1. Load Data
# ------------------------------------------------------------------------------

cat("Step 1: Loading processed data...\n")

data_small_est <- readRDS("data/processed/data_small_estimation.rds")
data_medium_est <- readRDS("data/processed/data_medium_estimation.rds")
data_full_est <- readRDS("data/processed/data_full_estimation.rds")

data_small_eval <- readRDS("data/processed/data_small_evaluation.rds")
data_medium_eval <- readRDS("data/processed/data_medium_evaluation.rds")
data_full_eval <- readRDS("data/processed/data_full_evaluation.rds")

cat("  Data loaded.\n\n")

# ------------------------------------------------------------------------------
# 2. Create Oil-Specific Model Specifications
# ------------------------------------------------------------------------------

cat("Step 2: Creating oil-specific model subsets...\n")

# Small + Oil model (Small variables + DCOILWTICO, no UMCSENT)
small_oil_vars <- c("INDPRO", "CPIAUCSL", "UNRATE", "FEDFUNDS", "DCOILWTICO")
data_small_oil_est <- data_medium_est[, small_oil_vars]
data_small_oil_eval <- data_medium_eval[, small_oil_vars]

# Full - Oil model (All variables except DCOILWTICO)
full_no_oil_vars <- c("INDPRO", "CPIAUCSL", "UNRATE", "FEDFUNDS", "GS10", "SP500", "UMCSENT")
data_full_no_oil_est <- data_full_est[, full_no_oil_vars]
data_full_no_oil_eval <- data_full_eval[, full_no_oil_vars]

cat(sprintf("  Small+Oil model: %d variables\n", ncol(data_small_oil_est)))
cat(sprintf("  Full-Oil model: %d variables\n", ncol(data_full_no_oil_est)))
cat("\n")

# ------------------------------------------------------------------------------
# 3. Helper Functions (from previous scripts)
# ------------------------------------------------------------------------------

source("code/04_bvar_estimation.R") # Load estimate_bvar_model function

# ------------------------------------------------------------------------------
# 4. Recursive Forecasting for Oil-Augmented Models
# ------------------------------------------------------------------------------

cat("Step 3: Running recursive forecasting for oil-augmented models...\n")
cat("  This may take 15-20 minutes per model...\n\n")

# Forecast configuration
initial_window_end <- "2000-12-31"
forecast_horizons <- c(1, 3, 12)

# Small + Oil model
cat("  Estimating Small+Oil model recursively...\n")
forecasts_small_oil <- list()
checkpoint_file <- "results/robustness/oil_control/forecasts/small_oil_checkpoint.rds"

for (i in seq_along(index(data_small_oil_est))) {
    origin_date <- index(data_small_oil_est)[i]

    if (origin_date <= as.Date(initial_window_end)) next

    if ((i - sum(index(data_small_oil_est) <= as.Date(initial_window_end))) %% 50 == 0) {
        cat(sprintf("    Origin %d: %s\n", i, origin_date))
        if (length(forecasts_small_oil) > 0) {
            saveRDS(forecasts_small_oil, checkpoint_file)
        }
    }

    train_data <- window(data_small_oil_est, end = origin_date)

    result <- estimate_bvar_model(
        data = train_data,
        lags = 12,
        forecast_horizons = forecast_horizons,
        n_draws = 10000,
        n_burn = 5000,
        origin_date = origin_date,
        origin_idx = i
    )

    forecasts_small_oil[[i]] <- result
}

saveRDS(forecasts_small_oil, "results/robustness/oil_control/forecasts/small_oil_model_forecasts.rds")
cat("  ✓ Small+Oil forecasts complete.\n\n")

# Full - Oil model
cat("  Estimating Full-Oil model recursively...\n")
forecasts_full_no_oil <- list()
checkpoint_file <- "results/robustness/oil_control/forecasts/full_no_oil_checkpoint.rds"

for (i in seq_along(index(data_full_no_oil_est))) {
    origin_date <- index(data_full_no_oil_est)[i]

    if (origin_date <= as.Date(initial_window_end)) next

    if ((i - sum(index(data_full_no_oil_est) <= as.Date(initial_window_end))) %% 50 == 0) {
        cat(sprintf("    Origin %d: %s\n", i, origin_date))
        if (length(forecasts_full_no_oil) > 0) {
            saveRDS(forecasts_full_no_oil, checkpoint_file)
        }
    }

    train_data <- window(data_full_no_oil_est, end = origin_date)

    result <- estimate_bvar_model(
        data = train_data,
        lags = 12,
        forecast_horizons = forecast_horizons,
        n_draws = 10000,
        n_burn = 5000,
        origin_date = origin_date,
        origin_idx = i
    )

    forecasts_full_no_oil[[i]] <- result
}

saveRDS(forecasts_full_no_oil, "results/robustness/oil_control/forecasts/full_no_oil_model_forecasts.rds")
cat("  ✓ Full-Oil forecasts complete.\n\n")

# ------------------------------------------------------------------------------
# 5. Forecast Evaluation
# ------------------------------------------------------------------------------

cat("Step 4: Computing RMSFEs for oil-augmented models...\n")

source("code/06_forecast_evaluation.R") # Load compute_rmsfe function

# Load baseline results for comparison
rmsfe_baseline <- read.csv("results/tables/rmsfe_results.csv")

# Compute RMSFEs for Small+Oil
rmsfe_small_oil_cpi <- compute_rmsfe(
    forecasts = forecasts_small_oil,
    data_est = data_small_oil_est,
    data_eval = data_small_oil_eval,
    var_name = "CPIAUCSL",
    is_log = TRUE,
    horizons = forecast_horizons
)

rmsfe_small_oil_indpro <- compute_rmsfe(
    forecasts = forecasts_small_oil,
    data_est = data_small_oil_est,
    data_eval = data_small_oil_eval,
    var_name = "INDPRO",
    is_log = TRUE,
    horizons = forecast_horizons
)

# Compute RMSFEs for Full-Oil
rmsfe_full_no_oil_cpi <- compute_rmsfe(
    forecasts = forecasts_full_no_oil,
    data_est = data_full_no_oil_est,
    data_eval = data_full_no_oil_eval,
    var_name = "CPIAUCSL",
    is_log = TRUE,
    horizons = forecast_horizons
)

rmsfe_full_no_oil_indpro <- compute_rmsfe(
    forecasts = forecasts_full_no_oil,
    data_est = data_full_no_oil_est,
    data_eval = data_full_no_oil_eval,
    var_name = "INDPRO",
    is_log = TRUE,
    horizons = forecast_horizons
)

# Create comparison table
rmsfe_oil_comparison <- data.frame(
    model = c(
        "Small", "Small+Oil", "Medium (w/ Oil)", "Full (w/ Oil)",
        "Full-Oil (no sentiment)",
        "Small", "Small+Oil", "Medium (w/ Oil)", "Full (w/ Oil)",
        "Full-Oil (no sentiment)"
    ),
    variable = c(rep("CPI", 5), rep("INDPRO", 5)),
    h1 = c(
        rmsfe_baseline$h1[rmsfe_baseline$model == "Small" & rmsfe_baseline$variable == "CPI"],
        rmsfe_small_oil_cpi$h1,
        rmsfe_baseline$h1[rmsfe_baseline$model == "Medium" & rmsfe_baseline$variable == "CPI"],
        rmsfe_baseline$h1[rmsfe_baseline$model == "Full" & rmsfe_baseline$variable == "CPI"],
        rmsfe_full_no_oil_cpi$h1,
        rmsfe_baseline$h1[rmsfe_baseline$model == "Small" & rmsfe_baseline$variable == "INDPRO"],
        rmsfe_small_oil_indpro$h1,
        rmsfe_baseline$h1[rmsfe_baseline$model == "Medium" & rmsfe_baseline$variable == "INDPRO"],
        rmsfe_baseline$h1[rmsfe_baseline$model == "Full" & rmsfe_baseline$variable == "INDPRO"],
        rmsfe_full_no_oil_indpro$h1
    ),
    h3 = c(
        rmsfe_baseline$h3[rmsfe_baseline$model == "Small" & rmsfe_baseline$variable == "CPI"],
        rmsfe_small_oil_cpi$h3,
        rmsfe_baseline$h3[rmsfe_baseline$model == "Medium" & rmsfe_baseline$variable == "CPI"],
        rmsfe_baseline$h3[rmsfe_baseline$model == "Full" & rmsfe_baseline$variable == "CPI"],
        rmsfe_full_no_oil_cpi$h3,
        rmsfe_baseline$h3[rmsfe_baseline$model == "Small" & rmsfe_baseline$variable == "INDPRO"],
        rmsfe_small_oil_indpro$h3,
        rmsfe_baseline$h3[rmsfe_baseline$model == "Medium" & rmsfe_baseline$variable == "INDPRO"],
        rmsfe_baseline$h3[rmsfe_baseline$model == "Full" & rmsfe_baseline$variable == "INDPRO"],
        rmsfe_full_no_oil_indpro$h3
    ),
    h12 = c(
        rmsfe_baseline$h12[rmsfe_baseline$model == "Small" & rmsfe_baseline$variable == "CPI"],
        rmsfe_small_oil_cpi$h12,
        rmsfe_baseline$h12[rmsfe_baseline$model == "Medium" & rmsfe_baseline$variable == "CPI"],
        rmsfe_baseline$h12[rmsfe_baseline$model == "Full" & rmsfe_baseline$variable == "CPI"],
        rmsfe_full_no_oil_cpi$h12,
        rmsfe_baseline$h12[rmsfe_baseline$model == "Small" & rmsfe_baseline$variable == "INDPRO"],
        rmsfe_small_oil_indpro$h12,
        rmsfe_baseline$h12[rmsfe_baseline$model == "Medium" & rmsfe_baseline$variable == "INDPRO"],
        rmsfe_baseline$h12[rmsfe_baseline$model == "Full" & rmsfe_baseline$variable == "INDPRO"],
        rmsfe_full_no_oil_indpro$h12
    )
)

write.csv(rmsfe_oil_comparison,
    "results/robustness/oil_control/tables/rmsfe_comparison.csv",
    row.names = FALSE
)

cat("\n=== Oil Price Robustness Results ===\n\n")
print(rmsfe_oil_comparison)
cat("\n")

# ------------------------------------------------------------------------------
# 6. Interpretation
# ------------------------------------------------------------------------------

cat("Step 5: Interpretation...\n\n")

cat("Key Questions:\n")
cat("  Q1: Does adding oil to Small model improve forecasts?\n")
cat("      → Compare 'Small' vs 'Small+Oil' RMSFEs\n\n")

cat("  Q2: Does sentiment retain value after controlling for oil?\n")
cat("      → Compare 'Full-Oil' vs 'Full (w/ Oil)' RMSFEs\n")
cat("      → If Full (w/ sentiment + oil) < Full-Oil (no sentiment),\n")
cat("         then sentiment provides information beyond oil prices\n\n")

# Compute incremental value
full_oil_rmsfe_cpi_h12 <- rmsfe_baseline$h12[rmsfe_baseline$model == "Full" & rmsfe_baseline$variable == "CPI"]
full_no_oil_rmsfe_cpi_h12 <- rmsfe_full_no_oil_cpi$h12
sentiment_increment <- (full_no_oil_rmsfe_cpi_h12 - full_oil_rmsfe_cpi_h12) / full_no_oil_rmsfe_cpi_h12 * 100

cat(sprintf("Example (CPI, h=12):\n"))
cat(sprintf("  Full-Oil (no sentiment): %.3f\n", full_no_oil_rmsfe_cpi_h12))
cat(sprintf("  Full (w/ sentiment+oil): %.3f\n", full_oil_rmsfe_cpi_h12))
cat(sprintf("  Sentiment incremental improvement: %.2f%%\n\n", sentiment_increment))

if (sentiment_increment > 0) {
    cat("✓ CONCLUSION: Sentiment retains predictive power after controlling for oil prices.\n")
} else {
    cat("✗ CONCLUSION: Sentiment does not improve forecasts beyond oil control.\n")
}

cat("\n✓ Oil price robustness check complete!\n")
cat("Results saved to results/robustness/oil_control/\n\n")
