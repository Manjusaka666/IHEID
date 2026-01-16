# --- 鐜鍑嗗 ---
source("code/utils/table_utils.R")
library(tidyverse)

# 瀹氫箟杈撳叆鍜岃緭鍑鸿矾寰?
input_dir <- "results/tables"
output_dir <- "results/latex_tables" # 寤鸿鏂板缓涓€涓瓙鐩綍瀛樻斁
dir.create(output_dir, showWarnings = FALSE)

# --- 1. 杞崲 RMSFE 琛ㄦ牸 ---
rmsfe_df <- read.csv(file.path(input_dir, "rmsfe_results.csv"))
latex_rmsfe <- format_rmsfe_table(rmsfe_df, relative = FALSE)
save_latex_table(latex_rmsfe, file.path(output_dir, "tab_rmsfe.tex"))

# --- 2. 杞崲 CG 鍥炲綊缁撴灉琛ㄦ牸 ---
cg_df <- read.csv(file.path(input_dir, "cg_regression_results.csv"))
latex_cg <- format_cg_table(cg_df)
save_latex_table(latex_cg, file.path(output_dir, "tab_cg_regression.tex"))

# --- 3. 杞崲 Diebold-Mariano 娴嬭瘯缁撴灉 ---
dm_df <- read.csv(file.path(input_dir, "dm_test_results.csv"))
latex_dm <- format_dm_table(dm_df)
save_latex_table(latex_dm, file.path(output_dir, "tab_dm_test.tex"))

# --- 4. Clark-West (2007) nested-model test table ---
cw_df <- read.csv(file.path(input_dir, "clark_west_tests.csv"))
latex_cw <- format_clark_west_table(cw_df)
save_latex_table(latex_cw, file.path(output_dir, "clark_west_tests.tex"))

# --- 5. 鎵归噺澶勭悊鍏朵粬閫氱敤琛ㄦ牸 (濡傜浉瀵?RMSFE) ---
other_tables <- c("relative_rmsfe.csv", "delta_beta_overreaction_test.csv")
for (tbl in other_tables) {
    df <- read.csv(file.path(input_dir, tbl))
    # 浣跨敤閫氱敤鏍煎紡鍖栧嚱鏁?
    latex_code <- format_threeline_table(
        df,
        caption = paste("Results from", tbl),
        label = paste0("tab:", gsub(".csv", "", tbl))
    )
    save_latex_table(latex_code, file.path(output_dir, gsub(".csv", ".tex", tbl)))
}
