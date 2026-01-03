# ==============================================================================
# main_analysis.R
# Purpose: Master orchestration script for Bayesian DE Estimation
# Author: Jingle Fu
# Date: 2025-12-26
# ==============================================================================

cat("\n")
cat("╔════════════════════════════════════════════════════════════════════╗\n")
cat("║                                                                    ║\n")
cat("║         Forecasting Horse Races and Belief Distortions            ║\n")
cat("║     A Hierarchical Bayesian VAR Study with Sentiment Signals      ║\n")
cat("║                                                                    ║\n")
cat("╚════════════════════════════════════════════════════════════════════╝\n")
cat("\n")

# ==============================================================================
# Configuration
# ==============================================================================

# Set working directory to project root (if not already there)
if (!file.exists("code/01_setup_environment.R")) {
    stop("Please run this script from the project root directory.")
}

# Track execution time
start_time <- Sys.time()

# Create log file
log_file <- file.path("results", paste0("analysis_log_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".txt"))
sink(log_file, split = TRUE)

cat("Analysis started at:", format(start_time, "%Y-%m-%d %H:%M:%S"), "\n\n")

# ==============================================================================
# Pipeline Execution
# ==============================================================================

# ------------------------------------------------------------------------------
# Phase 1: Environment Setup
# ------------------------------------------------------------------------------

cat("\n")
cat("═══════════════════════════════════════════════════\n")
cat("  PHASE 1: ENVIRONMENT SETUP\n")
cat("═══════════════════════════════════════════════════\n")

tryCatch(
    {
        source("code/01_setup_environment.R")
        cat("\n✓ Phase 1 complete.\n")
    },
    error = function(e) {
        cat("\n✗ Error in Phase 1:", e$message, "\n")
        stop("Pipeline halted due to error in Phase 1.")
    }
)

# ------------------------------------------------------------------------------
# Phase 2: Data Acquisition
# ------------------------------------------------------------------------------

cat("\n")
cat("═══════════════════════════════════════════════════\n")
cat("  PHASE 2: DATA ACQUISITION\n")
cat("═══════════════════════════════════════════════════\n")

# Check if data already exists
if (file.exists("data/raw/data_full_raw.rds")) {
    cat("\n⚠ Raw data already exists. Skip download? (y/n): ")
    response <- readline()
    if (tolower(response) != "y") {
        source("code/02_data_acquisition.R")
    } else {
        cat("  Skipping data acquisition.\n")
    }
} else {
    tryCatch(
        {
            source("code/02_data_acquisition.R")
            cat("\n✓ Phase 2 complete.\n")
        },
        error = function(e) {
            cat("\n✗ Error in Phase 2:", e$message, "\n")
            stop("Pipeline halted due to error in Phase 2.")
        }
    )
}

# ------------------------------------------------------------------------------
# Phase 3: Data Transformation
# ------------------------------------------------------------------------------

cat("\n")
cat("═══════════════════════════════════════════════════\n")
cat("  PHASE 3: DATA TRANSFORMATION\n")
cat("═══════════════════════════════════════════════════\n")

tryCatch(
    {
        source("code/03_data_transformation.R")
        cat("\n✓ Phase 3 complete.\n")
    },
    error = function(e) {
        cat("\n✗ Error in Phase 3:", e$message, "\n")
        stop("Pipeline halted due to error in Phase 3.")
    }
)

# ------------------------------------------------------------------------------
# Phase 4: BVAR Estimation (Test)
# ------------------------------------------------------------------------------

cat("\n")
cat("═══════════════════════════════════════════════════\n")
cat("  PHASE 4: BVAR ESTIMATION SETUP\n")
cat("═══════════════════════════════════════════════════\n")

tryCatch(
    {
        source("code/04_bvar_estimation.R")
        cat("\n✓ Phase 4 complete.\n")
    },
    error = function(e) {
        cat("\n✗ Error in Phase 4:", e$message, "\n")
        stop("Pipeline halted due to error in Phase 4.")
    }
)

# ------------------------------------------------------------------------------
# Phase 5: Recursive Forecasting (⚠ LONG RUNTIME)
# ------------------------------------------------------------------------------

cat("\n")
cat("═══════════════════════════════════════════════════\n")
cat("  PHASE 5: RECURSIVE FORECASTING\n")
cat("═══════════════════════════════════════════════════\n\n")
cat("⚠ WARNING: This phase will take 30-45 minutes.\n")
cat("  Progress will be checkpointed every 50 origins.\n\n")
tryCatch(
    {
        source("code/05_recursive_forecasting.R")
        cat("\n✓ Phase 5 complete.\n")
    },
    error = function(e) {
        cat(sprintf("\n✗ Error in Phase 5: %s\n", e$message))
        stop("Pipeline halted due to error in Phase 5.")
    }
)

# ------------------------------------------------------------------------------
# Phase 6: Forecast Evaluation
# ------------------------------------------------------------------------------

cat("\n")
cat("═══════════════════════════════════════════════════\n")
cat("  PHASE 6: FORECAST EVALUATION\n")
cat("═══════════════════════════════════════════════════\n")

tryCatch(
    {
        source("code/06_forecast_evaluation.R")
        cat("\n✓ Phase 6 complete.\n")
    },
    error = function(e) {
        cat("\n✗ Error in Phase 6:", e$message, "\n")
        stop("Pipeline halted due to error in Phase 6.")
    }
)

# ------------------------------------------------------------------------------
# Phase 7: CG Regression
# ------------------------------------------------------------------------------

cat("\n")
cat("═══════════════════════════════════════════════════\n")
cat("  PHASE 7: COIBION-GORODNICHENKO REGRESSION\n")
cat("═══════════════════════════════════════════════════\n")

tryCatch(
    {
        source("code/07_cg_regression.R")
        cat("\n✓ Phase 7 complete.\n")
    },
    error = function(e) {
        cat("\n✗ Error in Phase 7:", e$message, "\n")
        stop("Pipeline halted due to error in Phase 7.")
    }
)

# ------------------------------------------------------------------------------
# Phase 8: Visualization
# ------------------------------------------------------------------------------
cat("\n")
cat("═══════════════════════════════════════════════════\n")
cat("  PHASE 8: VISUALIZATION\n")
cat("═══════════════════════════════════════════════════\n\n")
tryCatch(
    {
        source("code/08_visualization.R")
        cat("\n✓ Phase 8 complete.\n")
    },
    error = function(e) {
        cat(sprintf("\n✗ Error in Phase 8: %s\n", e$message))
        stop("Pipeline halted due to error in Phase 8.")
    }
)

# ------------------------------------------------------------------------------
# Phase 9-11: Robustness Suite (Optional)
# ------------------------------------------------------------------------------
cat("\n")
cat("=============================================================================\n")
cat("  PHASE 9-11: ROBUSTNESS SUITE (OPTIONAL)\n")
cat("=============================================================================\n\n")
cat("? Run robustness checks + robustness figures + rolling diagnostics? (y/n): ")
run_robustness <- readline()
if (tolower(run_robustness) == "y") {
    tryCatch(
        {
            source("code/09_robustness_checks.R")
            cat("\n? Phase 9 complete.\n")
        },
        error = function(e) {
            cat(sprintf("\n? Error in Phase 9: %s\n", e$message))
            stop("Pipeline halted due to error in Phase 9.")
        }
    )

    tryCatch(
        {
            source("code/10_robustness_visualization.R")
            cat("\n? Phase 10 complete.\n")
        },
        error = function(e) {
            cat(sprintf("\n? Error in Phase 10: %s\n", e$message))
            stop("Pipeline halted due to error in Phase 10.")
        }
    )

    tryCatch(
        {
            source("code/11_error_decomposition_and_rolling_rmsfe.R")
            cat("\n? Phase 11 complete.\n")
        },
        error = function(e) {
            cat(sprintf("\n? Error in Phase 11: %s\n", e$message))
            stop("Pipeline halted due to error in Phase 11.")
        }
    )
} else {
    cat("  Skipping robustness suite.\n\n")
}

# ==============================================================================
# Completion Summary
# ==============================================================================

end_time <- Sys.time()
elapsed <- difftime(end_time, start_time, units = "mins")

cat("\n")
cat("╔════════════════════════════════════════════════════════════════════╗\n")
cat("║                                                                    ║\n")
cat("║                  ANALYSIS PIPELINE COMPLETE                        ║\n")
cat("║                                                                    ║\n")
cat("╚════════════════════════════════════════════════════════════════════╝\n")
cat("\n")

cat("Execution Summary:\n")
cat(sprintf("  Start time: %s\n", format(start_time, "%Y-%m-%d %H:%M:%S")))
cat(sprintf("  End time: %s\n", format(end_time, "%Y-%m-%d %H:%M:%S")))
cat(sprintf("  Total elapsed time: %.1f minutes\n", as.numeric(elapsed)))
cat("\n")

cat("Output Files:\n")
cat("  Data:\n")
cat("    - data/processed/*.rds (estimation and evaluation data)\n")
cat("  Forecasts:\n")
cat("    - results/forecasts/*_model_forecasts.rds\n")
cat("    - results/forecasts/hyperparameters_evolution.csv\n")
cat("  Tables:\n")
cat("    - results/tables/rmsfe_results.csv\n")
cat("    - results/tables/relative_rmsfe.csv\n")
cat("    - results/tables/cg_regression_results.csv\n")
cat("  Diagnostics:\n")
cat("    - results/diagnostics/*.rds\n")
cat("\n")

cat("Next Steps:\n")
cat("  1. Review results in results/tables/\n")
cat("  2. Integrate findings into ForecastingHorseRace.tex\n")
cat("\n")

cat("Log saved to:", log_file, "\n\n")

# Close log
sink()

cat("✓ All phases completed successfully!\n\n")
