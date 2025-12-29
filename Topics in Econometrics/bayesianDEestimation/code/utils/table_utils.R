# ==============================================================================
# table_utils.R
# Purpose: Academic-quality LaTeX table formatting (economics journal standard)
# Author: Jingle Fu
# Date: 2025-12-26
# ==============================================================================

#' Format data frame as LaTeX three-line table (booktabs style)
#'
#' Creates publication-quality tables without kableExtra dependency.
#' Follows economics journal conventions (AER, Econometrica, etc.)
#'
#' @param df Data frame to format
#' @param caption Table caption
#' @param label LaTeX label for cross-referencing
#' @param notes Character vector of table notes (bottom footnotes)
#' @param digits Number of decimal places (default: 3)
#' @param align Column alignment string (e.g., "lrccc")
#' @param size Font size command (e.g., "\\small", "\\footnotesize")
#' @param position LaTeX float position (default: "htbp")
#' @return Character vector of LaTeX code
format_threeline_table <- function(df,
                                   caption = "",
                                   label = "",
                                   notes = NULL,
                                   digits = 3,
                                   align = NULL,
                                   size = "\\small",
                                   position = "htbp") {
    # Auto-generate alignment if not provided
    if (is.null(align)) {
        # First column left-aligned, rest center-aligned
        align <- paste0("l", paste(rep("c", ncol(df) - 1), collapse = ""))
    }

    # Start table
    latex_code <- c(
        "\\begin{table}[htbp]",
        "\\centering",
        size,
        sprintf("\\caption{%s}", caption),
        sprintf("\\label{%s}", label),
        sprintf("\\begin{tabular}{@{}%s@{}}", align),
        "\\toprule"
    )

    # Column headers
    headers <- colnames(df)
    header_line <- paste(headers, collapse = " & ")
    latex_code <- c(latex_code, paste0(header_line, " \\\\"))
    latex_code <- c(latex_code, "\\midrule")

    # Data rows
    for (i in 1:nrow(df)) {
        row <- df[i, ]
        # Format each cell
        formatted_row <- sapply(1:ncol(row), function(j) {
            val <- row[[j]]
            if (is.numeric(val)) {
                # Format numbers with specified digits
                if (is.na(val)) {
                    return("--")
                } else {
                    return(sprintf(paste0("%.", digits, "f"), val))
                }
            } else {
                # Character/factor: return as-is
                return(as.character(val))
            }
        })
        row_line <- paste(formatted_row, collapse = " & ")
        latex_code <- c(latex_code, paste0(row_line, " \\\\"))
    }

    # End table
    latex_code <- c(latex_code, "\\bottomrule")
    latex_code <- c(latex_code, "\\end{tabular}")

    # Add table notes if provided
    if (!is.null(notes) && length(notes) > 0) {
        # Calculate table width (rough approximation)
        latex_code <- c(latex_code, "\\vspace{0.5em}")
        latex_code <- c(latex_code, "\\begin{minipage}{\\textwidth}")
        latex_code <- c(latex_code, "\\footnotesize")
        latex_code <- c(latex_code, "\\textit{Notes:}")

        for (note in notes) {
            latex_code <- c(latex_code, paste0(note, "\\\\"))
        }

        latex_code <- c(latex_code, "\\end{minipage}")
    }

    latex_code <- c(latex_code, "\\end{table}")

    return(latex_code)
}


#' Format regression table with standard errors
#'
#' Specialized formatter for regression results (CG regressions, etc.)
#'
#' @param coef_df Data frame with columns: term, estimate, std.error, statistic, p.value
#' @param caption Table caption
#' @param label LaTeX label
#' @param notes Character vector of notes
#' @param show_stars Include significance stars (default: TRUE)
#' @return Character vector of LaTeX code
format_regression_table <- function(coef_df,
                                    caption = "",
                                    label = "",
                                    notes = NULL,
                                    show_stars = TRUE) {
    # Format coefficient and SE
    formatted_df <- data.frame(
        Variable = coef_df$term,
        Coefficient = sprintf("%.4f", coef_df$estimate),
        `Std. Error` = sprintf("(%.4f)", coef_df$std.error),
        check.names = FALSE
    )

    # Add significance stars if requested
    if (show_stars) {
        stars <- sapply(coef_df$p.value, function(p) {
            if (is.na(p)) {
                return("")
            }
            if (p < 0.01) {
                return("***")
            }
            if (p < 0.05) {
                return("**")
            }
            if (p < 0.1) {
                return("*")
            }
            return("")
        })
        formatted_df$Coefficient <- paste0(formatted_df$Coefficient, stars)
    }

    # Default notes if not provided
    if (is.null(notes)) {
        notes <- c(
            "Standard errors in parentheses.",
            if (show_stars) "*** p<0.01, ** p<0.05, * p<0.1" else NULL
        )
    }

    # Use three-line table formatter
    format_threeline_table(
        df = formatted_df,
        caption = caption,
        label = label,
        notes = notes,
        digits = 4,
        align = "lccc"
    )
}


#' Save LaTeX table to file
#'
#' @param latex_code Character vector of LaTeX code
#' @param filename Output file path
#' @param standalone If TRUE, wraps in complete LaTeX document for compilation
save_latex_table <- function(latex_code, filename, standalone = FALSE) {
    if (standalone) {
        # Wrap in complete document
        full_doc <- c(
            "\\documentclass{article}",
            "\\usepackage{booktabs}",
            "\\usepackage{array}",
            "\\begin{document}",
            "",
            latex_code,
            "",
            "\\end{document}"
        )
        writeLines(full_doc, filename)
    } else {
        # Just the table (for \\input in main document)
        writeLines(latex_code, filename)
    }

    cat(sprintf("LaTeX table saved to: %s\n", filename))
}


#' Format RMSFE comparison table (economics journal style)
#'
#' Specialized formatter for forecast accuracy tables
#'
#' @param rmsfe_df Data frame with RMSFE results
#' @param relative Logical, if TRUE formats as relative RMSFE
#' @return Character vector of LaTeX code
format_rmsfe_table <- function(rmsfe_df, relative = FALSE) {
    if (relative) {
        caption <- "Relative Root Mean Squared Forecast Errors"
        label <- "tab:relative_rmsfe"
        notes <- c(
            "Relative RMSFE is computed as $\\text{RMSFE}_{\\text{Model}} / \\text{RMSFE}_{\\text{RW}}$, where RW denotes a random walk benchmark.",
            "Values less than 1 indicate the model outperforms the random walk.",
            "Sample period: 2001M1--2019M12 (230 forecast origins).",
            "Forecast horizons: $h = \\{1, 3, 12\\}$ months ahead."
        )
        digits <- 3
    } else {
        caption <- "Root Mean Squared Forecast Errors"
        label <- "tab:rmsfe"
        notes <- c(
            "RMSFE (in percentage points for inflation and growth rates).",
            "Sample period: 2001M1--2019M12 (230 forecast origins).",
            "Forecast horizons: $h = \\{1, 3, 12\\}$ months ahead.",
            "Models: Small (INDPRO, CPI, UNRATE, FEDFUNDS), Medium (+ GS10, SP500), Full (+ UMCSENT)."
        )
        digits <- 3
    }

    format_threeline_table(
        df = rmsfe_df,
        caption = caption,
        label = label,
        notes = notes,
        digits = digits
    )
}


#' Format CG regression table
#'
#' @param cg_df Data frame with CG regression results
#' @return Character vector of LaTeX code
format_cg_table <- function(cg_df) {
    caption <- "Coibion--Gorodnichenko Regression Results"
    label <- "tab:cg_regression"

    notes <- c(
        "OLS regression of forecast errors on forecast revisions: $(y_{t+h} - \\hat{y}_{t+h|t}) = \\alpha_h + \\beta_h (\\hat{y}_{t+h|t} - \\hat{y}_{t+h|t-1}) + \\varepsilon_{t+h}$.",
        "Standard errors are Newey--West HAC-robust with lag truncation parameter equal to the forecast horizon.",
        "Under rational expectations, $\\beta_h = 0$. Positive values indicate under-reaction (sticky information),",
        "while negative values suggest over-reaction consistent with diagnostic expectations.",
        "Sample: 2001M1--2019M12. Variables: CPI (annualized inflation), INDPRO (industrial production growth)."
    )

    format_threeline_table(
        df = cg_df,
        caption = caption,
        label = label,
        notes = notes,
        digits = 4
    )
}


#' Format Diebold-Mariano test results
#'
#' @param dm_df Data frame with DM test results
#' @return Character vector of LaTeX code
format_dm_table <- function(dm_df) {
    caption <- "Diebold--Mariano Test Results"
    label <- "tab:dm_test"

    notes <- c(
        "Diebold--Mariano test for equal predictive accuracy against random walk benchmark.",
        "Null hypothesis: Equal mean squared forecast error.",
        "Test statistic computed using Newey--West HAC variance estimator.",
        "Negative $t$-statistics indicate the model has lower MSFE than the benchmark.",
        "*** p<0.01, ** p<0.05, * p<0.1"
    )

    format_threeline_table(
        df = dm_df,
        caption = caption,
        label = label,
        notes = notes,
        digits = 3
    )
}
