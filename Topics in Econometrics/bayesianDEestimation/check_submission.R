#!/usr/bin/env Rscript

options(warn = 1)

assert <- function(cond, msg) {
    if (!isTRUE(cond)) stop(msg, call. = FALSE)
}

run <- function(cmd, args = character(), must_succeed = TRUE) {
    status <- system2(cmd, args = args)
    if (must_succeed) {
        assert(identical(status, 0L), sprintf("Command failed (%s): %s", cmd, paste(args, collapse = " ")))
    }
    invisible(status)
}

cat("== Submission self-check ==\n")

submission_tex <- "ForecastingHorseRace_submission.tex"
submission_pdf <- "ForecastingHorseRace_submission.pdf"
submission_aux <- "ForecastingHorseRace_submission.aux"
submission_log <- "ForecastingHorseRace_submission.log"

assert(file.exists(submission_tex), sprintf("Missing `%s`.", submission_tex))

cat("* Compiling submission PDF...\n")
run("latexmk", c(
    "-pdf",
    "-interaction=nonstopmode",
    "-halt-on-error",
    "-file-line-error",
    submission_tex
))

assert(file.exists(submission_pdf), sprintf("Missing `%s` after compilation.", submission_pdf))
assert(file.exists(submission_aux), sprintf("Missing `%s` after compilation.", submission_aux))
assert(file.exists(submission_log), sprintf("Missing `%s` after compilation.", submission_log))

cat("* Checking LaTeX log for unresolved refs/cites...\n")
log_lines <- readLines(submission_log, warn = FALSE)
has_undefined_refs <- any(grepl("There were undefined references", log_lines, fixed = TRUE)) ||
    any(grepl("LaTeX Warning: Reference", log_lines, fixed = TRUE) & grepl("undefined", log_lines, ignore.case = TRUE))
has_undefined_cites <- any(grepl("There were undefined citations", log_lines, fixed = TRUE)) ||
    any(grepl("LaTeX Warning: Citation", log_lines, fixed = TRUE) & grepl("undefined", log_lines, ignore.case = TRUE))
assert(!has_undefined_refs, "Unresolved LaTeX references detected (see .log).")
assert(!has_undefined_cites, "Unresolved LaTeX citations detected (see .log).")

cat("* Checking PDF text for '??'...\n")
pdf_text <- suppressWarnings(system2("pdftotext", c("-layout", submission_pdf, "-"), stdout = TRUE, stderr = TRUE))
assert(!any(grepl("\\?\\?", pdf_text)), "Found '??' in PDF text (likely unresolved references).")

cat("* Checking main-text page count via LastMainTextPage label...\n")
aux_lines <- readLines(submission_aux, warn = FALSE)
last_label <- aux_lines[grepl("\\\\newlabel\\{LastMainTextPage\\}", aux_lines)]
assert(length(last_label) == 1, "Expected exactly one \\newlabel{LastMainTextPage} in .aux.")
m <- regexec("\\\\newlabel\\{LastMainTextPage\\}\\{\\{[^}]*\\}\\{([0-9]+)\\}", last_label)
g <- regmatches(last_label, m)[[1]]
assert(length(g) >= 2, "Could not parse page number for LastMainTextPage from .aux.")
last_page <- as.integer(g[2])
assert(!is.na(last_page), "Parsed LastMainTextPage is NA.")
assert(last_page >= 5 && last_page <= 10, sprintf("Main-text page count %d is outside guideline range [5, 10].", last_page))

cat("* Checking formatting knobs in TeX source...\n")
tex_src <- paste(readLines("ForecastingHorseRace.tex", warn = FALSE), collapse = "\n")
assert(grepl("\\\\documentclass\\[[^]]*12pt", tex_src), "Missing 12pt documentclass option.")
assert(grepl("\\\\usepackage\\[margin=3cm\\]\\{geometry\\}", tex_src), "Missing geometry margin=3cm.")
assert(grepl("\\\\setstretch\\{1\\.25\\}", tex_src), "Missing 1.25 line spacing (setstretch{1.25}).")
assert(grepl("\\\\begin\\{titlepage\\}", tex_src), "Missing title page environment.")
assert(grepl("\\\\pagenumbering\\{roman\\}", tex_src), "Missing roman page numbering before introduction.")
assert(grepl("\\\\pagenumbering\\{arabic\\}", tex_src), "Missing arabic page numbering for main text.")

cat("* Checking referenced result-table files exist...\n")
required_inputs <- c(
    "results/latex_tables/tab_rmsfe.tex",
    "results/latex_tables/tab_cg_regression.tex",
    "results/latex_tables/clark_west_tests.tex"
)
missing_inputs <- required_inputs[!file.exists(required_inputs)]
assert(length(missing_inputs) == 0, sprintf("Missing required LaTeX inputs: %s", paste(missing_inputs, collapse = ", ")))

cat("* Basic contradiction scan (submission PDF)...\n")
pdf_lower <- tolower(paste(pdf_text, collapse = " "))
assert(!(
    grepl("sentiment", pdf_lower) &&
        grepl("no marginal", pdf_lower) &&
        grepl("incremental predictive value", pdf_lower)
), "Potential contradiction detected in submission PDF text (sentiment: 'no marginal' vs 'incremental predictive value').")

cat("\nOK: submission build passes checks.\n")
