# ==============================================================================
# 06_forecast_evaluation.R
# Purpose: Compute RMSFE, relative performance, and Diebold-Mariano tests
# Author: Jingle Fu
# Date: 2025-12-26
# ==============================================================================

cat("\n=== Forecast Evaluation ===\n\n")

library(tidyverse)
library(xts)
library(lmtest)
library(sandwich)

# ------------------------------------------------------------------------------
# 1. Load Forecasts and Actuals
# ------------------------------------------------------------------------------

cat("Step 1: Loading forecasts and evaluation data...\n")

# Load forecast results
forecasts_small <- readRDS("results/forecasts/small_model_forecasts.rds")
forecasts_medium <- readRDS("results/forecasts/medium_model_forecasts.rds")
forecasts_full <- readRDS("results/forecasts/full_model_forecasts.rds")

# Load evaluation transforms (actuals)
eval_small <- readRDS("data/processed/eval_transforms_small.rds")
eval_medium <- readRDS("data/processed/eval_transforms_medium.rds")
eval_full <- readRDS("data/processed/eval_transforms_full.rds")

# Load estimation data (to get levels)
data_small_est <- readRDS("data/processed/data_small_estimation.rds")

cat(sprintf("  Forecasts loaded: %d origins per model\n", length(forecasts_small)))
cat("\n")

# ------------------------------------------------------------------------------
# 2. Transform Forecasts to Evaluation Metrics
# ------------------------------------------------------------------------------

cat("Step 2: Transforming BVAR forecasts to growth rates...\n")

#' Transform log-level forecasts to annualized growth rates
#' @param forecast_level Vector of forecasts in log-levels
#' @param actual_level Vector of actual values in log-levels (for base)
#' @param horizon Forecast horizon
#' @return Annualized growth rate forecast
log_to_growth <- function(forecast_level, actual_level_base, horizon) {
    # For h-step ahead: growth = 1200/h * (log(F_{t+h}) - log(F_t))
    # Simplified version: just compute m-o-m from forecast levels
    return((1200 / horizon) * (forecast_level - actual_level_base))
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

# Extract and transform forecasts for key variables
# Uses CUMULATIVE growth rates from base period t for all horizons
# This ensures comparability between forecast and actual values
extract_forecasts_transformed <- function(forecast_results, data_est, var_name, is_log = TRUE) {
    var_idx_default <- which(colnames(data_est) == var_name)

    forecast_list <- lapply(forecast_results, function(x) {
        if (!x$success || is.null(x$forecasts$all_horizons)) {
            return(NULL)
        }

        origin_date <- x$origin_date
        origin_idx <- x$origin_idx

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

        # Base level at origin (time t)
        base_t0 <- coredata(data_est)[origin_idx, var_idx]

        if (is_log) {
            # Compute CUMULATIVE annualized growth rates from base t
            # h=1: 1-month annualized = 1200 * (F_{t+1} - A_t)
            # h=3: 3-month average annualized = 400 * (F_{t+3} - A_t)
            # h=12: 12-month (YoY) = 100 * (F_{t+12} - A_t)
            h1_growth <- 1200 * (all_fcast[1] - base_t0)
            h3_growth <- 400 * (all_fcast[3] - base_t0)     # 1200/3
            h12_growth <- 100 * (all_fcast[12] - base_t0)   # 1200/12 = 100

            data.frame(
                origin_date = origin_date,
                origin_idx = origin_idx,
                h1_forecast = h1_growth,
                h3_forecast = h3_growth,
                h12_forecast = h12_growth
            )
        } else {
            # For level variables: compute cumulative changes from base t
            data.frame(
                origin_date = origin_date,
                origin_idx = origin_idx,
                h1_forecast = all_fcast[1] - base_t0,
                h3_forecast = (all_fcast[3] - base_t0) / 3,     # Average per period
                h12_forecast = (all_fcast[12] - base_t0) / 12   # Average per period
            )
        }
    })

    forecast_list <- forecast_list[!sapply(forecast_list, is.null)]
    if (length(forecast_list) == 0) {
        return(data.frame())
    }

    forecast_df <- do.call(rbind, forecast_list)
    return(forecast_df)
}

# Extract CPI and INDPRO forecasts for all models
cat("  Processing Small model...\n")
cpi_small <- extract_forecasts_transformed(forecasts_small, data_small_est, "CPIAUCSL", TRUE)
indpro_small <- extract_forecasts_transformed(forecasts_small, data_small_est, "INDPRO", TRUE)

cat("  Processing Medium model...\n")
data_medium_est <- readRDS("data/processed/data_medium_estimation.rds")
cpi_medium <- extract_forecasts_transformed(forecasts_medium, data_medium_est, "CPIAUCSL", TRUE)
indpro_medium <- extract_forecasts_transformed(forecasts_medium, data_medium_est, "INDPRO", TRUE)

cat("  Processing Full model...\n")
data_full_est <- readRDS("data/processed/data_full_estimation.rds")
cpi_full <- extract_forecasts_transformed(forecasts_full, data_full_est, "CPIAUCSL", TRUE)
indpro_full <- extract_forecasts_transformed(forecasts_full, data_full_est, "INDPRO", TRUE)

cat("  ✓ Forecasts transformed to growth rates for all models.\n\n")

# ------------------------------------------------------------------------------
# 3. Align Forecasts with Actuals
# ------------------------------------------------------------------------------

cat("Step 3: Aligning forecasts with realized values...\n")

# Align forecasts with actual CUMULATIVE growth rates
# Computes actual values directly from log-levels using same definition as forecasts
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
            target_date_h1 = as.Date(NA),
            target_date_h3 = as.Date(NA),
            target_date_h12 = as.Date(NA),
            h1_actual = NA_real_,
            h3_actual = NA_real_,
            h12_actual = NA_real_
        )

    for (i in seq_len(nrow(forecast_df))) {
        origin_idx <- as.integer(forecast_df$origin_idx[i])
        if (is.na(origin_idx)) {
            next
        }

        if (origin_idx + 1 <= nrow(data_est)) {
            forecast_df$target_date_h1[i] <- as.Date(index(data_est)[origin_idx + 1])
        }
        if (origin_idx + 3 <= nrow(data_est)) {
            forecast_df$target_date_h3[i] <- as.Date(index(data_est)[origin_idx + 3])
        }
        if (origin_idx + 12 <= nrow(data_est)) {
            forecast_df$target_date_h12[i] <- as.Date(index(data_est)[origin_idx + 12])
        }
        
        # Base level at origin (time t) - SAME as used for forecasts
        base_level <- coredata(data_est)[origin_idx, var_idx]
        if (is.na(base_level)) {
            next
        }
        
        if (is_log) {
            # Compute CUMULATIVE growth rates (same definition as forecasts)
            # h=1: 1200 * (A_{t+1} - A_t)
            if (origin_idx + 1 <= nrow(data_est)) {
                level_h1 <- coredata(data_est)[origin_idx + 1, var_idx]
                forecast_df$h1_actual[i] <- 1200 * (level_h1 - base_level)
            }
            
            # h=3: 400 * (A_{t+3} - A_t)
            if (origin_idx + 3 <= nrow(data_est)) {
                level_h3 <- coredata(data_est)[origin_idx + 3, var_idx]
                forecast_df$h3_actual[i] <- 400 * (level_h3 - base_level)
            }
            
            # h=12: 100 * (A_{t+12} - A_t) = YoY
            if (origin_idx + 12 <= nrow(data_est)) {
                level_h12 <- coredata(data_est)[origin_idx + 12, var_idx]
                forecast_df$h12_actual[i] <- 100 * (level_h12 - base_level)
            }
        } else {
            # Level variables: cumulative changes / h
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

    return(forecast_df)
}

# Align all models - now using estimation data directly (log-levels)
cpi_small <- align_forecast_actual(cpi_small, data_small_est, "CPIAUCSL", TRUE)
indpro_small <- align_forecast_actual(indpro_small, data_small_est, "INDPRO", TRUE)

cpi_medium <- align_forecast_actual(cpi_medium, data_medium_est, "CPIAUCSL", TRUE)
indpro_medium <- align_forecast_actual(indpro_medium, data_medium_est, "INDPRO", TRUE)

cpi_full <- align_forecast_actual(cpi_full, data_full_est, "CPIAUCSL", TRUE)
indpro_full <- align_forecast_actual(indpro_full, data_full_est, "INDPRO", TRUE)

cat("  ✓ Forecasts aligned with actuals for all models.\n\n")

# ------------------------------------------------------------------------------
# 4. Compute RMSFE
# ------------------------------------------------------------------------------

cat("Step 4: Computing RMSFE for all models and horizons...\n")

compute_rmsfe <- function(forecast, actual) {
    errors <- forecast - actual
    valid <- !is.na(errors)
    if (sum(valid) == 0) {
        return(NA)
    }
    sqrt(mean(errors[valid]^2))
}

compute_model_rmsfe <- function(forecast_df) {
    data.frame(
        h1 = compute_rmsfe(forecast_df$h1_forecast, forecast_df$h1_actual),
        h3 = compute_rmsfe(forecast_df$h3_forecast, forecast_df$h3_actual),
        h12 = compute_rmsfe(forecast_df$h12_forecast, forecast_df$h12_actual)
    )
}

# Compute RMSFE for all models
rmsfe_results <- bind_rows(
    # Small model
    data.frame(model = "Small", variable = "CPI") %>%
        cbind(compute_model_rmsfe(cpi_small)),
    data.frame(model = "Small", variable = "INDPRO") %>%
        cbind(compute_model_rmsfe(indpro_small)),

    # Medium model
    data.frame(model = "Medium", variable = "CPI") %>%
        cbind(compute_model_rmsfe(cpi_medium)),
    data.frame(model = "Medium", variable = "INDPRO") %>%
        cbind(compute_model_rmsfe(indpro_medium)),

    # Full model
    data.frame(model = "Full", variable = "CPI") %>%
        cbind(compute_model_rmsfe(cpi_full)),
    data.frame(model = "Full", variable = "INDPRO") %>%
        cbind(compute_model_rmsfe(indpro_full))
)

cat("\nRMSFE Results (All Models):\n")
print(rmsfe_results)
cat("\n")

# ------------------------------------------------------------------------------
# 5. Benchmark Models (Random Walk)
# ------------------------------------------------------------------------------

cat("Step 5: Computing Random Walk benchmarks...\n")

# RW forecast: y_{t+h} = y_t (in growth rates, RW forecast is 0)
# This is equivalent to no-change forecast

compute_rw_rmsfe <- function(actual) {
    # RW forecast is 0 (no change in growth rate)
    errors <- 0 - actual
    valid <- !is.na(errors)
    if (sum(valid) == 0) {
        return(NA)
    }
    sqrt(mean(errors[valid]^2))
}

# Use Small model actuals for RW benchmark (same actuals for all models)
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

cat("\nRandom Walk RMSFE (Benchmark):\n")
print(rw_rmsfe)
cat("\n")

# ------------------------------------------------------------------------------
# 5.5 AR(1) Benchmark
# ------------------------------------------------------------------------------
cat("Step 5.5: Computing AR(1) benchmarks (evaluation growth rates)...\n")

compute_ar1_forecast <- function(forecast_df, data_est, var_name, horizon, is_log = TRUE) {
    growth_series <- compute_growth_series(data_est, var_name, horizon, is_log)
    origins <- as.integer(forecast_df$origin_idx)
    ar1_forecasts <- rep(NA_real_, length(origins))

    # Recursive AR(1) estimation on growth-rate series (evaluation scale)
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

    return(ar1_forecasts)
}

# Compute AR(1) RMSFE for all horizons
ar1_rmsfe <- data.frame(
    variable = c("CPI", "INDPRO"),
    h1 = c(
        compute_rmsfe(compute_ar1_forecast(cpi_small, data_small_est, "CPIAUCSL", 1, TRUE), cpi_small$h1_actual),
        compute_rmsfe(compute_ar1_forecast(indpro_small, data_small_est, "INDPRO", 1, TRUE), indpro_small$h1_actual)
    ),
    h3 = c(
        compute_rmsfe(compute_ar1_forecast(cpi_small, data_small_est, "CPIAUCSL", 3, TRUE), cpi_small$h3_actual),
        compute_rmsfe(compute_ar1_forecast(indpro_small, data_small_est, "INDPRO", 3, TRUE), indpro_small$h3_actual)
    ),
    h12 = c(
        compute_rmsfe(compute_ar1_forecast(cpi_small, data_small_est, "CPIAUCSL", 12, TRUE), cpi_small$h12_actual),
        compute_rmsfe(compute_ar1_forecast(indpro_small, data_small_est, "INDPRO", 12, TRUE), indpro_small$h12_actual)
    )
)

cat("\nAR(1) RMSFE (Benchmark):\n")
print(ar1_rmsfe)
cat("\n")

# ------------------------------------------------------------------------------
# 6. Relative RMSFE (vs RW and AR(1))
# ------------------------------------------------------------------------------

cat("Step 6: Computing relative RMSFE vs benchmarks...\n")

# Relative RMSFE vs Random Walk
relative_rmsfe_rw <- rmsfe_results %>%
    left_join(rw_rmsfe, by = "variable", suffix = c("_model", "_rw")) %>%
    mutate(
        rel_h1_rw = h1_model / h1_rw,
        rel_h3_rw = h3_model / h3_rw,
        rel_h12_rw = h12_model / h12_rw
    ) %>%
    select(model, variable, rel_h1_rw, rel_h3_rw, rel_h12_rw)

# Relative RMSFE vs AR(1)
relative_rmsfe_ar1 <- rmsfe_results %>%
    left_join(ar1_rmsfe, by = "variable", suffix = c("_model", "_ar1")) %>%
    mutate(
        rel_h1_ar1 = h1_model / h1_ar1,
        rel_h3_ar1 = h3_model / h3_ar1,
        rel_h12_ar1 = h12_model / h12_ar1
    ) %>%
    select(model, variable, rel_h1_ar1, rel_h3_ar1, rel_h12_ar1)

# Combined relative RMSFE table
relative_rmsfe <- relative_rmsfe_rw %>%
    left_join(relative_rmsfe_ar1, by = c("model", "variable"))

# Legacy naming for RW-relative RMSFE (used by visualization/notes)
relative_rmsfe_legacy <- relative_rmsfe_rw %>%
    transmute(
        model,
        variable,
        rel_h1 = rel_h1_rw,
        rel_h3 = rel_h3_rw,
        rel_h12 = rel_h12_rw
    )

cat("\nRelative RMSFE (< 1 = Better than benchmark):\n")
cat("\nvs Random Walk:\n")
print(relative_rmsfe_rw)
cat("\nvs AR(1):\n")
print(relative_rmsfe_ar1)
cat("\n")

# Interpretation summary for relative RMSFE
cat("Relative RMSFE interpretation (lower is better):\n")
for (var_label in unique(relative_rmsfe_rw$variable)) {
    for (h in c("h1", "h3", "h12")) {
        col <- paste0("rel_", h, "_rw")
        subset_df <- relative_rmsfe_rw %>% filter(variable == var_label)
        best_row <- subset_df[which.min(subset_df[[col]]), ]
        cat(sprintf(
            "  %s %s vs RW: best = %s (%.3f)\n",
            var_label, h, best_row$model, best_row[[col]]
        ))
    }
}
cat("\n")

# ------------------------------------------------------------------------------
# 7. Diebold-Mariano Tests (vs RW and AR(1))
# ------------------------------------------------------------------------------

cat("Step 7: Diebold-Mariano tests...\n")

dm_test_custom <- function(forecast, actual, benchmark_forecast = 0, horizon = 1) {
    e1 <- (forecast - actual)^2
    e2 <- (benchmark_forecast - actual)^2
    d <- e1 - e2

    valid <- !is.na(d)
    d_clean <- d[valid]

    if (length(d_clean) < 10) {
        return(list(statistic = NA, p.value = NA))
    }

    # Use Newey-West for HAC-robust variance
    dm_reg <- lm(d_clean ~ 1)
    dm_test <- coeftest(dm_reg, vcov = NeweyWest(dm_reg, lag = horizon))

    list(
        statistic = dm_test[1, "t value"],
        p.value = dm_test[1, "Pr(>|t|)"]
    )
}

# DM tests vs Random Walk
cat("\n=== DM Test vs Benchmarks (H0: Equal accuracy) ===\n")

horizons <- c(1, 3, 12)
models <- list(
    Small = list(cpi = cpi_small, indpro = indpro_small, data_est = data_small_est),
    Medium = list(cpi = cpi_medium, indpro = indpro_medium, data_est = data_medium_est),
    Full = list(cpi = cpi_full, indpro = indpro_full, data_est = data_full_est)
)
var_map <- list(CPI = "CPIAUCSL", INDPRO = "INDPRO")

dm_results <- list()

for (model_name in names(models)) {
    model <- models[[model_name]]
    for (var_label in names(var_map)) {
        df <- if (var_label == "CPI") model$cpi else model$indpro
        var_name <- var_map[[var_label]]

        for (h in horizons) {
            fcast <- df[[paste0("h", h, "_forecast")]]
            actual <- df[[paste0("h", h, "_actual")]]

            dm_rw <- dm_test_custom(fcast, actual, 0, horizon = h)
            dm_results[[length(dm_results) + 1]] <- data.frame(
                model = model_name,
                variable = var_label,
                horizon = paste0("h=", h),
                benchmark = "RW",
                statistic = dm_rw$statistic,
                p_value = dm_rw$p.value
            )

            ar1_fcast <- compute_ar1_forecast(df, model$data_est, var_name, h, TRUE)
            dm_ar1 <- dm_test_custom(fcast, actual, ar1_fcast, horizon = h)
            dm_results[[length(dm_results) + 1]] <- data.frame(
                model = model_name,
                variable = var_label,
                horizon = paste0("h=", h),
                benchmark = "AR1",
                statistic = dm_ar1$statistic,
                p_value = dm_ar1$p.value
            )
        }
    }
}

dm_results <- bind_rows(dm_results)
cat("\nDM test summary (first 12 rows):\n")
print(head(dm_results, 12), row.names = FALSE)

cat("\nDM tests vs benchmarks (significant at 5%):\n")
sig_dm <- dm_results %>% filter(!is.na(p_value) & p_value < 0.05)
if (nrow(sig_dm) == 0) {
    cat("  None.\n")
} else {
    for (i in 1:nrow(sig_dm)) {
        row <- sig_dm[i, ]
        direction <- if (row$statistic < 0) "better than" else "worse than"
        cat(sprintf(
            "  %s %s %s: %s %s (t=%.2f, p=%.3f)\n",
            row$model, row$variable, row$horizon, direction, row$benchmark,
            row$statistic, row$p_value
        ))
    }
}
cat("\n")

# DM tests between model specifications
dm_model_results <- list()
model_pairs <- list(
    c("Small", "Medium"),
    c("Small", "Full"),
    c("Medium", "Full")
)

for (pair in model_pairs) {
    model_a <- models[[pair[1]]]
    model_b <- models[[pair[2]]]

    for (var_label in names(var_map)) {
        df_a <- if (var_label == "CPI") model_a$cpi else model_a$indpro
        df_b <- if (var_label == "CPI") model_b$cpi else model_b$indpro

        for (h in horizons) {
            fcast_a <- df_a[[paste0("h", h, "_forecast")]]
            fcast_b <- df_b[[paste0("h", h, "_forecast")]]
            actual <- df_a[[paste0("h", h, "_actual")]]

            dm_pair <- dm_test_custom(fcast_a, actual, fcast_b, horizon = h)
            dm_model_results[[length(dm_model_results) + 1]] <- data.frame(
                model_a = pair[1],
                model_b = pair[2],
                variable = var_label,
                horizon = paste0("h=", h),
                statistic = dm_pair$statistic,
                p_value = dm_pair$p.value
            )
        }
    }
}

dm_model_results <- bind_rows(dm_model_results)
cat("\nDM model comparison summary (first 12 rows):\n")
print(head(dm_model_results, 12), row.names = FALSE)

cat("\nDM model comparisons (significant at 5%):\n")
sig_dm_model <- dm_model_results %>% filter(!is.na(p_value) & p_value < 0.05)
if (nrow(sig_dm_model) == 0) {
    cat("  None.\n")
} else {
    for (i in 1:nrow(sig_dm_model)) {
        row <- sig_dm_model[i, ]
        direction <- if (row$statistic < 0) "better than" else "worse than"
        cat(sprintf(
            "  %s vs %s %s %s: %s (t=%.2f, p=%.3f)\n",
            row$model_a, row$model_b, row$variable, row$horizon,
            direction, row$statistic, row$p_value
        ))
    }
}
cat("\n")

cat("\n")

# ------------------------------------------------------------------------------
# 7.5 Clark-West (2007) MSPE-adjusted Tests for Nested Models
# ------------------------------------------------------------------------------

cat("Step 7.5: Clark-West (2007) tests for nested models...\n")

clark_west_test <- function(f_small, f_large, actual, horizon = 1) {
    # Clark-West adjusted loss differential for nested models:
    # e1 = y - f1 (smaller), e2 = y - f2 (larger)
    # d_t = e1^2 - (e2^2 - (f2 - f1)^2)

    valid <- !is.na(f_small) & !is.na(f_large) & !is.na(actual)
    if (sum(valid) < 10) {
        return(list(
            n = sum(valid),
            estimate = NA_real_,
            se_hac = NA_real_,
            t_stat = NA_real_,
            p_one_sided = NA_real_,
            lag = horizon
        ))
    }

    y <- actual[valid]
    f1 <- f_small[valid]
    f2 <- f_large[valid]

    e1 <- y - f1
    e2 <- y - f2
    d <- e1^2 - (e2^2 - (f2 - f1)^2)

    cw_reg <- lm(d ~ 1)
    lag <- max(1, horizon) # overlap-adjusted; common choice is h-1 or h
    cw_ct <- coeftest(cw_reg, vcov = NeweyWest(cw_reg, lag = lag))

    estimate <- as.numeric(cw_ct[1, "Estimate"])
    se_hac <- as.numeric(cw_ct[1, "Std. Error"])
    t_stat <- as.numeric(cw_ct[1, "t value"])

    # One-sided p-value: H1 = E[d] > 0 (larger model improves MSPE)
    df <- max(1, sum(valid) - 1)
    p_one_sided <- pt(t_stat, df = df, lower.tail = FALSE)

    list(
        n = sum(valid),
        estimate = estimate,
        se_hac = se_hac,
        t_stat = t_stat,
        p_one_sided = p_one_sided,
        lag = lag
    )
}

cw_pairs <- list(
    c("Small", "Medium"),
    c("Medium", "Full")
)

cw_results <- list()

for (pair in cw_pairs) {
    model_small <- models[[pair[1]]]
    model_large <- models[[pair[2]]]

    for (var_label in names(var_map)) {
        df_small <- if (var_label == "CPI") model_small$cpi else model_small$indpro
        df_large <- if (var_label == "CPI") model_large$cpi else model_large$indpro

        for (h in horizons) {
            f1 <- df_small[[paste0("h", h, "_forecast")]]
            f2 <- df_large[[paste0("h", h, "_forecast")]]
            y <- df_small[[paste0("h", h, "_actual")]]

            cw <- clark_west_test(f1, f2, y, horizon = h)
            cw_results[[length(cw_results) + 1]] <- data.frame(
                smaller_model = pair[1],
                larger_model = pair[2],
                variable = var_label,
                horizon = paste0("h=", h),
                n_obs = cw$n,
                estimate = cw$estimate,
                se_hac = cw$se_hac,
                t_stat = cw$t_stat,
                p_value_one_sided = cw$p_one_sided,
                nw_lag = cw$lag
            )
        }
    }
}

cw_results <- bind_rows(cw_results)
cat("\nClark-West test summary:\n")
print(cw_results, row.names = FALSE)
cat("\n")

# ------------------------------------------------------------------------------
# 8. Save Results
# ------------------------------------------------------------------------------

cat("Step 8: Saving evaluation results...\n")

# Save RMSFE results
write.csv(rmsfe_results, "results/tables/rmsfe_results.csv", row.names = FALSE)
write.csv(rw_rmsfe, "results/tables/rw_rmsfe_benchmark.csv", row.names = FALSE)
write.csv(ar1_rmsfe, "results/tables/ar1_rmsfe_benchmark.csv", row.names = FALSE)

# Save relative RMSFE
write.csv(relative_rmsfe_rw, "results/tables/relative_rmsfe_vs_rw.csv", row.names = FALSE)
write.csv(relative_rmsfe_ar1, "results/tables/relative_rmsfe_vs_ar1.csv", row.names = FALSE)
write.csv(relative_rmsfe, "results/tables/relative_rmsfe_combined.csv", row.names = FALSE)
write.csv(relative_rmsfe_legacy, "results/tables/relative_rmsfe.csv", row.names = FALSE)
write.csv(dm_results, "results/tables/dm_test_results.csv", row.names = FALSE)
write.csv(dm_model_results, "results/tables/dm_model_comparison.csv", row.names = FALSE)
write.csv(cw_results, "results/tables/clark_west_tests.csv", row.names = FALSE)

# Save all aligned forecasts and actuals
saveRDS(
    list(
        cpi_small = cpi_small,
        cpi_medium = cpi_medium,
        cpi_full = cpi_full,
        indpro_small = indpro_small,
        indpro_medium = indpro_medium,
        indpro_full = indpro_full
    ),
    "results/forecasts/aligned_forecasts_actuals.rds"
)

cat("  ✓ Saved to results/tables/ and results/forecasts/\n\n")

cat("✓ Forecast evaluation complete!\n")
cat("Next step: Run 07_cg_regression.R\n\n")

