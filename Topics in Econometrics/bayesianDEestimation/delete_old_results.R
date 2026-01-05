# ==============================================================================
# delete_old_results.R
# Purpose: Clean up old forecast results before re-running with new priors
# Author: Jingle Fu
# Date: 2026-01-03
# ==============================================================================

cat("\n=== Deleting Old Forecast Results ===\n\n")
cat("This will remove all previous forecasts, CG results, and figures\n")
cat("generated with the old Minnesota prior parameters.\n\n")

# Files to delete
files_to_delete <- c(
    "results/forecasts/small_model_forecasts.rds",
    "results/forecasts/medium_model_forecasts.rds",
    "results/forecasts/full_model_forecasts.rds",
    "results/forecasts/hyperparameters_evolution.csv",
    "results/tables/cg_regression_results.csv",
    "results/forecasts/cg_regression_results.rds",
    "results/tables/delta_beta_overreaction_test.csv",
    "results/figures/fig3_cg_coefficients.png",
    "results/figures/fig4_delta_beta_overreaction.png",
    "results/figures/fig5_lambda_evolution.png"
)

# Delete files
deleted_count <- 0
for (file in files_to_delete) {
    if (file.exists(file)) {
        file.remove(file)
        cat(sprintf("  ✓ Deleted: %s\n", file))
        deleted_count <- deleted_count + 1
    } else {
        cat(sprintf("  ⊘ Not found: %s\n", file))
    }
}

# Delete checkpoints directory
if (dir.exists("results/forecasts/checkpoints")) {
    unlink("results/forecasts/checkpoints", recursive = TRUE)
    cat("  ✓ Deleted: results/forecasts/checkpoints/\n")
    deleted_count <- deleted_count + 1
}

# Delete CG scatter plots
cg_scatters <- list.files("results/figures", pattern = "^fig7.*\\.png$", full.names = TRUE)
for (file in cg_scatters) {
    file.remove(file)
    cat(sprintf("  ✓ Deleted: %s\n", basename(file)))
    deleted_count <- deleted_count + 1
}

# Recreate checkpoint directory
dir.create("results/forecasts/checkpoints", recursive = TRUE, showWarnings = FALSE)

cat(sprintf("\n✓ Cleanup complete! Deleted %d files/directories.\n", deleted_count))
cat("\nReady to re-run main_analysis.R with new prior parameters.\n\n")
