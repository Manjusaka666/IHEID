# ==============================================================================
# 10_robustness_visualization.R
# Purpose: Visualize robustness check results across scenarios
# Author: Jingle Fu
# Date: 2025-12-28
# ==============================================================================

cat("\n=== Robustness Visualization ===\n\n")

library(tidyverse)

robustness_root <- "results/robustness"
scenario_dirs <- list.dirs(robustness_root, recursive = FALSE, full.names = TRUE)

if (length(scenario_dirs) == 0) {
    cat("No robustness results found. Run 09_robustness_checks.R first.\n\n")
    quit(save = "no")
}

read_rel_table <- function(file_name) {
    tables <- lapply(scenario_dirs, function(dir) {
        file_path <- file.path(dir, "tables", file_name)
        if (!file.exists(file_path)) {
            return(NULL)
        }
        df <- read.csv(file_path)
        df$scenario <- basename(dir)
        df
    })
    tables <- tables[!sapply(tables, is.null)]
    if (length(tables) == 0) {
        return(NULL)
    }
    bind_rows(tables)
}

plot_relative_rmsfe <- function(df, title, out_file) {
    df_long <- df %>%
        pivot_longer(cols = starts_with("rel_"), names_to = "horizon", values_to = "rel_rmsfe") %>%
        mutate(
            horizon = factor(horizon, levels = c("rel_h1", "rel_h3", "rel_h12"), labels = c("h=1", "h=3", "h=12"))
        )

    p <- ggplot(df_long, aes(x = horizon, y = rel_rmsfe, color = scenario, group = scenario)) +
        geom_line(linewidth = 1.1) +
        geom_point(size = 2.8) +
        geom_hline(yintercept = 1, linetype = "dashed", color = "gray40", linewidth = 0.8) +
        facet_wrap(~variable) +
        labs(
            title = title,
            subtitle = "Values < 1 indicate improvement relative to the benchmark",
            x = "Forecast Horizon",
            y = "Relative RMSFE",
            color = "Scenario"
        ) +
        theme_minimal(base_size = 11) +
        theme(
            plot.title = element_text(face = "bold", size = 14, margin = margin(b = 8)),
            legend.position = "bottom"
        )

    ggsave(out_file, p, width = 10, height = 6, dpi = 300)
    cat(sprintf("  Saved: %s\n", out_file))
}

rel_rw <- read_rel_table("relative_rmsfe_vs_rw.csv")
if (!is.null(rel_rw)) {
    plot_relative_rmsfe(
        rel_rw,
        "Robustness: Relative RMSFE vs Random Walk",
        "results/figures/fig_robustness_relative_rmsfe_rw.png"
    )
} else {
    cat("No relative_rmsfe_vs_rw.csv found under robustness results.\n")
}

rel_ar1 <- read_rel_table("relative_rmsfe_vs_ar1.csv")
if (!is.null(rel_ar1)) {
    plot_relative_rmsfe(
        rel_ar1,
        "Robustness: Relative RMSFE vs AR(1)",
        "results/figures/fig_robustness_relative_rmsfe_ar1.png"
    )
} else {
    cat("No relative_rmsfe_vs_ar1.csv found under robustness results.\n")
}

cat("\nRobustness visualization complete.\n\n")
