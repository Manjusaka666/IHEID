# ==============================================================================
# 08_visualization.R
# Purpose: Create publication-quality figures for BVAR analysis
# Author: Jingle Fu
# Date: 2025-12-26
# ==============================================================================
cat("\n=== Generating Visualization ===\n\n")
library(tidyverse)
library(gridExtra)
library(scales)
library(zoo)
# ------------------------------------------------------------------------------
# 1. Load Data
# ------------------------------------------------------------------------------
cat("Step 1: Loading analysis results...\n")
# Forecast evaluation
rmsfe_results <- read.csv("results/tables/rmsfe_results.csv")
relative_rmsfe_file <- if (file.exists("results/tables/relative_rmsfe_vs_rw.csv")) {
    "results/tables/relative_rmsfe_vs_rw.csv"
} else {
    "results/tables/relative_rmsfe.csv"
}
relative_rmsfe <- read.csv(relative_rmsfe_file)
if ("rel_h1_rw" %in% colnames(relative_rmsfe)) {
    relative_rmsfe <- relative_rmsfe %>%
        transmute(
            model,
            variable,
            rel_h1 = rel_h1_rw,
            rel_h3 = rel_h3_rw,
            rel_h12 = rel_h12_rw
        )
}
# CG regression
cg_results <- read.csv("results/tables/cg_regression_results.csv")
delta_beta <- read.csv("results/tables/delta_beta_overreaction_test.csv")
# Hyperparameters
hyperparams <- read.csv("results/forecasts/hyperparameters_evolution.csv")
cat("  ?Data loaded.\n\n")
# ------------------------------------------------------------------------------
# 2. Figure 1: Forecast Performance (RMSFE)
# ------------------------------------------------------------------------------
cat("Step 2: Creating RMSFE comparison plot...\n")
# Reshape for plotting
rmsfe_long <- rmsfe_results %>%
    select(model, variable, h1, h3, h12) %>%
    pivot_longer(cols = c(h1, h3, h12), names_to = "horizon", values_to = "rmsfe") %>%
    mutate(horizon = factor(horizon, levels = c("h1", "h3", "h12"), labels = c("h=1", "h=3", "h=12")))
p1 <- ggplot(rmsfe_long, aes(x = horizon, y = rmsfe, fill = model)) +
    geom_bar(stat = "identity", position = "dodge", width = 0.7) +
    facet_wrap(~variable, scales = "free_y") +
    scale_fill_brewer(palette = "Set2") +
    labs(
        title = "Forecast Performance: Root Mean Squared Forecast Error",
        subtitle = "Lower is better",
        x = "Forecast horizon",
        y = "RMSFE",
        fill = "Model"
    ) +
    theme_minimal() +
    theme(
        plot.title = element_text(face = "bold", size = 14),
        legend.position = "bottom"
    )
ggsave("results/figures/fig1_rmsfe_comparison.png", p1, width = 10, height = 6, dpi = 300)
cat("  ?Saved: fig1_rmsfe_comparison.png\n\n")
# ------------------------------------------------------------------------------
# 3. Figure 2: Relative RMSFE (vs Random Walk)
# ------------------------------------------------------------------------------
cat("Step 3: Creating relative RMSFE plot...\n")
rel_rmsfe_long <- relative_rmsfe %>%
    select(model, variable, rel_h1, rel_h3, rel_h12) %>%
    pivot_longer(cols = starts_with("rel_"), names_to = "horizon", values_to = "rel_rmsfe") %>%
    mutate(horizon = factor(horizon, levels = c("rel_h1", "rel_h3", "rel_h12"), labels = c("h=1", "h=3", "h=12")))
p2 <- ggplot(rel_rmsfe_long, aes(x = horizon, y = rel_rmsfe, color = model, group = model)) +
    geom_line(linewidth = 1.2) +
    geom_point(size = 3) +
    geom_hline(yintercept = 1, linetype = "dashed", color = "gray40", linewidth = 0.8) +
    facet_wrap(~variable) +
    scale_color_brewer(palette = "Set1") +
    labs(
        title = "Relative Forecast Performance vs. Random Walk",
        subtitle = "Values < 1 indicate better performance than RW (No-Change Benchmark)",
        x = "Forecast horizon",
        y = "Relative RMSFE",
        color = "Model specification"
    ) +
    theme_minimal(base_size = 11) +
    theme(
        plot.title = element_text(face = "bold", size = 14, margin = margin(b = 10)),
        legend.position = "bottom",
        panel.grid.minor = element_blank(),
        strip.text = element_text(face = "bold", size = 12)
    )
ggsave("results/figures/fig2_relative_rmsfe.png", p2, width = 10, height = 6, dpi = 300)
cat("  ?Saved: fig2_relative_rmsfe.png\n\n")
# ------------------------------------------------------------------------------
# 4. Figure 3: CG regression coefficients
# ------------------------------------------------------------------------------
cat("Step 4: Creating CG regression coefficient plot...\n")
cg_results <- cg_results %>%
    mutate(
        ci_lower = beta - 1.96 * se,
        ci_upper = beta + 1.96 * se,
        horizon = factor(horizon, levels = c("h=1", "h=3", "h=12"))
    )
p3 <- ggplot(cg_results, aes(x = horizon, y = beta, color = model)) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "gray40", linewidth = 0.8) +
    geom_point(size = 3.5, position = position_dodge(width = 0.3)) +
    geom_errorbar(
        aes(ymin = ci_lower, ymax = ci_upper),
        width = 0.2,
        linewidth = 0.8,
        position = position_dodge(width = 0.3)
    ) +
    facet_wrap(~variable) +
    scale_color_brewer(palette = "Dark2") +
    labs(
        title = "Revision diagnostic coefficients",
        subtitle = "Sign indicates revision--error association; dashed line denotes no systematic association",
        x = "Forecast horizon",
        y = "Estimated beta coefficient",
        color = "Model specification",
        caption = "Note: Error bars denote HAC confidence intervals."
    ) +
    theme_minimal(base_size = 11) +
    theme(
        plot.title = element_text(face = "bold", size = 14, margin = margin(b = 10)),
        legend.position = "bottom",
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank()
    )
ggsave("results/figures/fig3_cg_coefficients.png", p3, width = 10, height = 6, dpi = 300)
cat("  ?Saved: fig3_cg_coefficients.png\n\n")
# ------------------------------------------------------------------------------
# 5. Figure 4: Overreaction Test (_h)
# ------------------------------------------------------------------------------
cat("Step 5: Creating _h plot...\n")
delta_beta <- delta_beta %>%
    mutate(
        ci_lower = delta_beta - 1.96 * se_delta,
        ci_upper = delta_beta + 1.96 * se_delta,
        significant = p_value < 0.05
    )
p4 <- ggplot(delta_beta, aes(x = horizon, y = delta_beta)) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "gray40", linewidth = 1) +
    geom_point(aes(color = significant), size = 5) +
    geom_errorbar(aes(ymin = ci_lower, ymax = ci_upper, color = significant), width = 0.2, linewidth = 1.2) +
    facet_wrap(~variable) +
    scale_color_manual(
        values = c("TRUE" = "#E41A1C", "FALSE" = "#377EB8"),
        labels = c("TRUE" = "Significant", "FALSE" = "Not significant")
    ) +
    labs(
        title = "Difference in revision diagnostic coefficients",
        subtitle = "Difference between Full and Small information sets",
        x = "Forecast horizon",
        y = "Estimated delta beta",
        color = "Significance"
    ) +
    theme_minimal(base_size = 11) +
    theme(
        plot.title = element_text(face = "bold", size = 14, margin = margin(b = 10)),
        legend.position = "bottom",
        panel.grid.minor = element_blank()
    )
ggsave("results/figures/fig4_delta_beta_overreaction.png", p4, width = 8, height = 6, dpi = 300)
cat("  ?Saved: fig4_delta_beta_overreaction.png\n\n")
# ------------------------------------------------------------------------------
# 6. Figure 5: Hyperparameter Evolution
# ------------------------------------------------------------------------------
cat("Step 6: Creating hyperparameter evolution plot...\n")
hyperparams_filtered <- hyperparams %>%
    filter(!is.na(lambda)) %>%
    mutate(
        origin_date = as.Date(gsub('"', "", as.character(origin_date)))
    )
p5 <- ggplot(hyperparams_filtered, aes(x = origin_date, y = lambda, color = model)) +
    geom_line(alpha = 0.4, linewidth = 0.5) +
    geom_smooth(method = "loess", se = TRUE, span = 0.2, linewidth = 1.2) +
    scale_color_brewer(palette = "Set1") +
    scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
    labs(
        title = "Evolution of hierarchical shrinkage tightness",
        subtitle = "Posterior mean of shrinkage tightness under the hierarchical prior",
        x = "Forecast origin date",
        y = "Shrinkage tightness (lambda)",
        color = "Model specification"
    ) +
    theme_minimal(base_size = 11) +
    theme(
        plot.title = element_text(face = "bold", size = 14, margin = margin(b = 10)),
        legend.position = "bottom",
        panel.grid.minor = element_blank()
    )
ggsave("results/figures/fig5_lambda_evolution.png", p5, width = 10, height = 6, dpi = 300)
cat("  ?Saved: fig5_lambda_evolution.png\n\n")
# ------------------------------------------------------------------------------
# Figure 6: Forecast vs Actual Time Series (All Horizons)
# ------------------------------------------------------------------------------
cat("Step 7: Creating forecast vs actual plots...\n")

aligned_data <- readRDS("results/forecasts/aligned_forecasts_actuals.rds")

# Helper function to create forecast vs actual plot
create_forecast_plot <- function(data, horizon, horizon_col_forecast, horizon_col_actual, y_label, x_axis = c("target", "origin")) {
    x_axis <- match.arg(x_axis)
    target_col <- paste0("target_date_h", horizon)

    forecast_ts <- data %>%
        mutate(origin_date = as.Date(origin_date)) %>%
        mutate(
            target_date = if (target_col %in% names(data)) {
                as.Date(.data[[target_col]])
            } else {
                as.Date(as.yearmon(origin_date) + horizon / 12, frac = 1)
            }
        ,
        plot_date = if (x_axis == "target") target_date else origin_date
        ) %>%
        filter(!is.na(!!sym(horizon_col_actual)))

    ggplot(forecast_ts, aes(x = plot_date)) +
        geom_line(aes(y = !!sym(horizon_col_actual), color = "Actual"), linewidth = 0.8) +
        geom_line(aes(y = !!sym(horizon_col_forecast), color = "BVAR Forecast"), 
                  linewidth = 0.8, alpha = 0.7) +
        scale_color_manual(values = c("Actual" = "black", "BVAR Forecast" = "#E41A1C")) +
        labs(
            title = sprintf("CPI Inflation: BVAR Forecast vs Realized (h=%d)", horizon),
            subtitle = if (x_axis == "target") "x-axis uses target date (t+h)" else "x-axis uses origin date (t)",
            x = if (x_axis == "target") "Target date (t+h)" else "Origin date (t)",
            y = y_label,
            color = ""
        ) +
        theme_minimal(base_size = 11) +
        theme(legend.position = "bottom")
}

# Alternative diagnostic plot: forecast is dated at origin t, realized is dated at target t+h.
# This SHOULD look horizontally shifted by h months; it is not meant for pointwise comparison,
# but helps visually confirm what "origin date" vs "target date" means in the pseudo-OOS setup.
create_forecast_plot_staggered <- function(data, horizon, horizon_col_forecast, horizon_col_actual, y_label) {
    target_col <- paste0("target_date_h", horizon)

    ts <- data %>%
        mutate(origin_date = as.Date(origin_date)) %>%
        mutate(
            target_date = if (target_col %in% names(data)) {
                as.Date(.data[[target_col]])
            } else {
                as.Date(as.yearmon(origin_date) + horizon / 12, frac = 1)
            }
        ) %>%
        filter(!is.na(!!sym(horizon_col_actual)))

    df_long <- bind_rows(
        ts %>%
            transmute(date = origin_date, value = !!sym(horizon_col_forecast), series = "Forecast (made at t)"),
        ts %>%
            transmute(date = target_date, value = !!sym(horizon_col_actual), series = "Realized (at t+h)")
    ) %>%
        mutate(series = factor(series, levels = c("Realized (at t+h)", "Forecast (made at t)")))

    ggplot(df_long, aes(x = date, y = value, color = series)) +
        geom_line(linewidth = 0.8) +
        scale_color_manual(values = c("Realized (at t+h)" = "black", "Forecast (made at t)" = "#E41A1C")) +
        labs(
            title = sprintf("Forecast Timing Diagnostic (h=%d)", horizon),
            subtitle = "Black series is dated at realization (t+h); red series is dated at forecast origin (t)",
            x = "Calendar date",
            y = y_label,
            color = ""
        ) +
        theme_minimal(base_size = 11) +
        theme(legend.position = "bottom")
}

# Generate plots for all horizons (default: CPI + Small; can override via options)
fig6_variable <- getOption("bayesian_de.fig6_variable", "CPI")
fig6_model <- getOption("bayesian_de.fig6_model", "Small")

fig6_prefix <- if (toupper(fig6_variable) == "INDPRO") "indpro" else "cpi"
fig6_key <- paste0(fig6_prefix, "_", tolower(fig6_model))
if (!(fig6_key %in% names(aligned_data))) {
    fig6_key <- "cpi_small"
}
fig6_df <- aligned_data[[fig6_key]]
cat(sprintf("  Fig6 uses variable=%s, model=%s (%s)\n", fig6_variable, fig6_model, fig6_key))

cat("  Fig6 alignment spot-check (first 5 rows):\n")
for (h in c(1, 3, 12)) {
    tcol <- paste0("target_date_h", h)
    if (tcol %in% names(fig6_df)) {
        tmp <- fig6_df %>%
            transmute(origin_date = as.Date(origin_date), target_date = as.Date(.data[[tcol]])) %>%
            head(5)
        cat(sprintf("    h=%d:\n", h))
        print(tmp, row.names = FALSE)
    }
}
cat("\n")

if (toupper(fig6_variable) == "INDPRO") {
    y_h1 <- "Annualized 1-month IP growth (%)"
    y_h3 <- "Annualized 3-month IP growth (%)"
    y_h12 <- "Annualized 12-month IP growth (%)"
} else {
    y_h1 <- "Annualized 1-month inflation (%)"
    y_h3 <- "Annualized 3-month inflation (%)"
    y_h12 <- "Year-over-year inflation (%)"
}

p6_h1 <- create_forecast_plot(fig6_df, 1, "h1_forecast", "h1_actual", y_h1, x_axis = "target")
p6_h3 <- create_forecast_plot(fig6_df, 3, "h3_forecast", "h3_actual", y_h3, x_axis = "target")
p6_h12 <- create_forecast_plot(fig6_df, 12, "h12_forecast", "h12_actual", y_h12, x_axis = "target")

p6_diag_h1 <- create_forecast_plot_staggered(fig6_df, 1, "h1_forecast", "h1_actual", y_h1)
p6_diag_h3 <- create_forecast_plot_staggered(fig6_df, 3, "h3_forecast", "h3_actual", y_h3)
p6_diag_h12 <- create_forecast_plot_staggered(fig6_df, 12, "h12_forecast", "h12_actual", y_h12)

ggsave("results/figures/fig6a_forecast_vs_actual_h1.png", p6_h1, width = 10, height = 5, dpi = 300)
ggsave("results/figures/fig6b_forecast_vs_actual_h3.png", p6_h3, width = 10, height = 5, dpi = 300)
ggsave("results/figures/fig6c_forecast_vs_actual_h12.png", p6_h12, width = 10, height = 5, dpi = 300)

cat("  ?Saved: fig6a_forecast_vs_actual_h1.png\n")
cat("  ?Saved: fig6b_forecast_vs_actual_h3.png\n")
cat("  ?Saved: fig6c_forecast_vs_actual_h12.png\n\n")

ggsave("results/figures/fig6d_timing_diagnostic_h1.png", p6_diag_h1, width = 10, height = 5, dpi = 300)
ggsave("results/figures/fig6e_timing_diagnostic_h3.png", p6_diag_h3, width = 10, height = 5, dpi = 300)
ggsave("results/figures/fig6f_timing_diagnostic_h12.png", p6_diag_h12, width = 10, height = 5, dpi = 300)

cat("  ?Saved: fig6d_timing_diagnostic_h1.png\n")
cat("  ?Saved: fig6e_timing_diagnostic_h3.png\n")
cat("  ?Saved: fig6f_timing_diagnostic_h12.png\n\n")

# ------------------------------------------------------------------------------
# Figure 7: CG Regression Scatter Plots (All Horizons)
# ------------------------------------------------------------------------------
cat("Step 8: Creating CG regression scatter plots...\n")

cg_data <- readRDS("results/forecasts/cg_data_cpi_small.rds")

# Helper function to create CG scatter plot
create_cg_scatter <- function(data, horizon_name, error_col, revision_col, beta_val) {
    ggplot(data, aes(x = !!sym(revision_col), y = !!sym(error_col))) +
        geom_point(alpha = 0.5, color = "#377EB8", size = 2) +
        geom_smooth(method = "lm", color = "#E41A1C", se = TRUE, linewidth = 1.2) +
        geom_hline(yintercept = 0, linetype = "dashed", alpha = 0.5) +
        geom_vline(xintercept = 0, linetype = "dashed", alpha = 0.5) +
        annotate("text", x = Inf, y = Inf, 
                 label = sprintf("beta = %.3f", beta_val),
                 hjust = 1.1, vjust = 1.5, size = 5, fontface = "bold") +
        labs(
            title = sprintf("Revision diagnostic scatter (CPI, %s)", horizon_name),
            subtitle = "Forecast Error vs. Forecast Revision",
            x = "Forecast revision",
            y = "Forecast error",
            caption = "Note: Fitted line from the revision diagnostic regression."
        ) +
        theme_minimal(base_size = 11) +
        theme(plot.caption = element_text(hjust = 0, face = "italic"))
}

# Load CG results to get beta values
cg_results <- read.csv("results/tables/cg_regression_results.csv")
beta_h1 <- cg_results %>% filter(model == "Small", variable == "CPI", horizon == "h=1") %>% pull(beta)
beta_h3 <- cg_results %>% filter(model == "Small", variable == "CPI", horizon == "h=3") %>% pull(beta)
beta_h12 <- cg_results %>% filter(model == "Small", variable == "CPI", horizon == "h=12") %>% pull(beta)

# Generate plots for all horizons
p7_h1 <- create_cg_scatter(cg_data, "h=1", "h1_error", "h1_revision_growth", beta_h1)
p7_h3 <- create_cg_scatter(cg_data, "h=3", "h3_error", "h3_revision_growth", beta_h3)
p7_h12 <- create_cg_scatter(cg_data, "h=12", "h12_error", "h12_revision_growth", beta_h12)

ggsave("results/figures/fig7a_cg_scatter_h1.png", p7_h1, width = 8, height = 6, dpi = 300)
ggsave("results/figures/fig7b_cg_scatter_h3.png", p7_h3, width = 8, height = 6, dpi = 300)
ggsave("results/figures/fig7c_cg_scatter_h12.png", p7_h12, width = 8, height = 6, dpi = 300)

cat("  ?Saved: fig7a_cg_scatter_h1.png\n")
cat("  ?Saved: fig7b_cg_scatter_h3.png\n")
cat("  ?Saved: fig7c_cg_scatter_h12.png\n\n")


# ------------------------------------------------------------------------------
# 7. Summary
# ------------------------------------------------------------------------------
cat("\n")
cat("  VISUALIZATION COMPLETE\n")
cat("\n\n")
cat("Generated figures:\n")
cat("  1. fig1_rmsfe_comparison.png - Forecast accuracy comparison\n")
cat("  2. fig2_relative_rmsfe.png - Performance vs. RW benchmark\n")
cat("  3. fig3_cg_coefficients.png - CG regression coefficients (all models)\n")
cat("  4. fig4_delta_beta_overreaction.png - Overreaction test (_h)\n")
cat("  5. fig5_lambda_evolution.png - Hyperparameter dynamics\n")
cat("  6a-c. Forecast vs Actual (h=1, 3, 12):\n")
cat("     - fig6a_forecast_vs_actual_h1.png\n")
cat("     - fig6b_forecast_vs_actual_h3.png\n")
cat("     - fig6c_forecast_vs_actual_h12.png\n")
cat("  6d-f. Timing diagnostic:\n")
cat("     - fig6d_timing_diagnostic_h1.png\n")
cat("     - fig6e_timing_diagnostic_h3.png\n")
cat("     - fig6f_timing_diagnostic_h12.png\n")
cat("  7a-c. CG Regression Scatter Plots (h=1, 3, 12):\n")
cat("     - fig7a_cg_scatter_h1.png\n")
cat("     - fig7b_cg_scatter_h3.png\n")
cat("     - fig7c_cg_scatter_h12.png\n\n")
cat("Total: 14 publication-quality figures\n")
cat("All figures saved to: results/figures/\n\n")


