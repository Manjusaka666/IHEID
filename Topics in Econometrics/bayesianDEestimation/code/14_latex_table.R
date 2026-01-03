# --- 环境准备 ---
source("code/utils/table_utils.R")
library(tidyverse)

# 定义输入和输出路径
input_dir <- "results/tables"
output_dir <- "results/latex_tables" # 建议新建一个子目录存放
dir.create(output_dir, showWarnings = FALSE)

# --- 1. 转换 RMSFE 表格 ---
rmsfe_df <- read.csv(file.path(input_dir, "rmsfe_results.csv"))
latex_rmsfe <- format_rmsfe_table(rmsfe_df, relative = FALSE)
save_latex_table(latex_rmsfe, file.path(output_dir, "tab_rmsfe.tex"))

# --- 2. 转换 CG 回归结果表格 ---
cg_df <- read.csv(file.path(input_dir, "cg_regression_results.csv"))
latex_cg <- format_cg_table(cg_df)
save_latex_table(latex_cg, file.path(output_dir, "tab_cg_regression.tex"))

# --- 3. 转换 Diebold-Mariano 测试结果 ---
dm_df <- read.csv(file.path(input_dir, "dm_test_results.csv"))
latex_dm <- format_dm_table(dm_df)
save_latex_table(latex_dm, file.path(output_dir, "tab_dm_test.tex"))

# --- 4. 批量处理其他通用表格 (如相对 RMSFE) ---
other_tables <- c("relative_rmsfe.csv", "delta_beta_overreaction_test.csv")
for (tbl in other_tables) {
    df <- read.csv(file.path(input_dir, tbl))
    # 使用通用格式化函数
    latex_code <- format_threeline_table(
        df,
        caption = paste("Results from", tbl),
        label = paste0("tab:", gsub(".csv", "", tbl))
    )
    save_latex_table(latex_code, file.path(output_dir, gsub(".csv", ".tex", tbl)))
}
