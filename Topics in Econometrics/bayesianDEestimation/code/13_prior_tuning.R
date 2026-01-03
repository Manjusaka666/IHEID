# ==============================================================================
# 13_prior_tuning.R
# Purpose: Try improving short-horizon forecasts by tuning Minnesota hyperprior
#          bounds (no new variables; consistent with ForecastingHorseRace.tex).
# Author: Jingle Fu
# Date: 2025-12-29
# ==============================================================================

cat("\n=== Prior Tuning (Short-Horizon Forecasting) ===\n\n")

library(BVAR)
library(xts)
library(zoo)
library(tidyverse)
library(parallel)

lags <- 12
horizons <- c(1, 3)

start_date <- as.Date(getOption("bayesian_de.tuning_start", "2007-01-31"))
end_date <- as.Date(getOption("bayesian_de.tuning_end", "2011-12-31"))

n_draw <- getOption("bayesian_de.tuning_n_draw", 1200L)
n_burn <- getOption("bayesian_de.tuning_n_burn", 600L)
n_cores <- getOption("bayesian_de.tuning_cores", max(1, min(4, detectCores() - 2)))

cat(sprintf("Window: %s to %s; lags=%d; draws=%d burn=%d; cores=%d\n\n",
            start_date, end_date, lags, n_draw, n_burn, n_cores))

data_small <- readRDS("data/processed/data_small_estimation.rds")
dates <- as.Date(index(data_small))

initial_window_end <- as.Date("2000-12-31")
final_forecast_date <- as.Date("2019-11-30")
initial_idx <- which.min(abs(dates - initial_window_end))
final_idx <- which.min(abs(dates - final_forecast_date))
origins_all <- (initial_idx + 1):final_idx

origins <- origins_all[dates[origins_all] >= start_date & dates[origins_all] <= end_date]
cat(sprintf("Origins in tuning window: %d\n\n", length(origins)))
if (length(origins) < 10) {
    stop("Too few origins in tuning window; widen bayesian_de.tuning_start/end.")
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
        stop("Unsupported forecast structure.")
    }
    all_horizons <- as.matrix(all_horizons)
    if (ncol(all_horizons) != length(var_names) && nrow(all_horizons) == length(var_names)) {
        all_horizons <- t(all_horizons)
    }
    colnames(all_horizons) <- var_names
    all_horizons
}

compute_growth_from_levels <- function(base_t, level_th, horizon) {
    (1200 / horizon) * (level_th - base_t)
}

one_origin_eval <- function(origin_idx, priors) {
    train_matrix <- coredata(data_small[1:origin_idx, ])
    fit <- suppressWarnings(bvar(
        data = train_matrix,
        lags = lags,
        n_draw = n_draw,
        n_burn = n_burn,
        priors = priors,
        mh = bv_mh(),
        verbose = FALSE
    ))
    fcast <- predict(fit, horizon = max(horizons))
    ah <- extract_point_forecast(fcast, colnames(train_matrix))

    out <- list(origin_idx = origin_idx, origin_date = as.Date(index(data_small)[origin_idx]))
    for (v in c("CPIAUCSL", "INDPRO")) {
        base_t <- as.numeric(coredata(data_small)[origin_idx, v])
        for (h in horizons) {
            level_th <- as.numeric(coredata(data_small)[origin_idx + h, v])
            f_level_th <- as.numeric(ah[h, v])

            f_growth <- compute_growth_from_levels(base_t, f_level_th, h)
            a_growth <- compute_growth_from_levels(base_t, level_th, h)

            out[[paste0(v, "_h", h, "_forecast")]] <- f_growth
            out[[paste0(v, "_h", h, "_actual")]] <- a_growth
        }
    }
    as.data.frame(out)
}

rmsfe <- function(f, a) {
    e <- f - a
    e <- e[is.finite(e)]
    if (length(e) == 0) return(NA_real_)
    sqrt(mean(e^2))
}

run_config <- function(config) {
    priors <- bv_priors(
        hyper = "auto",
        mn = bv_mn(
            lambda = bv_lambda(mode = config$lambda_mode, sd = config$lambda_sd, min = config$lambda_min, max = config$lambda_max),
            alpha = bv_alpha(mode = config$alpha_mode, sd = config$alpha_sd, min = config$alpha_min, max = config$alpha_max),
            psi = bv_psi(mode = "auto")
        ),
        soc = bv_soc(mode = 1, sd = 1, min = 0.01, max = 50),
        sur = bv_sur(mode = 1, sd = 1, min = 0.01, max = 50)
    )

    cl <- makeCluster(n_cores, type = "PSOCK")
    on.exit(stopCluster(cl), add = TRUE)
    clusterEvalQ(cl, { library(BVAR); library(xts) })
    clusterExport(cl, varlist = c(
        "data_small", "lags", "horizons", "n_draw", "n_burn",
        "extract_point_forecast", "compute_growth_from_levels",
        "one_origin_eval", "priors"
    ), envir = environment())

    rows <- parLapply(cl, origins, function(idx) one_origin_eval(idx, priors))
    df <- bind_rows(rows)

    metrics <- list()
    for (v in c("CPIAUCSL", "INDPRO")) {
        for (h in horizons) {
            f <- df[[paste0(v, "_h", h, "_forecast")]]
            a <- df[[paste0(v, "_h", h, "_actual")]]
            metrics[[length(metrics) + 1]] <- tibble(
                config = config$name,
                variable = if (v == "CPIAUCSL") "CPI" else "INDPRO",
                horizon = paste0("h=", h),
                rmsfe = rmsfe(f, a)
            )
        }
    }
    bind_rows(metrics)
}

# Configurations to try (edit/extend as needed; no new variables)
configs <- list(
    list(
        name = "alpha2_default_lambda",
        lambda_mode = 0.2, lambda_sd = 0.4, lambda_min = 0.01, lambda_max = 5,
        alpha_mode = 2, alpha_sd = 0.25, alpha_min = 1, alpha_max = 3
    ),
    list(
        name = "alpha2_looser_lambda_min005",
        lambda_mode = 0.2, lambda_sd = 0.4, lambda_min = 0.05, lambda_max = 5,
        alpha_mode = 2, alpha_sd = 0.25, alpha_min = 1, alpha_max = 3
    )
)

cat("Step 1: Running tuning grid...\n")
all_metrics <- bind_rows(lapply(configs, run_config))
print(all_metrics)
cat("\n")

cat("Step 2: Ranking by variable/horizon...\n")
ranked <- all_metrics %>%
    group_by(variable, horizon) %>%
    arrange(rmsfe, .by_group = TRUE) %>%
    mutate(rank = row_number()) %>%
    ungroup()
print(ranked)
cat("\n")

dir.create("results/tables", showWarnings = FALSE, recursive = TRUE)
write.csv(ranked, "results/tables/prior_tuning_short_horizon.csv", row.names = FALSE)
cat("✓ Saved: results/tables/prior_tuning_short_horizon.csv\n\n")
