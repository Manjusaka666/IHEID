# Internal Mapping: Manuscript Tables/Figures to Source Files

This document provides complete traceability from every table and figure in the manuscript to its source file in the `results/` directory.

## Main Text Tables

- **Table 1** (`\ref{tab:rmsfe}`): Root mean squared forecast errors  
  - LaTeX file: `results/latex_tables/tab_rmsfe.tex`  
  - Data source: `results/tables/rmsfe_results.csv`

- **Table 2** (`\ref{tab:cg_regression}`): Coibion-Gorodnichenko revision diagnostic  
  - LaTeX file: `results/latex_tables/tab_cg_regression.tex`  
  - Data source: `results/tables/cg_regression_results.csv`

## Main Text Figures

- **Figure 1** (`\ref{fig:relrmsfe}`): Relative forecast accuracy versus parsimonious benchmark  
  - File: `results/figures/fig2_relative_rmsfe.png`  
  - Data source: `results/tables/relative_rmsfe_vs_rw.csv`

- **Figure 2** (`\ref{fig:cg_coeff}`): Revision diagnostic coefficients across information sets  
  - File: `results/figures/fig3_cg_coefficients.png`  
  - Data source: `results/tables/cg_regression_results.csv`

- **Figure 3** (` \ref{fig:lambda}`): Evolution of learned shrinkage tightness  
  - File: `results/figures/fig5_lambda_evolution.png`  
  - Data source: `results/forecasts/hyperparameters_evolution.csv`

## Appendix Tables

- **Table A1** (`\ref{tab:clark_west}`): Clark-West nested-model tests  
  - LaTeX file: `results/latex_tables/clark_west_tests.tex`  
  - Data source: `results/tables/clark_west_tests.csv`

## Appendix Figures

- **Figure A1** (`\ref{fig:rolling_rw}`): Rolling relative RMSFE versus no-change benchmark  
  - File: `results/figures/fig_rolling_relative_rmsfe_rw.png`  
  - Data source: `results/tables/rolling_relative_rmsfe_vs_rw.csv`

- **Figure A2** (`\ref{fig:error_decomp}`): Forecast error decomposition (Theil MSE shares)  
  - File: `results/figures/fig_error_decomposition.png`  
  - Data source: `results/tables/error_decomposition.csv`

- **Figure A3** (`\ref{fig:delta_beta}`): Change in revision diagnostic coefficients  
  - File: `results/figures/fig4_delta_beta_overreaction.png`  
  - Data source: `results/tables/delta_beta_overreaction_test.csv`

- **Figure A4** (`\ref{fig:rolling_ar1}`): Rolling relative RMSFE versus AR(1) benchmark  
  - File: `results/figures/fig_rolling_relative_rmsfe_ar1.png`  
  - Data source: `results/tables/rolling_relative_rmsfe_vs_ar1.csv`

- **Figure A5** (`\ref{fig:robustness_rw}`): Robustness check, relative RMSFE versus no-change  
  - File: `results/figures/fig_robustness_relative_rmsfe_rw.png`

- **Figure A6** (`\ref{fig:robustness_ar1}`): Robustness check, relative RMSFE versus AR(1)  
  - File: `results/figures/fig_robustness_relative_rmsfe_ar1.png`

- **Figures A7-A9** (`\ref{fig:cpi_forecast_paths}`): CPI inflation forecast vs. realized (multiple horizons)  
  - Files: `results/figures/fig6a_forecast_vs_actual_h1.png`, `fig6b_forecast_vs_actual_h3.png`, `fig6c_forecast_vs_actual_h12.png`

- **Figures A10-A12** (`\ref{fig:timing_diag}`): Forecast timing diagnostic (multiple horizons)  
  - Files: `results/figures/fig6d_timing_diagnostic_h1.png`, `fig6e_timing_diagnostic_h3.png`, `fig6f_timing_diagnostic_h12.png`

- **Figures A13-A15** (`\ref{fig:cg_scatter}`): Revision diagnostic scatter plots (multiple horizons)  
  - Files: `results/figures/fig7a_cg_scatter_h1.png`, `fig7b_cg_scatter_h3.png`, `fig7c_cg_scatter_h12.png`

## Hyperparameter Data

- Lambda evolution across models and time:  
  - File: `results/forecasts/hyperparameters_evolution.csv`  
  - Contains posterior means for λ (tightness), α (lag decay), soc, sur at each recursive forecast origin

## Key Notes

1. **Hyperparameter calibration**: Code sets λ mode = 0.05 and α mode = 3.0 (see `code/04_bvar_estimation.R` lines 25, 30), but posterior means adapt data-driven via hierarchical selection
2. **All numerical claims** in the manuscript must trace to these files—no "orally stated numbers" allowed
3. **LaTeX table files** (.tex in `results/latex_tables/`) are auto-generated from corresponding CSV files in `results/tables/`
4. **Evaluation is pseudo out-of-sample**: Uses revised data, not real-time vintages
