# ==============================================================================
# 11_error_decomposition_and_rolling_rmsfe.R
# Purpose: Robustness extensions: error decomposition + rolling RMSFE diagnostics
# Author: Jingle Fu
# Date: 2025-12-29
# ==============================================================================

cat("\n=== Robustness Extension: Error Decomposition & Rolling RMSFE ===\n\n")

library(tidyverse)
library(zoo)

horizons <- c(1, 3, 12)
rolling_window <- getOption("bayesian_de.rolling_window", 60) # months

# ------------------------------------------------------------------------------
# Helpers (consistent with 06_forecast_evaluation.R)
# ------------------------------------------------------------------------------

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

compute_ar1_forecast_at_origins <- function(origins, data_est, var_name, horizon, is_log = TRUE) {
    growth_series <- compute_growth_series(data_est, var_name, horizon, is_log)
    origins <- as.integer(origins)
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

rolling_rmsfe_vec <- function(errors, width) {
    if (length(errors) == 0) {
        return(numeric(0))
    }
    zoo::rollapply(
        errors,
        width = width,
        align = "right",
        fill = NA_real_,
        FUN = function(x) {
            x <- x[!is.na(x)]
            if (length(x) == 0) {
                return(NA_real_)
            }
            sqrt(mean(x^2))
        }
    )
}

compute_target_date <- function(origin_date, horizon) {
    as.Date(as.yearmon(origin_date) + horizon / 12, frac = 1)
}

get_target_date_from_aligned <- function(df, horizon) {
    col <- paste0("target_date_h", horizon)
    if (col %in% names(df)) {
        return(as.Date(df[[col]]))
    }
    compute_target_date(as.Date(df$origin_date), horizon)
}

parse_aligned_key <- function(key) {
    parts <- strsplit(key, "_")[[1]]
    if (length(parts) != 2) {
        return(NULL)
    }
    var_part <- parts[1]
    model_part <- parts[2]

    variable <- if (var_part == "cpi") "CPI" else if (var_part == "indpro") "INDPRO" else NA_character_
    model <- if (model_part == "small") "Small" else if (model_part == "medium") "Medium" else if (model_part == "full") "Full" else NA_character_

    if (is.na(variable) || is.na(model)) {
        return(NULL)
    }
    list(variable = variable, model = model)
}

aligned_to_errors_long <- function(aligned_list, scenario_label) {
    out <- list()
    for (key in names(aligned_list)) {
        meta <- parse_aligned_key(key)
        if (is.null(meta)) {
            next
        }
        df <- aligned_list[[key]]
        if (is.null(df) || !all(c("origin_date", "origin_idx") %in% names(df))) {
            next
        }
        df <- df %>% mutate(origin_date = as.Date(origin_date))

        for (h in horizons) {
            fcol <- paste0("h", h, "_forecast")
            acol <- paste0("h", h, "_actual")
            if (!all(c(fcol, acol) %in% names(df))) {
                next
            }

            tmp <- df %>%
                transmute(
                    scenario = scenario_label,
                    model = meta$model,
                    variable = meta$variable,
                    horizon = h,
                    origin_date,
                    origin_idx = as.integer(origin_idx),
                    target_date = get_target_date_from_aligned(df, h),
                    forecast = .data[[fcol]],
                    actual = .data[[acol]]
                ) %>%
                mutate(error = actual - forecast) %>%
                filter(!is.na(target_date) & !is.na(actual) & !is.na(forecast))

            out[[length(out) + 1]] <- tmp
        }
    }

    bind_rows(out)
}

compute_error_decomposition <- function(forecast, actual) {
    valid <- !(is.na(forecast) | is.na(actual))
    forecast <- as.numeric(forecast[valid])
    actual <- as.numeric(actual[valid])
    if (length(forecast) < 5) {
        return(tibble(
            n = length(forecast),
            mse = NA_real_,
            rmse = NA_real_,
            bias = NA_real_,
            bias_prop = NA_real_,
            var_prop = NA_real_,
            covar_prop = NA_real_,
            corr = NA_real_,
            sd_forecast = NA_real_,
            sd_actual = NA_real_
        ))
    }

    err <- actual - forecast
    mse <- mean(err^2)
    bias <- mean(err)
    sd_f <- sd(forecast)
    sd_a <- sd(actual)
    corr_fa <- suppressWarnings(cor(forecast, actual))

    if (!is.finite(mse) || mse <= 0) {
        return(tibble(
            n = length(forecast),
            mse = mse,
            rmse = sqrt(mse),
            bias = bias,
            bias_prop = NA_real_,
            var_prop = NA_real_,
            covar_prop = NA_real_,
            corr = corr_fa,
            sd_forecast = sd_f,
            sd_actual = sd_a
        ))
    }

    bias_prop <- (bias^2) / mse
    var_prop <- ((sd_f - sd_a)^2) / mse
    covar_prop <- (2 * sd_f * sd_a * (1 - corr_fa)) / mse

    tibble(
        n = length(forecast),
        mse = mse,
        rmse = sqrt(mse),
        bias = bias,
        bias_prop = bias_prop,
        var_prop = var_prop,
        covar_prop = covar_prop,
        corr = corr_fa,
        sd_forecast = sd_f,
        sd_actual = sd_a
    )
}

plot_error_decomposition <- function(decomp_df, out_file, title) {
    df_long <- decomp_df %>%
        select(scenario, model, variable, horizon, bias_prop, var_prop, covar_prop) %>%
        pivot_longer(cols = c(bias_prop, var_prop, covar_prop), names_to = "component", values_to = "share") %>%
        mutate(
            component = recode(
                component,
                bias_prop = "Bias",
                var_prop = "Variance",
                covar_prop = "Covariance"
            ),
            horizon = factor(paste0("h=", horizon), levels = c("h=1", "h=3", "h=12"))
        )

    p <- ggplot(df_long, aes(x = horizon, y = share, fill = component)) +
        geom_col(width = 0.7) +
        facet_grid(variable ~ model) +
        scale_fill_brewer(palette = "Set2") +
        labs(
            title = title,
            subtitle = "Theil MSE decomposition shares (Bias / Variance / Covariance)",
            x = "Horizon",
            y = "Share of MSE",
            fill = ""
        ) +
        theme_minimal(base_size = 11) +
        theme(legend.position = "bottom")

    ggsave(out_file, p, width = 12, height = 6.5, dpi = 300)
    cat(sprintf("  Saved: %s\n", out_file))
}

plot_rolling_relative <- function(rel_df, out_file, title) {
    rel_df <- rel_df %>%
        filter(!is.na(target_date) & is.finite(rel_rmsfe)) %>%
        mutate(
            horizon = factor(paste0("h=", horizon), levels = c("h=1", "h=3", "h=12"))
        )

    p <- ggplot(rel_df, aes(x = target_date, y = rel_rmsfe, color = model)) +
        geom_line(linewidth = 0.9, alpha = 0.9) +
        geom_hline(yintercept = 1, linetype = "dashed", color = "gray40", linewidth = 0.8) +
        facet_grid(variable ~ horizon, scales = "free_y") +
        scale_color_brewer(palette = "Set1") +
        labs(
            title = title,
            subtitle = sprintf("Rolling window = %d months; values < 1 improve on the benchmark", rolling_window),
            x = "Target date (t+h)",
            y = "Rolling relative RMSFE",
            color = "Model"
        ) +
        theme_minimal(base_size = 11) +
        theme(legend.position = "bottom")

    ggsave(out_file, p, width = 12, height = 7, dpi = 300)
    cat(sprintf("  Saved: %s\n", out_file))
}

validate_time_alignment <- function(aligned_df, data_est, var_name, horizon, actual_col) {
    growth_series <- compute_growth_series(data_est, var_name, horizon, is_log = TRUE)
    origins <- as.integer(aligned_df$origin_idx)
    expected <- rep(NA_real_, length(origins))
    for (i in seq_along(origins)) {
        t0 <- origins[i]
        t_target <- t0 + horizon
        if (is.na(t0) || t_target < 1 || t_target > length(growth_series)) {
            next
        }
        expected[i] <- growth_series[t_target]
    }
    actual <- aligned_df[[actual_col]]
    diff <- expected - actual
    diff <- diff[is.finite(diff)]
    if (length(diff) == 0) {
        return(NA_real_)
    }
    max(abs(diff))
}

# ------------------------------------------------------------------------------
# 1. Load baseline + robustness aligned forecasts (if available)
# ------------------------------------------------------------------------------

cat("Step 1: Loading aligned forecasts/actuals...\n")

baseline_aligned <- readRDS("results/forecasts/aligned_forecasts_actuals.rds")
baseline_small_est <- readRDS("data/processed/data_small_estimation.rds")
baseline_medium_est <- readRDS("data/processed/data_medium_estimation.rds")
baseline_full_est <- readRDS("data/processed/data_full_estimation.rds")

all_runs <- list(
    baseline = list(
        label = "baseline",
        aligned = baseline_aligned,
        data_small = baseline_small_est,
        data_medium = baseline_medium_est,
        data_full = baseline_full_est,
        out_tables = "results/tables",
        out_figures = "results/figures"
    )
)

robust_root <- "results/robustness"
if (dir.exists(robust_root)) {
    scenario_dirs <- list.dirs(robust_root, recursive = FALSE, full.names = TRUE)
    for (scenario_dir in scenario_dirs) {
        label <- basename(scenario_dir)
        aligned_path <- file.path(scenario_dir, "forecasts", "aligned_forecasts_actuals.rds")
        if (!file.exists(aligned_path)) {
            next
        }
        all_runs[[label]] <- list(
            label = label,
            aligned = readRDS(aligned_path),
            data_small = baseline_small_est,
            data_medium = baseline_medium_est,
            data_full = baseline_full_est,
            out_tables = file.path(scenario_dir, "tables"),
            out_figures = file.path(scenario_dir, "figures")
        )
    }
}

cat(sprintf("  Runs detected: %d (baseline + robustness scenarios)\n\n", length(all_runs)))

# ------------------------------------------------------------------------------
# 2. Time-axis alignment checks (t+h)
# ------------------------------------------------------------------------------

cat("Step 2: Validating 'forecast vs actual' time alignment...\n")
cat("  (Checks that stored actual at origin t matches realized growth ending at t+h)\n")

for (run in all_runs) {
    aligned <- run$aligned
    cat(sprintf("\n  [%s]\n", run$label))

    checks <- tibble()
    for (h in horizons) {
        checks <- bind_rows(
            checks,
            tibble(
                variable = "CPI",
                horizon = h,
                max_abs_diff = validate_time_alignment(aligned$cpi_small, run$data_small, "CPIAUCSL", h, paste0("h", h, "_actual"))
            ),
            tibble(
                variable = "INDPRO",
                horizon = h,
                max_abs_diff = validate_time_alignment(aligned$indpro_small, run$data_small, "INDPRO", h, paste0("h", h, "_actual"))
            )
        )
    }
    print(checks, n = nrow(checks))
}
cat("\n")

# ------------------------------------------------------------------------------
# 3. Error decomposition (baseline + each robustness scenario)
# ------------------------------------------------------------------------------

cat("Step 3: Computing Theil error decomposition...\n")

for (run in all_runs) {
    dir.create(run$out_tables, recursive = TRUE, showWarnings = FALSE)
    dir.create(run$out_figures, recursive = TRUE, showWarnings = FALSE)

    errors_long <- aligned_to_errors_long(run$aligned, run$label)

    decomp <- errors_long %>%
        group_by(scenario, model, variable, horizon) %>%
        summarize(compute_error_decomposition(forecast, actual), .groups = "drop")

    out_csv <- file.path(run$out_tables, "error_decomposition.csv")
    write.csv(decomp, out_csv, row.names = FALSE)
    cat(sprintf("  [%s] Saved: %s\n", run$label, out_csv))

    if (run$label == "baseline") {
        plot_error_decomposition(
            decomp,
            file.path(run$out_figures, "fig_error_decomposition.png"),
            "Error Decomposition (Baseline)"
        )
    } else {
        plot_error_decomposition(
            decomp,
            file.path(run$out_figures, "fig_error_decomposition.png"),
            sprintf("Error Decomposition (%s)", run$label)
        )
    }

    cat(sprintf("\n  [%s] Decomposition highlights (lowest RMSE among BVAR models):\n", run$label))
    best <- decomp %>%
        filter(model %in% c("Small", "Medium", "Full")) %>%
        group_by(variable, horizon) %>%
        slice_min(rmse, n = 1, with_ties = FALSE) %>%
        ungroup()
    for (i in seq_len(nrow(best))) {
        row <- best[i, ]
        bias_dir <- if (!is.na(row$bias) && row$bias > 0) "under-predicts" else if (!is.na(row$bias) && row$bias < 0) "over-predicts" else "no-bias"
        cat(sprintf(
            "    %s h=%d: best=%s (RMSE=%.3f; bias=%.3f, %s; bias share=%.2f)\n",
            row$variable, row$horizon, row$model, row$rmse, row$bias, bias_dir, row$bias_prop
        ))
    }
    cat("\n")
}

# ------------------------------------------------------------------------------
# 4. Rolling RMSFE + rolling relative RMSFE (vs RW / AR1)
# ------------------------------------------------------------------------------

cat("Step 4: Computing rolling RMSFE and rolling relative RMSFE...\n")
cat(sprintf("  Rolling window: %d months\n\n", rolling_window))

for (run in all_runs) {
    aligned <- run$aligned

    errors_long <- aligned_to_errors_long(aligned, run$label)

    # Benchmarks constructed on the same aligned target dates/actuals
    base_points <- errors_long %>%
        distinct(scenario, variable, horizon, origin_date, origin_idx, target_date, actual) %>%
        arrange(variable, horizon, target_date)

    rw_points <- base_points %>%
        mutate(model = "RW", forecast = 0, error = actual - forecast)

    ar1_points <- base_points %>%
        group_by(variable, horizon) %>%
        group_modify(function(df, keys) {
            var_name <- if (keys$variable[1] == "CPI") "CPIAUCSL" else "INDPRO"
            origins <- df$origin_idx
            ar1_forecast <- compute_ar1_forecast_at_origins(origins, run$data_small, var_name, keys$horizon[1], TRUE)
            df %>% mutate(model = "AR1", forecast = ar1_forecast, error = actual - forecast)
        }) %>%
        ungroup()

    all_points <- bind_rows(
        errors_long %>% select(scenario, model, variable, horizon, origin_date, origin_idx, target_date, forecast, actual, error),
        rw_points %>% select(scenario, model, variable, horizon, origin_date, origin_idx, target_date, forecast, actual, error),
        ar1_points %>% select(scenario, model, variable, horizon, origin_date, origin_idx, target_date, forecast, actual, error)
    )

    rolling_rmsfe <- all_points %>%
        group_by(scenario, model, variable, horizon) %>%
        arrange(target_date, .by_group = TRUE) %>%
        mutate(rolling_rmsfe = rolling_rmsfe_vec(error, rolling_window)) %>%
        ungroup()

    out_roll <- file.path(run$out_tables, "rolling_rmsfe.csv")
    write.csv(rolling_rmsfe, out_roll, row.names = FALSE)
    cat(sprintf("  [%s] Saved: %s\n", run$label, out_roll))

    roll_rw <- rolling_rmsfe %>%
        filter(model == "RW" & !is.na(target_date)) %>%
        group_by(scenario, variable, horizon, target_date) %>%
        summarize(rw = mean(rolling_rmsfe, na.rm = TRUE), .groups = "drop")

    roll_ar1 <- rolling_rmsfe %>%
        filter(model == "AR1" & !is.na(target_date)) %>%
        group_by(scenario, variable, horizon, target_date) %>%
        summarize(ar1 = mean(rolling_rmsfe, na.rm = TRUE), .groups = "drop")

    roll_rel_rw <- rolling_rmsfe %>%
        filter(model %in% c("Small", "Medium", "Full")) %>%
        filter(!is.na(target_date)) %>%
        left_join(roll_rw, by = c("scenario", "variable", "horizon", "target_date"), relationship = "many-to-one") %>%
        mutate(rel_rmsfe = rolling_rmsfe / rw) %>%
        select(scenario, model, variable, horizon, target_date, rel_rmsfe)

    roll_rel_ar1 <- rolling_rmsfe %>%
        filter(model %in% c("Small", "Medium", "Full")) %>%
        filter(!is.na(target_date)) %>%
        left_join(roll_ar1, by = c("scenario", "variable", "horizon", "target_date"), relationship = "many-to-one") %>%
        mutate(rel_rmsfe = rolling_rmsfe / ar1) %>%
        select(scenario, model, variable, horizon, target_date, rel_rmsfe)

    out_rel_rw <- file.path(run$out_tables, "rolling_relative_rmsfe_vs_rw.csv")
    out_rel_ar1 <- file.path(run$out_tables, "rolling_relative_rmsfe_vs_ar1.csv")
    write.csv(roll_rel_rw, out_rel_rw, row.names = FALSE)
    write.csv(roll_rel_ar1, out_rel_ar1, row.names = FALSE)
    cat(sprintf("  [%s] Saved: %s\n", run$label, out_rel_rw))
    cat(sprintf("  [%s] Saved: %s\n", run$label, out_rel_ar1))

    plot_rolling_relative(
        roll_rel_rw,
        file.path(run$out_figures, "fig_rolling_relative_rmsfe_rw.png"),
        sprintf("Rolling Relative RMSFE vs RW (%s)", run$label)
    )
    plot_rolling_relative(
        roll_rel_ar1,
        file.path(run$out_figures, "fig_rolling_relative_rmsfe_ar1.png"),
        sprintf("Rolling Relative RMSFE vs AR(1) (%s)", run$label)
    )

    cat(sprintf("\n  [%s] Rolling relative RMSFE averages (vs RW):\n", run$label))
    avg_rel <- roll_rel_rw %>%
        group_by(model, variable, horizon) %>%
        summarize(avg_rel = mean(rel_rmsfe, na.rm = TRUE), .groups = "drop") %>%
        arrange(variable, horizon, avg_rel)
    print(avg_rel, n = nrow(avg_rel))
    cat("\n")
}

cat("✓ Robustness extension complete.\n")
cat("Outputs:\n")
cat("  - Baseline tables: results/tables/error_decomposition.csv, results/tables/rolling_relative_rmsfe_vs_*.csv\n")
cat("  - Baseline figures: results/figures/fig_error_decomposition.png, results/figures/fig_rolling_relative_rmsfe_*.png\n")
cat("  - Robustness scenarios (if present): results/robustness/<scenario>/{tables,figures}/\n\n")
