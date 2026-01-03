# ==============================================================================
# 12_consistency_audit.R
# Purpose: Lightweight consistency audit for transformations, alignment, and specs
# Author: Jingle Fu
# Date: 2025-12-29
# ==============================================================================

cat("\n=== Consistency Audit (Data / Forecast / Evaluation) ===\n\n")

library(xts)
library(zoo)
library(tidyverse)

horizons <- c(1, 3, 12)

cat("Step 1: Loading core datasets...\n")
data_small_est <- readRDS("data/processed/data_small_estimation.rds")
data_medium_est <- readRDS("data/processed/data_medium_estimation.rds")
data_full_est <- readRDS("data/processed/data_full_estimation.rds")

aligned <- readRDS("results/forecasts/aligned_forecasts_actuals.rds")

cat("  ✓ Loaded estimation data + aligned forecasts/actuals.\n\n")

cat("Step 2: Checking variable sets (paper design: Small ⊂ Medium ⊂ Full)...\n")
small_vars <- colnames(data_small_est)
medium_vars <- colnames(data_medium_est)
full_vars <- colnames(data_full_est)

check_nested <- function(a, b, name_a, name_b) {
    missing <- setdiff(a, b)
    if (length(missing) == 0) {
        cat(sprintf("  ✓ %s ⊂ %s\n", name_a, name_b))
    } else {
        cat(sprintf("  ✗ %s not subset of %s; missing: %s\n", name_a, name_b, paste(missing, collapse = ", ")))
    }
}

check_nested(small_vars, medium_vars, "Small", "Medium")
check_nested(medium_vars, full_vars, "Medium", "Full")
cat("\n")

cat("Step 3: Checking log-level treatment assumptions...\n")
cat("  Paper expects log-levels for INDPRO, CPIAUCSL (and SP500), levels for rates/sentiment.\n")

is_plausible_log <- function(x) {
    rng <- range(as.numeric(x), na.rm = TRUE)
    all(is.finite(rng)) && rng[1] > 0 && rng[2] < 10
}

log_candidates <- c("INDPRO", "CPIAUCSL", "SP500")
level_candidates <- c("UNRATE", "FEDFUNDS", "GS10", "UMCSENT")

for (v in intersect(log_candidates, colnames(data_full_est))) {
    cat(sprintf("  %s range: [%.3f, %.3f] (log-plausible=%s)\n",
                v,
                min(data_full_est[, v], na.rm = TRUE),
                max(data_full_est[, v], na.rm = TRUE),
                is_plausible_log(data_full_est[, v])))
}
for (v in intersect(level_candidates, colnames(data_full_est))) {
    cat(sprintf("  %s range: [%.3f, %.3f]\n",
                v,
                min(data_full_est[, v], na.rm = TRUE),
                max(data_full_est[, v], na.rm = TRUE)))
}
cat("\n")

cat("Step 4: Checking target-date alignment for Fig6-style plots...\n")
cat("  Verifies that target_date_h{h} equals index(data)[origin_idx+h] for CPI and INDPRO.\n")

check_target_dates <- function(df, data_est, h) {
    tcol <- paste0("target_date_h", h)
    if (!(tcol %in% names(df))) {
        return(NA)
    }
    origin_idx <- as.integer(df$origin_idx)
    target_expected <- as.Date(index(data_est)[origin_idx + h])
    target_stored <- as.Date(df[[tcol]])
    all(target_expected == target_stored, na.rm = TRUE)
}

for (h in horizons) {
    ok_cpi <- check_target_dates(aligned$cpi_small, data_small_est, h)
    ok_ind <- check_target_dates(aligned$indpro_small, data_small_est, h)
    cat(sprintf("  h=%d: CPI=%s; INDPRO=%s\n", h, ok_cpi, ok_ind))
}
cat("\n")

cat("Step 5: Checking actual-growth construction matches definition (log vars)...\n")
compute_growth_series <- function(data_est, var_name, horizon) {
    idx <- which(colnames(data_est) == var_name)
    s <- as.numeric(coredata(data_est)[, idx])
    out <- rep(NA_real_, length(s))
    scale <- 1200 / horizon
    for (t in (horizon + 1):length(s)) {
        out[t] <- scale * (s[t] - s[t - horizon])
    }
    out
}

check_actual_column <- function(df, data_est, var_name, h) {
    actual_col <- paste0("h", h, "_actual")
    if (!(actual_col %in% names(df))) {
        return(tibble(h = h, max_abs_diff = NA_real_))
    }
    series <- compute_growth_series(data_est, var_name, h)
    origin_idx <- as.integer(df$origin_idx)
    expected <- series[origin_idx + h]
    diff <- expected - df[[actual_col]]
    diff <- diff[is.finite(diff)]
    tibble(h = h, max_abs_diff = if (length(diff) == 0) NA_real_ else max(abs(diff)))
}

audit_actuals <- bind_rows(
    lapply(horizons, function(h) check_actual_column(aligned$cpi_small, data_small_est, "CPIAUCSL", h)) %>%
        bind_rows() %>% mutate(variable = "CPI"),
    lapply(horizons, function(h) check_actual_column(aligned$indpro_small, data_small_est, "INDPRO", h)) %>%
        bind_rows() %>% mutate(variable = "INDPRO")
)
print(audit_actuals, n = nrow(audit_actuals))
cat("\n")

cat("Step 6: Report where short-horizon errors are largest (diagnostic for perceived 'gap')...\n")
top_errors <- function(df, h, n = 6) {
    f <- df[[paste0("h", h, "_forecast")]]
    y <- df[[paste0("h", h, "_actual")]]
    err <- y - f
    tcol <- paste0("target_date_h", h)
    target <- if (tcol %in% names(df)) as.Date(df[[tcol]]) else as.Date(as.yearmon(df$origin_date) + h / 12, frac = 1)
    ord <- order(abs(err), decreasing = TRUE)
    idx <- head(ord, n)
    tibble(
        horizon = h,
        origin_date = as.Date(df$origin_date[idx]),
        target_date = target[idx],
        forecast = f[idx],
        actual = y[idx],
        error = err[idx]
    )
}

gap_report <- bind_rows(
    top_errors(aligned$cpi_small, 1),
    top_errors(aligned$cpi_small, 3),
    top_errors(aligned$indpro_small, 1),
    top_errors(aligned$indpro_small, 3)
)
print(gap_report, n = nrow(gap_report))
cat("\n")

cat("✓ Consistency audit complete.\n\n")

