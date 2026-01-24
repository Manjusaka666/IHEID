# ==============================================================================
# 05_recursive_forecasting.R
# Purpose: Recursive pseudo-out-of-sample forecasting with 26-thread parallelization
# Author: Jingle Fu
# Date: 2025-12-26
# ==============================================================================

cat("\n=== Starting Recursive Forecasting (Parallelized) ===\n\n")
cat("  Progress will be saved with checkpoints every 50 origins.\n\n")

library(BVAR)
library(tidyverse)
library(xts)
library(parallel)

# ------------------------------------------------------------------------------
# 1. Load Data and Configuration
# ------------------------------------------------------------------------------

cat("Step 1: Loading data and configuration...\n")

data_small <- readRDS("data/processed/data_small_estimation.rds")
data_medium <- readRDS("data/processed/data_medium_estimation.rds")
data_full <- readRDS("data/processed/data_full_estimation.rds")

# MCMC settings (exposed as options for experimentation)
n_draw <- getOption("bayesian_de.n_draw", 10000L)
n_burn <- getOption("bayesian_de.n_burn", 5000L)
base_seed <- getOption("bayesian_de.seed", 2025L)

# Prior configuration with sd parameters for proper hierarchical optimization
# Calibrated to reflect information rigidities in realistic forecasting environments
# Lambda: Stronger shrinkage (0.05) mimics institutional inertia and delayed information processing
# Alpha: Higher lag decay (3.0) can induce trend-chasing behavior (overreaction at long horizons)
lambda_mode <- getOption("bayesian_de.lambda_mode", 0.05)
lambda_sd <- getOption("bayesian_de.lambda_sd", 0.2)
lambda_min <- getOption("bayesian_de.lambda_min", 0.001)
lambda_max <- getOption("bayesian_de.lambda_max", 2.0)

alpha_mode <- getOption("bayesian_de.alpha_mode", 3.0)
alpha_sd <- getOption("bayesian_de.alpha_sd", 0.25)
alpha_min <- getOption("bayesian_de.alpha_min", 1)
alpha_max <- getOption("bayesian_de.alpha_max", 3)

priors_config <- bv_priors(
    hyper = "auto",
    mn = bv_mn(
        lambda = bv_lambda(mode = lambda_mode, sd = lambda_sd, min = lambda_min, max = lambda_max),
        alpha = bv_alpha(mode = alpha_mode, sd = alpha_sd, min = alpha_min, max = alpha_max),
        # Use auto mode to ensure valid dimensions across model sizes.
        psi = bv_psi(mode = "auto") # cross-variable shrinkage
    ),
    soc = bv_soc(mode = 1, sd = 1, min = 0.01, max = 50),
    sur = bv_sur(mode = 1, sd = 1, min = 0.01, max = 50)
)

cat(sprintf("  Priors: lambda(mode=%.3f, sd=%.3f, min=%.3f, max=%.2f); alpha(mode=%.2f)\n\n", lambda_mode, lambda_sd, lambda_min, lambda_max, alpha_mode))
cat(sprintf("  MCMC: n_draw=%d, n_burn=%d\n\n", n_draw, n_burn))

cat("  ✓ Data and priors loaded.\n\n")

# ------------------------------------------------------------------------------
# 2. Define Forecast Origins
# ------------------------------------------------------------------------------

cat("Step 2: Defining forecast origins...\n")

# Initial window: 1985M1 - 2000M12 (forecast origin = 2001M1)
# Final forecast: 2019M11 (to allow h=12 evaluation through 2019M12)

initial_window_end <- as.Date("2000-12-31")
final_forecast_date <- as.Date("2019-11-30")

data_dates <- index(data_full)

initial_idx <- which.min(abs(data_dates - initial_window_end))
final_idx <- which.min(abs(data_dates - final_forecast_date))

cat(sprintf(
    "  Initial training window: 1985M1 - %s (%d obs)\n",
    data_dates[initial_idx], initial_idx
))
cat(sprintf("  Final forecast origin: %s\n", data_dates[final_idx]))

# Forecast origins (expanding window)
forecast_origins <- (initial_idx + 1):final_idx
n_origins <- length(forecast_origins)

max_origins <- getOption("bayesian_de.max_origins", NA_integer_)
if (is.finite(max_origins) && max_origins > 0 && max_origins < n_origins) {
    forecast_origins <- forecast_origins[1:max_origins]
    n_origins <- length(forecast_origins)
    cat(sprintf("  Debug: limiting origins to first %d\n", n_origins))
}

cat(sprintf("  Number of forecast origins: %d\n", n_origins))
cat(sprintf(
    "  Forecast period: %s to %s\n\n",
    format(data_dates[forecast_origins[1]], "%Y-%m"),
    format(data_dates[forecast_origins[length(forecast_origins)]], "%Y-%m")
))
cat("\n")

# ------------------------------------------------------------------------------
# 3. Define Parallel Forecasting Function
# ------------------------------------------------------------------------------

cat("Step 3: Setting up parallel forecasting function...\n")

#' Forecast at Single Origin
#'
#' @param origin_idx Index of forecast origin in the full dataset
#' @param data_full Full xts dataset
#' @param lags Number of lags
#' @param priors_config Prior configuration
#' @return List with forecasts and metadata
forecast_at_origin <- function(origin_idx, data_full, lags, priors_config, model_name, base_seed) {
    model_offset <- switch(tolower(model_name),
        "small" = 0L,
        "medium" = 100000L,
        "full" = 200000L,
        0L
    )
    seed_val <- as.integer(base_seed) + model_offset + as.integer(origin_idx)
    set.seed(seed_val)

    # Extract training window (expanding)
    train_data <- data_full[1:origin_idx, ]

    # Convert to matrix
    train_matrix <- coredata(train_data)

    # Handle any remaining NAs
    if (any(is.na(train_matrix))) {
        # Simple imputation: use column means for any NAs
        for (j in 1:ncol(train_matrix)) {
            na_idx <- is.na(train_matrix[, j])
            if (any(na_idx)) {
                train_matrix[na_idx, j] <- mean(train_matrix[, j], na.rm = TRUE)
            }
        }
    }

    # Add small regularization for numerical stability
    # This helps avoid singular matrix issues in late sample periods
    n_obs <- nrow(train_matrix)
    n_vars <- ncol(train_matrix)

    # Check for near-constant columns (can cause singularity)
    col_sds <- apply(train_matrix, 2, sd)
    if (any(col_sds < 1e-6)) {
        # Add tiny noise to near-constant columns
        for (j in which(col_sds < 1e-6)) {
            train_matrix[, j] <- train_matrix[, j] + rnorm(n_obs, 0, 1e-6)
        }
    }

    # Estimate BVAR with hierarchical prior selection
    tryCatch(
        {
            bvar_fit <- suppressWarnings(bvar(
                data = train_matrix,
                lags = lags,
                n_draw = n_draw,
                n_burn = n_burn,
                priors = priors_config,
                mh = bv_mh(),
                verbose = FALSE
            ))

            # Generate forecasts for h=1 to 13 (need h=13 for CG revisions)
            fcast <- predict(bvar_fit, horizon = 13)

            # Extract point forecasts (posterior mean) in [horizon x variables].
            all_horizons <- NULL
            if (!is.null(fcast$quants) && length(dim(fcast$quants)) == 3) {
                # BVAR returns quants as [quantile x horizon x variables] or [horizon x variables x quantile]
                if (dim(fcast$quants)[1] == 3) {
                    all_horizons <- fcast$quants[2, , , drop = TRUE]
                } else if (dim(fcast$quants)[3] == 3) {
                    all_horizons <- fcast$quants[, , 2, drop = TRUE]
                }
            }
            if (is.null(all_horizons) && !is.null(fcast$fcast) && length(dim(fcast$fcast)) == 3) {
                # Fallback: posterior mean across draws [draws x horizon x variables]
                all_horizons <- apply(fcast$fcast, c(2, 3), mean)
            }
            if (is.null(all_horizons)) {
                stop("Forecast extraction failed: unsupported BVAR forecast structure.")
            }
            all_horizons <- as.matrix(all_horizons)
            if (ncol(all_horizons) != ncol(train_matrix) && nrow(all_horizons) == ncol(train_matrix)) {
                all_horizons <- t(all_horizons)
            }
            colnames(all_horizons) <- colnames(train_matrix)

            forecasts <- list(
                all_horizons = all_horizons,
                var_names = colnames(train_matrix)
            )

            # Extract optimal hyperparameters (posterior means)
            # Need to compute column means
            if (is.matrix(bvar_fit$hyper)) {
                hyper_means <- colMeans(bvar_fit$hyper)
                hyperparams <- list(
                    lambda = if ("lambda" %in% names(hyper_means)) hyper_means["lambda"] else NA,
                    alpha = alpha_mode,
                    psi = if ("psi" %in% names(hyper_means)) hyper_means["psi"] else NA,
                    soc = if ("soc" %in% names(hyper_means)) hyper_means["soc"] else NA,
                    sur = if ("sur" %in% names(hyper_means)) hyper_means["sur"] else NA,
                    log_ml = if (!is.null(bvar_fit$ml)) tail(bvar_fit$ml, 1) else NA
                )
            }

            # Return results
            list(
                origin_idx = origin_idx,
                origin_date = index(data_full)[origin_idx],
                forecasts = forecasts,
                hyperparameters = hyperparams,
                n_train = origin_idx,
                success = TRUE,
                error_msg = NULL
            )
        },
        error = function(e) {
            # Return error information
            list(
                origin_idx = origin_idx,
                origin_date = index(data_full)[origin_idx],
                forecasts = NULL,
                hyperparameters = NULL,
                n_train = origin_idx,
                success = FALSE,
                error_msg = as.character(e)
            )
        }
    )
}

cat("  ✓ Forecasting function defined.\n\n")

# ------------------------------------------------------------------------------
# 4. Set Up Parallel Computing
# ------------------------------------------------------------------------------

cat("Step 4: Initializing parallel cluster...\n")

n_cores <- getOption("bayesian_de.n_cores", default = detectCores() - 2)
cl <- makeCluster(n_cores, type = "PSOCK")

cat(sprintf("  Cluster created with %d workers.\n", n_cores))

# Ensure reproducible parallel RNG streams
seed_value <- getOption("bayesian_de.seed", 2025L)
clusterSetRNGStream(cl, iseed = seed_value)

# Export required objects and libraries to cluster
cat("  Exporting data and functions to workers...\n")
clusterExport(cl, varlist = c(
    "forecast_at_origin",
    "priors_config",
    "n_draw",
    "n_burn",
    "alpha_mode",
    "data_small",
    "data_medium",
    "data_full"
), envir = environment())

# Load required packages on each worker
clusterEvalQ(cl, {
    library(BVAR)
    library(xts)
})

cat("  ✓ Cluster initialized.\n\n")

# ------------------------------------------------------------------------------
# 5. Run Recursive Forecasting for All Three Models
# ------------------------------------------------------------------------------

run_model_forecasts <- function(model_name, data, lags = 12) {
    cat(sprintf("\n═══ Forecasting %s Model ═══\n", toupper(model_name)))
    cat(sprintf("  Variables: %d\n", ncol(data)))
    cat(sprintf("  Forecast origins: %d\n", n_origins))
    cat(sprintf("  Using %d parallel workers\n\n", n_cores))

    start_time <- Sys.time()

    # Check for existing checkpoints to resume
    checkpoint_dir <- "results/forecasts/checkpoints"
    checkpoint_pattern <- sprintf("%s_checkpoint_*.rds", model_name)
    existing_checkpoints <- list.files(checkpoint_dir,
        pattern = checkpoint_pattern,
        full.names = TRUE
    )

    if (length(existing_checkpoints) > 0) {
        resume_opt <- getOption("bayesian_de.resume_checkpoints", NA_character_)
        response <- NA_character_
        if (is.character(resume_opt) && tolower(resume_opt) %in% c("y", "n")) {
            response <- tolower(resume_opt)
            cat(sprintf("  Found existing checkpoints. Resume? (y/n): %s (from option)\n", response))
        } else {
            cat("  Found existing checkpoints. Resume? (y/n): ")
            response <- tolower(readline())
        }

        if (response == "y") {
            # Load latest checkpoint
            latest_checkpoint <- existing_checkpoints[length(existing_checkpoints)]
            results <- readRDS(latest_checkpoint)
            start_idx <- length(results) + 1
            cat(sprintf("  Resuming from origin %d/%d\n\n", start_idx, n_origins))
        } else {
            results <- list()
            start_idx <- 1
        }
    } else {
        results <- list()
        start_idx <- 1
    }

    # Run parallel forecasting
    cat("  Starting parallel forecasting...\n")
    cat("  Progress:\n")

    # Process in batches for checkpoint saving
    batch_size <- 50
    n_batches <- ceiling((n_origins - start_idx + 1) / batch_size)

    for (batch in 1:n_batches) {
        batch_start <- start_idx + (batch - 1) * batch_size
        batch_end <- min(start_idx + batch * batch_size - 1, n_origins)
        batch_origins <- forecast_origins[batch_start:batch_end]

        cat(sprintf(
            "    Batch %d/%d: Origins %d-%d...",
            batch, n_batches, batch_start, batch_end
        ))

        # Parallel computation for this batch
        batch_results <- parLapply(
            cl = cl,
            X = batch_origins,
            fun = forecast_at_origin,
            data_full = data,
            lags = lags,
            priors_config = priors_config,
            model_name = model_name,
            base_seed = base_seed
        )

        # Append to results
        results <- c(results, batch_results)

        cat(" Done.\n")

        # Save checkpoint
        if (batch_end %% batch_size == 0 || batch_end == n_origins) {
            checkpoint_file <- sprintf(
                "%s/%s_checkpoint_%03d.rds",
                checkpoint_dir, model_name, batch_end
            )
            saveRDS(results, checkpoint_file)
            cat(sprintf(
                "      [Checkpoint saved: %d/%d origins]\n",
                length(results), n_origins
            ))
        }
    }

    end_time <- Sys.time()
    elapsed <- as.numeric(difftime(end_time, start_time, units = "mins"))

    cat(sprintf(
        "\n  ✓ %s model complete in %.1f minutes\n",
        toupper(model_name), elapsed
    ))
    cat(sprintf(
        "  Average time per origin: %.1f seconds\n",
        elapsed * 60 / n_origins
    ))

    # Check for failures and display diagnostic info
    n_failures <- sum(!sapply(results, function(x) x$success))
    if (n_failures > 0) {
        cat(sprintf("  ⚠ Warning: %d/%d origins failed\n", n_failures, n_origins))

        # Show first 3 error messages
        failed_results <- results[!sapply(results, function(x) x$success)]
        cat("\n  Sample error messages (first 3):\n")
        for (i in 1:min(3, length(failed_results))) {
            cat(sprintf(
                "    Origin %d: %s\n",
                failed_results[[i]]$origin_idx,
                substr(failed_results[[i]]$error_msg, 1, 80)
            ))
        }
        cat("\n")
    }

    return(results)
}

# Run forecasts for all three models
cat("╔════════════════════════════════════════════════════╗\n")
cat("║  RECURSIVE FORECASTING: ALL MODELS                 ║\n")
cat("╚════════════════════════════════════════════════════╝\n")

results_small <- run_model_forecasts("small", data_small)
results_medium <- run_model_forecasts("medium", data_medium)
results_full <- run_model_forecasts("full", data_full)

# ------------------------------------------------------------------------------
# 6. Clean Up Parallel Cluster
# ------------------------------------------------------------------------------

cat("\nStep 6: Cleaning up parallel cluster...\n")
stopCluster(cl)
cat("  ✓ Cluster stopped.\n\n")

# ------------------------------------------------------------------------------
# 7. Save Final Results
# ------------------------------------------------------------------------------

cat("Step 7: Saving final results...\n")

saveRDS(results_small, "results/forecasts/small_model_forecasts.rds")
saveRDS(results_medium, "results/forecasts/medium_model_forecasts.rds")
saveRDS(results_full, "results/forecasts/full_model_forecasts.rds")

# Extract hyperparameter evolution
extract_hyperparams <- function(results, model_name) {
    successful_results <- Filter(function(x) x$success, results)

    if (length(successful_results) == 0) {
        return(data.frame())
    }

    do.call(rbind, lapply(successful_results, function(x) {
        # Safely extract each hyperparameter
        safe_extract <- function(param_name) {
            val <- x$hyperparameters[[param_name]]
            if (is.null(val) || length(val) == 0 || is.na(val)) {
                return(NA_real_)
            }
            return(as.numeric(val))
        }

        data.frame(
            model = model_name,
            origin_date = as.character(x$origin_date),
            origin_idx = x$origin_idx,
            lambda = safe_extract("lambda"),
            alpha = safe_extract("alpha"),
            psi = safe_extract("psi"),
            soc = safe_extract("soc"),
            sur = safe_extract("sur"),
            log_ml = safe_extract("log_ml"),
            stringsAsFactors = FALSE
        )
    }))
}

hyperparams_all <- bind_rows(
    extract_hyperparams(results_small, "small"),
    extract_hyperparams(results_medium, "medium"),
    extract_hyperparams(results_full, "full")
)

write.csv(hyperparams_all,
    "results/forecasts/hyperparameters_evolution.csv",
    row.names = FALSE
)

cat("  ✓ Saved to results/forecasts/\n\n")

# ------------------------------------------------------------------------------
# 8. Summary Statistics
# ------------------------------------------------------------------------------

cat("═══════════════════════════════════════════════════\n")
cat("  RECURSIVE FORECASTING COMPLETE\n")
cat("═══════════════════════════════════════════════════\n\n")

cat("Summary:\n")
cat(sprintf("  Total forecast origins: %d\n", n_origins))
cat(sprintf("  Forecast horizons: h = 1, 3, 12\n"))
cat(sprintf(
    "  Successful runs (Small): %d/%d\n",
    sum(sapply(results_small, function(x) x$success)), n_origins
))
cat(sprintf(
    "  Successful runs (Medium): %d/%d\n",
    sum(sapply(results_medium, function(x) x$success)), n_origins
))
cat(sprintf(
    "  Successful runs (Full): %d/%d\n",
    sum(sapply(results_full, function(x) x$success)), n_origins
))

cat("\nAverage hyperparameters:\n")
cat(sprintf(
    "  Small  - Lambda: %.4f, Alpha: %.4f\n",
    mean(hyperparams_all$lambda[hyperparams_all$model == "small"], na.rm = TRUE),
    mean(hyperparams_all$alpha[hyperparams_all$model == "small"], na.rm = TRUE)
))
cat(sprintf(
    "  Medium - Lambda: %.4f, Alpha: %.4f\n",
    mean(hyperparams_all$lambda[hyperparams_all$model == "medium"], na.rm = TRUE),
    mean(hyperparams_all$alpha[hyperparams_all$model == "medium"], na.rm = TRUE)
))
cat(sprintf(
    "  Full   - Lambda: %.4f, Alpha: %.4f\n",
    mean(hyperparams_all$lambda[hyperparams_all$model == "full"], na.rm = TRUE),
    mean(hyperparams_all$alpha[hyperparams_all$model == "full"], na.rm = TRUE)
))

cat("\n✓ Next step: Run 06_forecast_evaluation.R\n\n")
