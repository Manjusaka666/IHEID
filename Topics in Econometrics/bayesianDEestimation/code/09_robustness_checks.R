# ==============================================================================
# 09_robustness_checks.R
# Purpose: Robustness checks for alternative lag length and initial window
# Author: Jingle Fu
# Date: 2025-12-28
# ==============================================================================

cat("\n=== Robustness Checks ===\n\n")

library(BVAR)
library(tidyverse)
library(xts)
library(parallel)

run_robustness <- isTRUE(getOption("bayesian_de.run_robustness", TRUE))

# ----------------------------------------------------------------------
# 1. Load Data
# ----------------------------------------------------------------------

cat("Step 1: Loading estimation data...\n")

data_small <- readRDS("data/processed/data_small_estimation.rds")
data_medium <- readRDS("data/processed/data_medium_estimation.rds")
data_full <- readRDS("data/processed/data_full_estimation.rds")

cat("  Data loaded.\n\n")

# ----------------------------------------------------------------------
# 2. Configuration
# ----------------------------------------------------------------------

priors_config <- bv_priors(
    hyper = "auto",
    mn = bv_mn(
        lambda = bv_lambda(mode = 0.7, sd = 0.8, min = 0.01, max = 10),
        alpha = bv_alpha(mode = 1.2, sd = 0.8, min = 0.5, max = 5),
        psi = bv_psi(mode = "auto")
    ),
    soc = bv_soc(mode = 1, sd = 1, min = 0.01, max = 50),
    sur = bv_sur(mode = 1, sd = 1, min = 0.01, max = 50)
)

n_draw <- getOption("bayesian_de.n_draw", 10000)
n_burn <- getOption("bayesian_de.n_burn", 5000)
n_cores <- getOption("bayesian_de.n_cores", max(1, detectCores() - 2))

final_forecast_date <- as.Date("2019-11-30")

scenarios <- list(
    lag6 = list(
        label = "lag6",
        lags = 6,
        initial_window_end = as.Date("2000-12-31")
    ),
    window1995 = list(
        label = "window1995",
        lags = 12,
        initial_window_end = as.Date("1995-12-31")
    )
)

compute_forecast_origins <- function(data_dates, initial_window_end, final_forecast_date) {
    initial_idx <- which.min(abs(data_dates - initial_window_end))
    final_idx <- which.min(abs(data_dates - final_forecast_date))
    list(
        forecast_origins = (initial_idx + 1):final_idx,
        initial_idx = initial_idx,
        final_idx = final_idx
    )
}

extract_point_forecast <- function(fcast, var_names) {
    all_horizons <- NULL
    if (!is.null(fcast$quants) && length(dim(fcast$quants)) == 3) {
        if (dim(fcast$quants)[1] == 3) {
            all_horizons <- fcast$quants[2, , , drop = TRUE]
        } else if (dim(fcast$quants)[3] == 3) {
            all_horizons <- fcast$quants[, , 2, drop = TRUE]
        }
    }
    if (is.null(all_horizons) && !is.null(fcast$fcast) && length(dim(fcast$fcast)) == 3) {
        all_horizons <- apply(fcast$fcast, c(2, 3), mean)
    }
    if (is.null(all_horizons)) {
        stop("Forecast extraction failed: unsupported BVAR forecast structure.")
    }
    all_horizons <- as.matrix(all_horizons)
    if (ncol(all_horizons) != length(var_names) && nrow(all_horizons) == length(var_names)) {
        all_horizons <- t(all_horizons)
    }
    colnames(all_horizons) <- var_names
    all_horizons
}

forecast_at_origin <- function(origin_idx, data_full, lags, priors_config, n_draw, n_burn) {
    train_data <- data_full[1:origin_idx, ]
    train_matrix <- coredata(train_data)

    if (any(is.na(train_matrix))) {
        for (j in 1:ncol(train_matrix)) {
            na_idx <- is.na(train_matrix[, j])
            if (any(na_idx)) {
                train_matrix[na_idx, j] <- mean(train_matrix[, j], na.rm = TRUE)
            }
        }
    }

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

            fcast <- predict(bvar_fit, horizon = 13)
            all_horizons <- extract_point_forecast(fcast, colnames(train_matrix))

            list(
                origin_idx = origin_idx,
                origin_date = index(data_full)[origin_idx],
                forecasts = list(
                    all_horizons = all_horizons,
                    var_names = colnames(train_matrix)
                ),
                n_train = origin_idx,
                success = TRUE,
                error_msg = NULL
            )
        },
        error = function(e) {
            list(
                origin_idx = origin_idx,
                origin_date = index(data_full)[origin_idx],
                forecasts = NULL,
                n_train = origin_idx,
                success = FALSE,
                error_msg = as.character(e)
            )
        }
    )
}

run_model_forecasts <- function(model_name, data, lags, forecast_origins, output_dir) {
    cat(sprintf("\nForecasting %s model (lags=%d)...\n", toupper(model_name), lags))
    start_time <- Sys.time()

    results <- parLapply(
        cl = cl,
        X = forecast_origins,
        fun = forecast_at_origin,
        data_full = data,
        lags = lags,
        priors_config = priors_config,
        n_draw = n_draw,
        n_burn = n_burn
    )

    end_time <- Sys.time()
    elapsed <- as.numeric(difftime(end_time, start_time, units = "mins"))

    n_failures <- sum(!sapply(results, function(x) x$success))
    cat(sprintf("  Done in %.1f minutes (%d failures)\n", elapsed, n_failures))

    saveRDS(results, file.path(output_dir, sprintf("%s_model_forecasts.rds", model_name)))
    results
}

extract_forecasts_transformed <- function(forecast_results, data_est, var_name, is_log = TRUE) {
    var_idx_default <- which(colnames(data_est) == var_name)

    forecast_list <- lapply(forecast_results, function(x) {
        if (!x$success || is.null(x$forecasts$all_horizons)) {
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
        if (nrow(all_horizons) >= 12 && ncol(all_horizons) == n_vars) {
            all_fcast <- all_horizons[, var_idx]
        } else if (ncol(all_horizons) >= 12 && nrow(all_horizons) == n_vars) {
            all_fcast <- all_horizons[var_idx, ]
        } else {
            return(NULL)
        }

        all_fcast <- as.numeric(all_fcast)
        if (length(all_fcast) < 12) {
            return(NULL)
        }

        base_t0 <- coredata(data_est)[x$origin_idx, var_idx]

        if (is_log) {
            data.frame(
                origin_date = x$origin_date,
                origin_idx = x$origin_idx,
                h1_forecast = 1200 * (all_fcast[1] - base_t0),
                h3_forecast = 400 * (all_fcast[3] - base_t0),
                h12_forecast = 100 * (all_fcast[12] - base_t0)
            )
        } else {
            data.frame(
                origin_date = x$origin_date,
                origin_idx = x$origin_idx,
                h1_forecast = all_fcast[1] - base_t0,
                h3_forecast = (all_fcast[3] - base_t0) / 3,
                h12_forecast = (all_fcast[12] - base_t0) / 12
            )
        }
    })

    forecast_list <- forecast_list[!sapply(forecast_list, is.null)]
    if (length(forecast_list) == 0) {
        return(data.frame())
    }
    do.call(rbind, forecast_list)
}

align_forecast_actual <- function(forecast_df, data_est, var_name, is_log = TRUE) {
    var_idx <- which(colnames(data_est) == var_name)
    if (length(var_idx) != 1) {
        warning(sprintf("Variable %s not found in data_est.", var_name))
        return(forecast_df)
    }
    if (nrow(forecast_df) == 0) {
        return(forecast_df)
    }
    forecast_df <- forecast_df %>%
        mutate(
            h1_actual = NA_real_,
            h3_actual = NA_real_,
            h12_actual = NA_real_
        )

    for (i in seq_len(nrow(forecast_df))) {
        origin_idx <- as.integer(forecast_df$origin_idx[i])
        if (is.na(origin_idx)) {
            next
        }
        base_level <- coredata(data_est)[origin_idx, var_idx]
        if (is.na(base_level)) {
            next
        }

        if (is_log) {
            if (origin_idx + 1 <= nrow(data_est)) {
                level_h1 <- coredata(data_est)[origin_idx + 1, var_idx]
                forecast_df$h1_actual[i] <- 1200 * (level_h1 - base_level)
            }
            if (origin_idx + 3 <= nrow(data_est)) {
                level_h3 <- coredata(data_est)[origin_idx + 3, var_idx]
                forecast_df$h3_actual[i] <- 400 * (level_h3 - base_level)
            }
            if (origin_idx + 12 <= nrow(data_est)) {
                level_h12 <- coredata(data_est)[origin_idx + 12, var_idx]
                forecast_df$h12_actual[i] <- 100 * (level_h12 - base_level)
            }
        } else {
            if (origin_idx + 1 <= nrow(data_est)) {
                level_h1 <- coredata(data_est)[origin_idx + 1, var_idx]
                forecast_df$h1_actual[i] <- level_h1 - base_level
            }
            if (origin_idx + 3 <= nrow(data_est)) {
                level_h3 <- coredata(data_est)[origin_idx + 3, var_idx]
                forecast_df$h3_actual[i] <- (level_h3 - base_level) / 3
            }
            if (origin_idx + 12 <= nrow(data_est)) {
                level_h12 <- coredata(data_est)[origin_idx + 12, var_idx]
                forecast_df$h12_actual[i] <- (level_h12 - base_level) / 12
            }
        }
    }

    forecast_df
}

compute_rmsfe <- function(forecast, actual) {
    errors <- forecast - actual
    valid <- !is.na(errors)
    if (sum(valid) == 0) {
        return(NA_real_)
    }
    sqrt(mean(errors[valid]^2))
}

compute_growth_series <- function(data_est, var_name, horizon, is_log = TRUE) {
    var_idx <- which(colnames(data_est) == var_name)
    if (length(var_idx) != 1) {
        return(rep(NA_real_, nrow(data_est)))
    }

    series <- as.numeric(coredata(data_est)[, var_idx])
    n <- length(series)
    out <- rep(NA_real_, n)

    if (horizon < 1 || horizon >= n) {
        return(out)
    }

    if (is_log) {
        scale <- 1200 / horizon
        for (t in (horizon + 1):n) {
            out[t] <- scale * (series[t] - series[t - horizon])
        }
    } else {
        for (t in (horizon + 1):n) {
            out[t] <- (series[t] - series[t - horizon]) / horizon
        }
    }

    out
}

compute_model_rmsfe <- function(forecast_df) {
    data.frame(
        h1 = compute_rmsfe(forecast_df$h1_forecast, forecast_df$h1_actual),
        h3 = compute_rmsfe(forecast_df$h3_forecast, forecast_df$h3_actual),
        h12 = compute_rmsfe(forecast_df$h12_forecast, forecast_df$h12_actual)
    )
}

compute_rw_rmsfe <- function(actual) {
    errors <- 0 - actual
    valid <- !is.na(errors)
    if (sum(valid) == 0) {
        return(NA_real_)
    }
    sqrt(mean(errors[valid]^2))
}

compute_ar1_forecast <- function(forecast_df, data_est, var_name, horizon, is_log = TRUE) {
    growth_series <- compute_growth_series(data_est, var_name, horizon, is_log)
    origins <- as.integer(forecast_df$origin_idx)
    ar1_forecasts <- rep(NA_real_, length(origins))

    for (i in seq_along(origins)) {
        t0 <- origins[i]
        if (is.na(t0) || t0 <= 1 || t0 > length(growth_series)) {
            next
        }

        y_train <- growth_series[1:t0]
        y_train <- y_train[!is.na(y_train)]

        if (length(y_train) > 24) {
            ar1_fit <- ar(y_train, order.max = 1, method = "ols")
            phi <- if (length(ar1_fit$ar) > 0) ar1_fit$ar[1] else 0
            mu <- ar1_fit$x.mean
            ar1_forecasts[i] <- mu + phi^horizon * (y_train[length(y_train)] - mu)
        } else if (length(y_train) > 0) {
            ar1_forecasts[i] <- mean(y_train, na.rm = TRUE)
        }
    }

    ar1_forecasts
}

# ----------------------------------------------------------------------
# 3. Run Scenarios
# ----------------------------------------------------------------------

for (scenario in scenarios) {
    cat("\n========================================\n")
    cat(sprintf("Scenario: %s\n", scenario$label))
    cat("========================================\n\n")

    scenario_dir <- file.path("results", "robustness", scenario$label)
    forecasts_dir <- file.path(scenario_dir, "forecasts")
    tables_dir <- file.path(scenario_dir, "tables")
    dir.create(forecasts_dir, recursive = TRUE, showWarnings = FALSE)
    dir.create(tables_dir, recursive = TRUE, showWarnings = FALSE)

    origins_info <- compute_forecast_origins(index(data_full), scenario$initial_window_end, final_forecast_date)
    forecast_origins <- origins_info$forecast_origins
    cat(sprintf("  Forecast origins: %d\n", length(forecast_origins)))

    cl <- makeCluster(n_cores, type = "PSOCK")
    clusterExport(cl, varlist = c(
        "forecast_at_origin",
        "extract_point_forecast",
        "priors_config",
        "n_draw",
        "n_burn"
    ), envir = environment())
    clusterEvalQ(cl, {
        library(BVAR)
        library(xts)
    })

    results_small <- run_model_forecasts("small", data_small, scenario$lags, forecast_origins, forecasts_dir)
    results_medium <- run_model_forecasts("medium", data_medium, scenario$lags, forecast_origins, forecasts_dir)
    results_full <- run_model_forecasts("full", data_full, scenario$lags, forecast_origins, forecasts_dir)

    stopCluster(cl)

    # Forecast evaluation (CPI + INDPRO)
    cpi_small <- extract_forecasts_transformed(results_small, data_small, "CPIAUCSL", TRUE)
    indpro_small <- extract_forecasts_transformed(results_small, data_small, "INDPRO", TRUE)
    cpi_medium <- extract_forecasts_transformed(results_medium, data_medium, "CPIAUCSL", TRUE)
    indpro_medium <- extract_forecasts_transformed(results_medium, data_medium, "INDPRO", TRUE)
    cpi_full <- extract_forecasts_transformed(results_full, data_full, "CPIAUCSL", TRUE)
    indpro_full <- extract_forecasts_transformed(results_full, data_full, "INDPRO", TRUE)

    cpi_small <- align_forecast_actual(cpi_small, data_small, "CPIAUCSL", TRUE)
    indpro_small <- align_forecast_actual(indpro_small, data_small, "INDPRO", TRUE)
    cpi_medium <- align_forecast_actual(cpi_medium, data_medium, "CPIAUCSL", TRUE)
    indpro_medium <- align_forecast_actual(indpro_medium, data_medium, "INDPRO", TRUE)
    cpi_full <- align_forecast_actual(cpi_full, data_full, "CPIAUCSL", TRUE)
    indpro_full <- align_forecast_actual(indpro_full, data_full, "INDPRO", TRUE)

    rmsfe_results <- bind_rows(
        data.frame(model = "Small", variable = "CPI") %>% cbind(compute_model_rmsfe(cpi_small)),
        data.frame(model = "Small", variable = "INDPRO") %>% cbind(compute_model_rmsfe(indpro_small)),
        data.frame(model = "Medium", variable = "CPI") %>% cbind(compute_model_rmsfe(cpi_medium)),
        data.frame(model = "Medium", variable = "INDPRO") %>% cbind(compute_model_rmsfe(indpro_medium)),
        data.frame(model = "Full", variable = "CPI") %>% cbind(compute_model_rmsfe(cpi_full)),
        data.frame(model = "Full", variable = "INDPRO") %>% cbind(compute_model_rmsfe(indpro_full))
    )

    rw_rmsfe <- data.frame(
        variable = c("CPI", "INDPRO"),
        h1 = c(
            compute_rw_rmsfe(cpi_small$h1_actual),
            compute_rw_rmsfe(indpro_small$h1_actual)
        ),
        h3 = c(
            compute_rw_rmsfe(cpi_small$h3_actual),
            compute_rw_rmsfe(indpro_small$h3_actual)
        ),
        h12 = c(
            compute_rw_rmsfe(cpi_small$h12_actual),
            compute_rw_rmsfe(indpro_small$h12_actual)
        )
    )

    ar1_rmsfe <- data.frame(
        variable = c("CPI", "INDPRO"),
        h1 = c(
            compute_rmsfe(compute_ar1_forecast(cpi_small, data_small, "CPIAUCSL", 1, TRUE), cpi_small$h1_actual),
            compute_rmsfe(compute_ar1_forecast(indpro_small, data_small, "INDPRO", 1, TRUE), indpro_small$h1_actual)
        ),
        h3 = c(
            compute_rmsfe(compute_ar1_forecast(cpi_small, data_small, "CPIAUCSL", 3, TRUE), cpi_small$h3_actual),
            compute_rmsfe(compute_ar1_forecast(indpro_small, data_small, "INDPRO", 3, TRUE), indpro_small$h3_actual)
        ),
        h12 = c(
            compute_rmsfe(compute_ar1_forecast(cpi_small, data_small, "CPIAUCSL", 12, TRUE), cpi_small$h12_actual),
            compute_rmsfe(compute_ar1_forecast(indpro_small, data_small, "INDPRO", 12, TRUE), indpro_small$h12_actual)
        )
    )

    relative_rmsfe_rw <- rmsfe_results %>%
        left_join(rw_rmsfe, by = "variable", suffix = c("_model", "_rw")) %>%
        mutate(
            rel_h1 = h1_model / h1_rw,
            rel_h3 = h3_model / h3_rw,
            rel_h12 = h12_model / h12_rw
        ) %>%
        select(model, variable, rel_h1, rel_h3, rel_h12)

    relative_rmsfe_ar1 <- rmsfe_results %>%
        left_join(ar1_rmsfe, by = "variable", suffix = c("_model", "_ar1")) %>%
        mutate(
            rel_h1 = h1_model / h1_ar1,
            rel_h3 = h3_model / h3_ar1,
            rel_h12 = h12_model / h12_ar1
        ) %>%
        select(model, variable, rel_h1, rel_h3, rel_h12)

    cat("\nRelative RMSFE interpretation (vs RW):\n")
    for (var_label in unique(relative_rmsfe_rw$variable)) {
        for (h in c("rel_h1", "rel_h3", "rel_h12")) {
            best_row <- relative_rmsfe_rw %>% filter(variable == var_label) %>% slice_min(.data[[h]], n = 1)
            cat(sprintf(
                "  %s %s: best = %s (%.3f)\n",
                var_label, h, best_row$model[1], best_row[[h]][1]
            ))
        }
    }
    cat("\n")

    write.csv(rmsfe_results, file.path(tables_dir, "rmsfe_results.csv"), row.names = FALSE)
    write.csv(rw_rmsfe, file.path(tables_dir, "rw_rmsfe_benchmark.csv"), row.names = FALSE)
    write.csv(ar1_rmsfe, file.path(tables_dir, "ar1_rmsfe_benchmark.csv"), row.names = FALSE)
    write.csv(relative_rmsfe_rw, file.path(tables_dir, "relative_rmsfe_vs_rw.csv"), row.names = FALSE)
    write.csv(relative_rmsfe_ar1, file.path(tables_dir, "relative_rmsfe_vs_ar1.csv"), row.names = FALSE)

    saveRDS(
        list(
            cpi_small = cpi_small,
            cpi_medium = cpi_medium,
            cpi_full = cpi_full,
            indpro_small = indpro_small,
            indpro_medium = indpro_medium,
            indpro_full = indpro_full
        ),
        file.path(forecasts_dir, "aligned_forecasts_actuals.rds")
    )

    cat("  Results saved to: ", scenario_dir, "\n")
}

cat("\nRobustness checks complete.\n\n")
