# ==============================================================================
# 03_data_transformation.R
# Purpose: Transform raw data to estimation-ready format using R-Julia hybrid
# Author: Jingle Fu
# Date: 2025-12-26
# ==============================================================================

cat("\n=== Starting Data Transformation ===\n\n")

library(tidyverse)
library(xts)
library(zoo)
library(JuliaCall)

# ------------------------------------------------------------------------------
# 1. Load Raw Data
# ------------------------------------------------------------------------------

cat("Step 1: Loading raw data...\n")

data_small_raw <- readRDS("data/raw/data_small_raw.rds")
data_medium_raw <- readRDS("data/raw/data_medium_raw.rds")
data_full_raw <- readRDS("data/raw/data_full_raw.rds")
variables_metadata <- readRDS("data/raw/variables_metadata.rds")

cat(sprintf("  Small: %d obs × %d vars\n", nrow(data_small_raw), ncol(data_small_raw)))
cat(sprintf("  Medium: %d obs × %d vars\n", nrow(data_medium_raw), ncol(data_medium_raw)))
cat(sprintf("  Full: %d obs × %d vars\n", nrow(data_full_raw), ncol(data_full_raw)))
cat("\n")

# ------------------------------------------------------------------------------
# 2. Apply Transformations for Estimation
# ------------------------------------------------------------------------------

cat("Step 2: Applying transformations for BVAR estimation...\n")
cat("  (Log-levels for prices/quantities, levels for rates/indices)\n\n")

# Transformation function
transform_for_estimation <- function(data_xts, metadata) {
    # Convert to data frame for easier manipulation
    df <- as.data.frame(data_xts)
    df$date <- index(data_xts)

    # Get variable names and their transformations
    for (var in colnames(data_xts)) {
        trans_type <- metadata %>%
            filter(var_name == var) %>%
            pull(transformation)

        if (length(trans_type) > 0 && trans_type[1] == "log") {
            cat(sprintf("  %s: log transformation\n", var))
            df[[paste0("log_", var)]] <- log(df[[var]])
        } else {
            cat(sprintf("  %s: level (no transformation)\n", var))
            df[[paste0("level_", var)]] <- df[[var]]
        }
    }

    return(df)
}

# Transform each dataset
df_small <- transform_for_estimation(data_small_raw, variables_metadata)
df_medium <- transform_for_estimation(data_medium_raw, variables_metadata)
df_full <- transform_for_estimation(data_full_raw, variables_metadata)

cat("\n")

# ------------------------------------------------------------------------------
# 3. Create Estimation-Ready Matrices
# ------------------------------------------------------------------------------

cat("Step 3: Creating estimation-ready matrices...\n")

# Extract transformed columns for each model
create_estimation_matrix <- function(df, vars, metadata) {
    transformed_cols <- c()

    for (var in vars) {
        trans_type <- metadata %>%
            filter(var_name == var) %>%
            pull(transformation)

        if (length(trans_type) > 0 && trans_type[1] == "log") {
            transformed_cols <- c(transformed_cols, paste0("log_", var))
        } else {
            transformed_cols <- c(transformed_cols, paste0("level_", var))
        }
    }

    # Create xts object with transformed data
    mat <- df %>%
        select(all_of(transformed_cols))

    xts_obj <- xts(mat, order.by = df$date)

    # Rename columns to original variable names
    colnames(xts_obj) <- vars

    return(xts_obj)
}

small_vars <- c("INDPRO", "CPIAUCSL", "UNRATE", "FEDFUNDS")
medium_vars <- c(small_vars, "GS10", "SP500", "DCOILWTICO")
full_vars <- c(medium_vars, "UMCSENT")

data_small_est <- create_estimation_matrix(df_small, small_vars, variables_metadata)
data_medium_est <- create_estimation_matrix(df_medium, medium_vars, variables_metadata)
data_full_est <- create_estimation_matrix(df_full, full_vars, variables_metadata)

cat(sprintf("  ✓ Small estimation matrix: %d × %d\n", nrow(data_small_est), ncol(data_small_est)))
cat(sprintf("  ✓ Medium estimation matrix: %d × %d\n", nrow(data_medium_est), ncol(data_medium_est)))
cat(sprintf("  ✓ Full estimation matrix: %d × %d\n", nrow(data_full_est), ncol(data_full_est)))
cat("\n")

# ------------------------------------------------------------------------------
# 4. Compute Evaluation Transforms Using Julia
# ------------------------------------------------------------------------------

cat("Step 4: Computing evaluation transforms using Julia...\n")
cat("  (Annualized growth rates for forecast evaluation)\n\n")

# Prepare data for Julia
compute_eval_transforms_julia <- function(data_xts, log_vars, level_vars) {
    # Convert to matrix
    data_matrix <- as.matrix(coredata(data_xts))
    var_names <- colnames(data_xts)

    # Ensure no S&P500 chars in variable names if they slip through
    # (Julia Symbols don't like & without escaping, so we use Strings and the wrapper)
    var_names_clean <- gsub("S&P500", "SP500", var_names)
    log_vars_clean <- gsub("S&P500", "SP500", log_vars)
    level_vars_clean <- gsub("S&P500", "SP500", level_vars)

    # Using julia_call directly avoids string parsing issues in Julia 1.12
    result <- julia_call(
        "compute_all_transforms_wrapper",
        data_matrix,
        as.vector(var_names_clean),
        as.vector(log_vars_clean),
        as.vector(level_vars_clean)
    )

    # Convert to xts
    result_xts <- xts(result, order.by = index(data_xts))

    return(result_xts)
}

# Specify which variables are in logs vs levels for each model
eval_small <- compute_eval_transforms_julia(
    data_small_est,
    log_vars = c("INDPRO", "CPIAUCSL"),
    level_vars = c("UNRATE", "FEDFUNDS")
)

eval_medium <- compute_eval_transforms_julia(
    data_medium_est,
    log_vars = c("INDPRO", "CPIAUCSL", "SP500", "DCOILWTICO"),
    level_vars = c("UNRATE", "FEDFUNDS", "GS10")
)

eval_full <- compute_eval_transforms_julia(
    data_full_est,
    log_vars = c("INDPRO", "CPIAUCSL", "SP500", "DCOILWTICO"),
    level_vars = c("UNRATE", "FEDFUNDS", "GS10", "UMCSENT")
)

cat("  ✓ Evaluation transforms computed.\n")
cat(sprintf("    Generated %d series from small model\n", ncol(eval_small)))
cat(sprintf("    Generated %d series from medium model\n", ncol(eval_medium)))
cat(sprintf("    Generated %d series from full model\n", ncol(eval_full)))
cat("\n")

# ------------------------------------------------------------------------------
# 5. Save Processed Data
# ------------------------------------------------------------------------------

cat("Step 5: Saving processed data...\n")

# Save estimation-ready matrices
saveRDS(data_small_est, "data/processed/data_small_estimation.rds")
saveRDS(data_medium_est, "data/processed/data_medium_estimation.rds")
saveRDS(data_full_est, "data/processed/data_full_estimation.rds")

# Save evaluation transforms
saveRDS(eval_small, "data/processed/eval_transforms_small.rds")
saveRDS(eval_medium, "data/processed/eval_transforms_medium.rds")
saveRDS(eval_full, "data/processed/eval_transforms_full.rds")

# Save CSV for inspection
write.zoo(data_full_est, "data/processed/data_full_estimation.csv", sep = ",")
write.zoo(eval_full, "data/processed/eval_transforms_full.csv", sep = ",")

cat("  ✓ Saved to data/processed/\n\n")

# ------------------------------------------------------------------------------
# 6. Data Summary
# ------------------------------------------------------------------------------

cat("=== Data Transformation Summary ===\n\n")
cat("Estimation-ready data (for BVAR input):\n")
cat("  - Log-levels: INDPRO, CPIAUCSL, SP500, DCOILWTICO\n")
cat("  - Levels: UNRATE, FEDFUNDS, GS10, UMCSENT\n\n")

cat("Evaluation transforms (for forecast accuracy):\n")
cat("  - *_mom: Annualized month-over-month growth (1200 × Δlog)\n")
cat("  - *_yoy: Year-over-year growth (100 × Δ12log)\n")
cat("  - *_diff: Level change (Δ1)\n")
cat("  - *_diff12: 12-month level change (Δ12)\n\n")

cat("✓ Data transformation complete!\n")
cat("Next step: Run 04_bvar_estimation.R\n\n")
