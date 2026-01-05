# ==============================================================================
# 15_oil_price_robustness.R
# Purpose: Test whether sentiment retains predictive power after controlling
#          for oil prices (robustness check)
# Author: Jingle Fu
# Date: 2026-01-03 (FIXED)
# ==============================================================================

cat("\n=== Oil Price Robustness Check ===\n\n")
cat("Research Question: Does sentiment contain information beyond oil prices?\n")
cat("Note: This analysis uses already-generated forecasts from the main models.\n\n")

library(tidyverse)
library(xts)

# ------------------------------------------------------------------------------
# 1. Load Forecast Results and Data
# ------------------------------------------------------------------------------

cat("Step 1: Loading forecast results and data...\n")

# Load forecast results
forecasts_small <- readRDS("results/forecasts/small_model_forecasts.rds")
forecasts_medium <- readRDS("results/forecasts/medium_model_forecasts.rds")
forecasts_full <- readRDS("results/forecasts/full_model_forecasts.rds")

# Load baseline RMSFE results
rmsfe_baseline <- read.csv("results/tables/rmsfe_results.csv")

cat("  Data loaded.\n\n")

# ------------------------------------------------------------------------------
# 2. Analysis Strategy
# ------------------------------------------------------------------------------

cat("Step 2: Analyzing oil price control...\n\n")

cat("Key comparisons:\n")
cat("  1. Small (no oil, no sentiment) vs Medium (with oil, no sentiment)\n")
cat("     → Tests marginal value of oil prices\n\n")
cat("  2. Medium (with oil, no sentiment) vs Full (with oil+sentiment)\n")
cat("     → Tests marginal value of sentiment AFTER controlling for oil\n\n")

# ------------------------------------------------------------------------------
# 3. Extract and Compare RMSFEs
# ------------------------------------------------------------------------------

cat("Step 3: Comparing forecast accuracy across models...\n\n")

# Extract RMSFEs for each model
rmsfe_small_cpi <- rmsfe_baseline %>%
    filter(model == "Small", variable == "CPI")

rmsfe_medium_cpi <- rmsfe_baseline %>%
    filter(model == "Medium", variable == "CPI")

rmsfe_full_cpi <- rmsfe_baseline %>%
    filter(model == "Full", variable == "CPI")

rmsfe_small_indpro <- rmsfe_baseline %>%
    filter(model == "Small", variable == "INDPRO")

rmsfe_medium_indpro <- rmsfe_baseline %>%
    filter(model == "Medium", variable == "INDPRO")

rmsfe_full_indpro <- rmsfe_baseline %>%
    filter(model == "Full", variable == "INDPRO")

# Create comparison table
oil_control_comparison <- data.frame(
    model = rep(c("Small (baseline)", "Medium (+oil)", "Full (+oil+sentiment)"), 2),
    variable = c(rep("CPI", 3), rep("INDPRO", 3)),
    h1 = c(
        rmsfe_small_cpi$h1, rmsfe_medium_cpi$h1, rmsfe_full_cpi$h1,
        rmsfe_small_indpro$h1, rmsfe_medium_indpro$h1, rmsfe_full_indpro$h1
    ),
    h3 = c(
        rmsfe_small_cpi$h3, rmsfe_medium_cpi$h3, rmsfe_full_cpi$h3,
        rmsfe_small_indpro$h3, rmsfe_medium_indpro$h3, rmsfe_full_indpro$h3
    ),
    h12 = c(
        rmsfe_small_cpi$h12, rmsfe_medium_cpi$h12, rmsfe_full_cpi$h12,
        rmsfe_small_indpro$h12, rmsfe_medium_indpro$h12, rmsfe_full_indpro$h12
    )
)

# ------------------------------------------------------------------------------
# 4. Compute Incremental Improvements
# ------------------------------------------------------------------------------

cat("Step 4: Computing incremental improvements...\n\n")

# Oil's marginal value: (Small - Medium) / Small * 100
oil_improvement_cpi_h12 <- (rmsfe_small_cpi$h12 - rmsfe_medium_cpi$h12) / rmsfe_small_cpi$h12 * 100

# Sentiment's marginal value AFTER oil: (Medium - Full) / Medium * 100
sentiment_improvement_cpi_h12 <- (rmsfe_medium_cpi$h12 - rmsfe_full_cpi$h12) / rmsfe_medium_cpi$h12 * 100

# Same for INDPRO
oil_improvement_indpro_h12 <- (rmsfe_small_indpro$h12 - rmsfe_medium_indpro$h12) / rmsfe_small_indpro$h12 * 100
sentiment_improvement_indpro_h12 <- (rmsfe_medium_indpro$h12 - rmsfe_full_indpro$h12) / rmsfe_medium_indpro$h12 * 100

# Create summary
incremental_improvements <- data.frame(
    variable = c("CPI", "CPI", "INDPRO", "INDPRO"),
    comparison = rep(c("Oil (Medium vs Small)", "Sentiment (Full vs Medium)"), 2),
    h1_improvement_pct = c(
        (rmsfe_small_cpi$h1 - rmsfe_medium_cpi$h1) / rmsfe_small_cpi$h1 * 100,
        (rmsfe_medium_cpi$h1 - rmsfe_full_cpi$h1) / rmsfe_medium_cpi$h1 * 100,
        (rmsfe_small_indpro$h1 - rmsfe_medium_indpro$h1) / rmsfe_small_indpro$h1 * 100,
        (rmsfe_medium_indpro$h1 - rmsfe_full_indpro$h1) / rmsfe_medium_indpro$h1 * 100
    ),
    h3_improvement_pct = c(
        (rmsfe_small_cpi$h3 - rmsfe_medium_cpi$h3) / rmsfe_small_cpi$h3 * 100,
        (rmsfe_medium_cpi$h3 - rmsfe_full_cpi$h3) / rmsfe_medium_cpi$h3 * 100,
        (rmsfe_small_indpro$h3 - rmsfe_medium_indpro$h3) / rmsfe_small_indpro$h3 * 100,
        (rmsfe_medium_indpro$h3 - rmsfe_full_indpro$h3) / rmsfe_medium_indpro$h3 * 100
    ),
    h12_improvement_pct = c(
        oil_improvement_cpi_h12,
        sentiment_improvement_cpi_h12,
        oil_improvement_indpro_h12,
        sentiment_improvement_indpro_h12
    )
)

# ------------------------------------------------------------------------------
# 5. Save Results
# ------------------------------------------------------------------------------

cat("Step 5: Saving results...\n")

dir.create("results/robustness/oil_control/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(oil_control_comparison,
    "results/robustness/oil_control/tables/rmsfe_comparison.csv",
    row.names = FALSE
)

write.csv(incremental_improvements,
    "results/robustness/oil_control/tables/incremental_value.csv",
    row.names = FALSE
)

cat("  Saved to results/robustness/oil_control/tables/\n\n")

# ------------------------------------------------------------------------------
# 6. Display and Interpret Results
# ------------------------------------------------------------------------------

cat("\n=== Oil Price Robustness Results ===\n\n")

cat("RMSFE Comparison:\n")
print(oil_control_comparison, row.names = FALSE)
cat("\n")

cat("Incremental Improvements (%):\n")
print(incremental_improvements, row.names = FALSE)
cat("\n")

cat("Interpretation:\n")
cat(sprintf("  CPI h=12:\n"))
cat(sprintf("    - Oil adds: %.2f%% improvement over Small model\n", oil_improvement_cpi_h12))
cat(sprintf("    - Sentiment adds: %.2f%% improvement AFTER controlling for oil\n", sentiment_improvement_cpi_h12))

if (sentiment_improvement_cpi_h12 > 0) {
    cat("\n  ✓ CONCLUSION: Sentiment retains predictive power after controlling for oil prices.\n")
} else {
    cat("\n  ✗ CONCLUSION: Sentiment does not improve forecasts beyond oil control.\n")
}

cat(sprintf("\n  INDPRO h=12:\n"))
cat(sprintf("    - Oil adds: %.2f%% improvement over Small model\n", oil_improvement_indpro_h12))
cat(sprintf("    - Sentiment adds: %.2f%% improvement AFTER controlling for oil\n", sentiment_improvement_indpro_h12))

cat("\n✓ Oil price robustness check complete!\n\n")
