# ==============================================================================
# 01_setup_environment.R
# Purpose: Initialize R and Julia environments with optimal configuration
# Author: Jingle Fu
# Date: 2025-12-26
# ==============================================================================

cat("\n=== Initializing R-Julia Hybrid Environment ===\n\n")

# 0. Set CRAN mirror
# ------------------------------------------------------------------------------
options(repos = c(CRAN = "https://cloud.r-project.org"))
cat("✓ CRAN mirror set to https://cloud.r-project.org\n")

# ------------------------------------------------------------------------------
# 1. Load Required R Packages
# ------------------------------------------------------------------------------

cat("Step 1: Loading R packages...\n")

required_packages <- c(
    "BVAR", # Hierarchical Bayesian VAR
    "tidyverse", # Data manipulation
    "fredr", # FRED API
    "xts", # Time series objects
    "zoo", # Time series utilities
    "sandwich", # HAC standard errors
    "lmtest", # Statistical tests
    "xtable", # LaTeX tables
    "parallel", # Parallel computing
    "data.table", # Fast data operations
    "JuliaCall", # R-Julia interface
    "quantmod" # Time series utilities
)

# Function to install missing packages
install_if_missing <- function(pkg) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
        cat(sprintf("Installing %s...\n", pkg))
        install.packages(pkg, dependencies = TRUE, repos = "https://cloud.r-project.org")
    }
    library(pkg, character.only = TRUE, quietly = TRUE)
}

invisible(lapply(required_packages, install_if_missing))
cat("✓ All R packages loaded successfully.\n\n")

# ------------------------------------------------------------------------------
# 2. Initialize Julia (Auto-Detection)
# ------------------------------------------------------------------------------

cat("Step 2: Initializing Julia via JuliaCall...\n")

# Initialize Julia with auto-detection (Julia must be in PATH)
julia_setup(rebuild = TRUE)

cat("✓ Julia initialized successfully.\n")
cat(sprintf("  Julia version: %s\n", julia_eval("string(VERSION)")))

# Check available threads
n_julia_threads <- julia_eval("Threads.nthreads()")
cat(sprintf("  Julia threads: %d\n", n_julia_threads))

if (n_julia_threads < 4) {
    cat("  ℹ Info: Julia is using few threads. To use more threads, set JULIA_NUM_THREADS\n")
    cat("    before starting Julia, or restart Julia with: julia --threads auto\n")
}


# ------------------------------------------------------------------------------
# 3. Install and Load Julia Packages
# ------------------------------------------------------------------------------

cat("\nStep 3: Setting up Julia packages...\n")

# Install required Julia packages
julia_packages <- c("DataFrames", "CSV", "Statistics")

for (pkg in julia_packages) {
    cat(sprintf("  Checking %s.jl...\n", pkg))
    julia_install_package_if_needed(pkg)
    julia_library(pkg)
}

cat("✓ Julia packages loaded successfully.\n\n")

# ------------------------------------------------------------------------------
# 4. Load Julia Custom Functions
# ------------------------------------------------------------------------------

cat("Step 4: Loading Julia transformation functions...\n")

julia_transform_script <- file.path("julia", "transformation_functions.jl")

if (file.exists(julia_transform_script)) {
    julia_source(julia_transform_script)
    cat(sprintf("✓ Loaded %s\n", julia_transform_script))
} else {
    cat(sprintf("⚠ Warning: %s not found. Will create it.\n", julia_transform_script))
}

# ------------------------------------------------------------------------------
# 5. Set Up Parallel Computing (R)
# ------------------------------------------------------------------------------

cat("\nStep 5: Configuring R parallel computing...\n")

n_cores_total <- parallel::detectCores()
n_cores_use <- 20

cat(sprintf("  Total cores: %d\n", n_cores_total))
cat(sprintf("  Cores for parallel: %d\n", n_cores_use))

# Store in global options
options(bayesian_de.n_cores = n_cores_use)

# ------------------------------------------------------------------------------
# 6. Create Directory Structure (if needed)
# ------------------------------------------------------------------------------

cat("\nStep 6: Verifying directory structure...\n")

required_dirs <- c(
    "data/raw",
    "data/processed",
    "results/forecasts",
    "results/forecasts/checkpoints",
    "results/forecasts/diagnostics",
    "results/tables",
    "results/figures",
    "results/robustness",
    "results/diagnostics",
    "code/utils",
    "julia"
)

for (dir in required_dirs) {
    if (!dir.exists(dir)) {
        dir.create(dir, recursive = TRUE)
        cat(sprintf("  Created: %s\n", dir))
    }
}

cat("✓ Directory structure verified.\n\n")

# ------------------------------------------------------------------------------
# 7. Environment Summary
# ------------------------------------------------------------------------------

cat("=== Environment Setup Complete ===\n\n")
cat("Configuration Summary:\n")
cat(sprintf("  R version: %s\n", R.version.string))
cat(sprintf("  Julia version: %s\n", julia_eval("string(VERSION)")))
cat(sprintf("  R parallel cores: %d\n", n_cores_use))
cat(sprintf("  Julia threads: %d\n", n_julia_threads))
cat(sprintf("  Working directory: %s\n", getwd()))

cat("\n✓ Ready to proceed with data acquisition and analysis.\n\n")

# Save session info for reproducibility
writeLines(
    capture.output(sessionInfo()),
    "results/session_info.txt"
)
cat("Session info saved to results/session_info.txt\n\n")
