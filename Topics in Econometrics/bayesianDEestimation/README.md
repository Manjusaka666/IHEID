# Bayesian DE Estimation Project - README

## Project Overview

This project implements a hierarchical Bayesian VAR (BVAR) forecasting study to investigate:
1. Whether expanding the information set with financial prices and consumer sentiment improves forecast accuracy
2. Whether sentiment affects forecast behavior in a manner consistent with diagnostic expectations (Coibion-Gorodnichenko test)

**Research Period:** 1985M1-2019M12 (monthly US macroeconomic data)  
**Evaluation Period:** 2001M1-2019M12 (~230 forecast origins)

## Architecture

**R-Julia Hybrid System:**
- R: BVAR estimation (BVAR package), parallel computing, econometric analysis
- Julia: High-performance data transformations (5-10× speedup)
- Integration: JuliaCall package

**Performance Optimizations:**
- 26-thread parallelization across forecast origins
- Checkpoint system for fault tolerance
- Type-stable Julia functions with SIMD vectorization
- Expected runtime: 35-60 minutes (vs 3-6 hours sequential)

## Directory Structure

```
bayesianDEestimation/
├── code/
│   ├── 01_setup_environment.R          # R-Julia initialization
│   ├── 02_data_acquisition.R           # FRED data download
│   ├── 03_data_transformation.R        # Log/level transforms + growth rates
│   ├── 04_bvar_estimation.R            # Hierarchical BVAR setup
│   ├── 05_recursive_forecasting.R      # Parallel pseudo-OOS forecasting
│   ├── 06_forecast_evaluation.R        # RMSFE, DM tests
│   ├── 07_cg_regression.R              # Behavioral bias analysis
│   └── 08_visualization.R              # (To be implemented)
├── julia/
│   ├── Project.toml
│   └── transformation_functions.jl     # Type-stable transformations
├── data/
│   ├── raw/                            # Downloaded FRED data
│   └── processed/                      # Estimation & evaluation data
├── results/
│   ├── forecasts/                      # Model forecasts & checkpoints
│   ├── tables/                         # LaTeX-ready tables
│   ├── figures/                        # Publication-quality figures
│   └── diagnostics/                    # Test outputs
├── main_analysis.R                      # Master orchestration script
├── bayesian_de_project.Rproj           # RStudio project
└── .Rprofile                           # Auto-initialization
```

## Prerequisites

### Software Requirements

1. **R (>= 4.0.0)**
   - Install from: https://cran.r-project.org/

2. **Julia (>= 1.9.0)**
   - Install from: https://julialang.org/downloads/
   - Add Julia to PATH or set `JULIA_HOME` environment variable

3. **RStudio (recommended)**
   - Install from: https://posit.co/download/rstudio-desktop/

### R Packages

Run the following in R console:
```r
install.packages(c(
  "BVAR", "tidyverse", "fredr", "xts", "zoo",
  "sandwich", "lmtest", "xtable", "kableExtra",
  "parallel", "data.table", "JuliaCall"
))
```

### Julia Packages

In Julia REPL:
```julia
using Pkg
Pkg.add("DataFrames")
Pkg.add("CSV")
Pkg.add("BenchmarkTools")
```

### FRED API Key

1. Register for free at: https://fred.stlouisfed.org/docs/api/api_key.html
2. Set environment variable:
   - Windows: `setx FRED_API_KEY "your_key_here"`
   - Linux/Mac: Add `export FRED_API_KEY="your_key_here"` to `~/.bashrc` or `~/.zshrc`

## Getting Started

### Option 1: Command Line Execution (Recommended)

Open terminal in project directory and run:

```bash
# On Windows (Command Prompt)
Rscript main_analysis.R

# On Windows (PowerShell)
Rscript.exe main_analysis.R

# On Linux/Mac
Rscript main_analysis.R
```

### Option 2: RStudio

1. Open `bayesian_de_project.Rproj` in RStudio
2. Open `main_analysis.R`
3. Click "Source" button

### Option 3: Step-by-Step Execution

In R console:
```r
# Set working directory
setwd("e:/IHEID Economics/IHEID/Topics in Econometrics/bayesianDEestimation")

# Run phases individually
source("code/01_setup_environment.R")
source("code/02_data_acquisition.R")
source("code/03_data_transformation.R")
source("code/04_bvar_estimation.R")
source("code/05_recursive_forecasting.R")  # ⚠ 35-60 minutes
source("code/06_forecast_evaluation.R")
source("code/07_cg_regression.R")
```

## Phase-by-Phase Guide

### Phase 1: Environment Setup (~2 minutes)

```bash
Rscript code/01_setup_environment.R
```

**What it does:**
- Installs missing R packages
- Initializes Julia via JuliaCall
- Configures 26-thread parallel computing
- Creates directory structure
- Loads Julia transformation functions

**Expected output:** Session info saved to `results/session_info.txt`

### Phase 2: Data Acquisition (~5 minutes)

**⚠ Requires FRED API key**

```bash
Rscript code/02_data_acquisition.R
```

**What it does:**
- Downloads 7 series from FRED (1985M1-2019M12)
- Handles missing values
- Creates three nested datasets (Small, Medium, Full)

**Expected output:** 
- `data/raw/data_small_raw.rds`
- `data/raw/data_medium_raw.rds`
- `data/raw/data_full_raw.rds`

### Phase 3: Data Transformation (~1 minute)

```bash
Rscript code/03_data_transformation.R
```

**What it does:**
- Applies log transformations (INDPRO, CPIAUCSL, SP500)
- Keeps rates in levels (UNRATE, FEDFUNDS, GS10, UMCSENT)
- Uses Julia to compute evaluation transforms (growth rates)

**Expected output:**
- `data/processed/data_*_estimation.rds` (for BVAR input)
- `data/processed/eval_transforms_*.rds` (for forecast evaluation)

### Phase 4: BVAR Test Estimation (~3 minutes)

```bash
Rscript code/04_bvar_estimation.R
```

**What it does:**
- Configures hierarchical Minnesota prior
- Runs test estimation on full sample
- Verifies setup before recursive forecasting

**Expected output:**
- `results/diagnostics/test_bvar_fit.rds`
- `results/diagnostics/test_hyperparameters.csv`

### Phase 5: Recursive Forecasting (⚠ 35-60 minutes)

```bash
Rscript code/05_recursive_forecasting.R
```

**What it does:**
- Estimates BVAR at 230 forecast origins (expanding window)
- Uses 26 parallel workers
- Generates h={1,3,12} forecasts for all 3 models
- Saves checkpoints every 50 origins

**Expected output:**
- `results/forecasts/small_model_forecasts.rds`
- `results/forecasts/medium_model_forecasts.rds`
- `results/forecasts/full_model_forecasts.rds`
- `results/forecasts/hyperparameters_evolution.csv`

**If interrupted:** Script will offer to resume from latest checkpoint on restart.

### Phase 6: Forecast Evaluation (~5 minutes)

```bash
Rscript code/06_forecast_evaluation.R
```

**What it does:**
- Transforms forecasts to growth rates
- Computes RMSFE vs Random Walk benchmark
- Runs Diebold-Mariano tests

**Expected output:**
- `results/tables/rmsfe_results.csv`
- `results/tables/relative_rmsfe.csv`

### Phase 7: CG Regression (~3 minutes)

```bash
Rscript code/07_cg_regression.R
```

**What it does:**
- Computes forecast revisions
- Estimates Coibion-Gorodnichenko regressions
- Uses Newey-West HAC standard errors
- Interprets β coefficients (overreaction vs underreaction)

**Expected output:**
- `results/tables/cg_regression_results.csv`

## Results Interpretation

### RMSFE Results

**Relative RMSFE < 1:** BVAR outperforms Random Walk  
**Relative RMSFE > 1:** Random Walk is better

### CG Regression β Coefficients

- **β = 0:** Rational expectations (no bias)
- **β > 0:** Under-reaction to news (sticky information)
- **β < 0:** Over-reaction to news (diagnostic expectations)

**Key hypothesis:** Adding sentiment (Full model) should push β toward negative values if diagnostic expectations hold.

## Troubleshooting

### Julia not found

**Error:** `Error: Julia not found`

**Solution:**
```r
# In R, specify Julia path explicitly
Sys.setenv(JULIA_HOME = "C:/Users/YourName/AppData/Local/Programs/Julia-1.10.0/bin")
```

### FRED API key issues

**Error:** `Error: FRED_API_KEY not set`

**Solution:**
```r
# Set temporarily in R
Sys.setenv(FRED_API_KEY = "your_key_here")

# Or add to .Renviron
file.edit("~/.Renviron")
# Add line: FRED_API_KEY=your_key_here
```

### Parallel cluster errors

**Error:** `Error in cluster`

**Solution:**
```r
# Reduce number of cores
options(bayesian_de.n_cores = 4)  # Use only 4 cores
```

### Out of memory

**Error:** `Error: cannot allocate vector of size X GB`

**Solution:**
- Close other applications
- Reduce MCMC draws: Edit `code/04_bvar_estimation.R`, change `n_draw = 5000`
- Process forecasts in smaller batches

## Performance Tips

1. **Disable antivirus during Phase 5** (real-time scanning slows file I/O)
2. **Set power plan to "High Performance"** (prevents CPU throttling)
3. **Close unnecessary applications** (free up RAM)
4. **Monitor progress:** Check `results/forecasts/checkpoints/` for saved progress

## Citation

If you use this code, please cite:

```
Fu, Jingle (2025). "Forecasting Horse Races and Belief Distortions: 
A Hierarchical Bayesian VAR Study with Sentiment Signals." 
IHEID Topics in Econometrics Term Paper.
```

**Key References:**
- Giannone, Lenza & Primiceri (2015): "Prior Selection for Vector Autoregressions"
- Kuschnig & Vashold (2021): "BVAR: Bayesian Vector Autoregressions with Hierarchical Prior Selection in R"
- Coibion & Gorodnichenko (2015): "Information Rigidity and the Expectations Formation Process"

## Contact

**Author:** Jingle Fu  
**Institution:** IHEID Geneva  
**Date:** December 2025

For questions or issues, please refer to the implementation plan at:
`C:\Users\purga\.gemini\antigravity\brain\aabdde24-be0d-4550-b037-b6041eb4be26\implementation_plan.md`
