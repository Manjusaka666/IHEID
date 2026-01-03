# ==============================================================================
# 02_data_acquisition.R
# Purpose: Download FRED data and construct three nested datasets
# Author: Jingle Fu
# Date: 2025-12-26
# ==============================================================================

cat("\n=== Starting Data Acquisition ===\n\n")

library(fredr)
library(tidyverse)
library(xts)
library(zoo)
library(quantmod)

# ------------------------------------------------------------------------------
# 1. Set Up FRED API (requires API key)
# ------------------------------------------------------------------------------

cat("Step 1: Setting up FRED API connection...\n")

# Check if API key is available
fred_api_key <- Sys.getenv("FRED_API_KEY")

if (fred_api_key == "") {
    cat("\n⚠ FRED_API_KEY not found in environment variables.\n")
    cat("Please obtain a free API key from https://fred.stlouisfed.org/docs/api/api_key.html\n")
    cat("Then set it using: Sys.setenv(FRED_API_KEY = 'your_key_here')\n\n")

    # Prompt user for API key
    fred_api_key <- readline(prompt = "Enter your FRED API key (or press Enter to skip): ")

    if (fred_api_key != "") {
        Sys.setenv(FRED_API_KEY = fred_api_key)
        # Save to .Renviron for future sessions
        renviron_file <- file.path(Sys.getenv("HOME"), ".Renviron")
        write(paste0("FRED_API_KEY=", fred_api_key), renviron_file, append = TRUE)
        cat("✓ API key saved to .Renviron\n")
    } else {
        stop("FRED API key required to proceed. Exiting.")
    }
}

fredr_set_key(fred_api_key)
cat("✓ FRED API configured.\n\n")

# ------------------------------------------------------------------------------
# 2. Define Variable Lists for Three Models
# ------------------------------------------------------------------------------

cat("Step 2: Defining variable lists...\n")

# Variable metadata
variables_metadata <- tribble(
    ~model,    ~var_name,      ~fred_code,     ~transformation,  ~description,
    "small",   "INDPRO",       "INDPRO",       "log",            "Industrial Production Index",
    "small",   "CPIAUCSL",     "CPIAUCSL",     "log",            "Consumer Price Index",
    "small",   "UNRATE",       "UNRATE",       "level",          "Unemployment Rate",
    "small",   "FEDFUNDS",     "FEDFUNDS",     "level",          "Federal Funds Rate",
    "medium",  "GS10",         "GS10",         "level",          "10-Year Treasury Yield",
    "medium",  "SP500",        "^GSPC",        "log",            "S&P 500 Index",
    "medium",  "DCOILWTICO",   "DCOILWTICO",   "log",            "WTI Crude Oil Prices",
    "full",    "UMCSENT",      "UMCSENT",      "level",          "U. Michigan Consumer Sentiment"
)

# Cumulative variable sets
small_vars <- c("INDPRO", "CPIAUCSL", "UNRATE", "FEDFUNDS")
medium_vars <- c(small_vars, "GS10", "SP500", "DCOILWTICO")
full_vars <- c(medium_vars, "UMCSENT")

cat(sprintf("  Small model: %d variables\n", length(small_vars)))
cat(sprintf("  Medium model: %d variables\n", length(medium_vars)))
cat(sprintf("  Full model: %d variables\n", length(full_vars)))
cat("\n")

# ------------------------------------------------------------------------------
# 3. Download Data from FRED
# ------------------------------------------------------------------------------

cat("Step 3: Downloading data from FRED (1985-01-01 to 2019-12-31)...\n")

start_date <- "1985-01-01"
end_date <- "2019-12-31"

# Function to download with error handling and retry
download_fred_series <- function(series_id, max_retries = 3) {
    for (attempt in 1:max_retries) {
        tryCatch(
            {
                data <- fredr(
                    series_id = series_id,
                    observation_start = as.Date(start_date),
                    observation_end = as.Date(end_date),
                    frequency = "m", # Monthly
                    aggregation_method = "eop" # End of period
                )
                cat(sprintf("  ✓ Downloaded %s (%d observations)\n", series_id, nrow(data)))
                return(data)
            },
            error = function(e) {
                if (attempt < max_retries) {
                    cat(sprintf(
                        "  ⚠ Failed to download %s (attempt %d/%d). Retrying...\n",
                        series_id, attempt, max_retries
                    ))
                    Sys.sleep(2) # Wait before retry
                } else {
                    cat(sprintf(
                        "  ✗ Failed to download %s after %d attempts: %s\n",
                        series_id, max_retries, e$message
                    ))
                    return(NULL)
                }
            }
        )
    }
    return(NULL)
}

download_yahoo_series <- function(symbol, start_date, end_date) {
    cat(sprintf("  Downloading %s from Yahoo Finance...\n", symbol))

    tryCatch(
        {
            getSymbols(symbol,
                src = "yahoo",
                from = start_date,
                to = end_date,
                auto.assign = FALSE,
                periodicity = "monthly"
            ) -> sp500_xts

            # extract close prices
            close_prices <- Cl(sp500_xts)

            # transform to monthly data (last day of month)
            monthly_prices <- to.monthly(close_prices, indexAt = "lastof", OHLC = FALSE)

            # transform to data frame (with FRED format)
            sp500_df <- data.frame(
                date = index(monthly_prices),
                value = as.numeric(monthly_prices)
            )

            cat(sprintf("  ✓ Downloaded %s (%d observations)\n", symbol, nrow(sp500_df)))
            return(sp500_df)
        },
        error = function(e) {
            cat(sprintf("  ✗ Failed to download %s: %s\n", symbol, e$message))
            return(NULL)
        }
    )
}

# Download all series
fred_data_list <- list()
for (var in unique(variables_metadata$fred_code)) {
    if (var == "^GSPC") {
        fred_data_list[["SP500"]] <- download_yahoo_series(var, start_date, end_date)
    } else {
        fred_data_list[[var]] <- download_fred_series(var)
    }
    Sys.sleep(0.5) # Be respectful to API rate limits
}

cat("\n")

# ------------------------------------------------------------------------------
# 4. Merge and Clean Data
# ------------------------------------------------------------------------------

cat("Step 4: Merging and cleaning data...\n")

# Convert to data frames with consistent date format
merge_fred_data <- function(data_list) {
    standardize_date <- function(df) {
        df %>%
            mutate(date = ceiling_date(date, "month") - days(1))
    }

    # Start with first series
    merged <- data_list[[1]] %>%
        select(date, value) %>%
        rename(!!names(data_list)[1] := value) %>%
        standardize_date()

    # Join remaining series
    for (i in 2:length(data_list)) {
        series_name <- names(data_list)[i]
        series_data <- data_list[[i]] %>%
            select(date, value) %>%
            rename(!!series_name := value) %>%
            standardize_date()

        merged <- merged %>%
            full_join(series_data, by = "date")
    }

    return(merged)
}

# Merge all data
data_raw <- merge_fred_data(fred_data_list)

# Convert to xts object
data_xts <- xts(
    data_raw %>% select(-date),
    order.by = data_raw$date
)

# Check for missing values
missing_summary <- colSums(is.na(data_xts))
cat("\nMissing values summary:\n")
print(missing_summary)

# Handle missing values (simple forward fill for now)
# Note: More sophisticated imputation may be needed
if (any(missing_summary > 0)) {
    cat("\n⚠ Warning: Missing values detected. Applying forward fill...\n")
    data_xts <- na.locf(data_xts, na.rm = FALSE)

    # Check if any NAs remain at the start
    if (any(is.na(data_xts[1, ]))) {
        cat("  Applying backward fill for leading NAs...\n")
        data_xts <- na.locf(data_xts, fromLast = TRUE)
    }

    missing_after <- colSums(is.na(data_xts))
    cat("  Remaining missing values:\n")
    print(missing_after)
}

cat(sprintf(
    "\n✓ Clean dataset: %d observations × %d variables\n",
    nrow(data_xts), ncol(data_xts)
))

# ------------------------------------------------------------------------------
# 5. Create Three Nested Datasets
# ------------------------------------------------------------------------------

cat("\nStep 5: Creating three nested datasets...\n")

data_small <- data_xts[, small_vars]
data_medium <- data_xts[, medium_vars]
data_full <- data_xts[, full_vars]

cat(sprintf("  Small model: %d vars\n", ncol(data_small)))
cat(sprintf("  Medium model: %d vars\n", ncol(data_medium)))
cat(sprintf("  Full model: %d vars\n", ncol(data_full)))

# ------------------------------------------------------------------------------
# 6. Save Raw Data
# ------------------------------------------------------------------------------

cat("\nStep 6: Saving raw data...\n")

# Save as RDS (R native format)
saveRDS(data_small, "data/raw/data_small_raw.rds")
saveRDS(data_medium, "data/raw/data_medium_raw.rds")
saveRDS(data_full, "data/raw/data_full_raw.rds")

# Save metadata
saveRDS(variables_metadata, "data/raw/variables_metadata.rds")

# Save as CSV for inspection
write.zoo(data_full, "data/raw/data_full_raw.csv", sep = ",")

cat("  ✓ Saved to data/raw/\n")

# ------------------------------------------------------------------------------
# 7. Data Quality Summary
# ------------------------------------------------------------------------------

cat("\n=== Data Acquisition Summary ===\n\n")
cat("Sample period: 1985M1 - 2019M12\n")
cat(sprintf("Total observations: %d\n", nrow(data_xts)))
cat(sprintf("Variables downloaded: %d\n", ncol(data_xts)))
cat("\nVariable list:\n")
print(variables_metadata %>% select(var_name, fred_code, description))

cat("\n✓ Data acquisition complete!\n")
cat("Next step: Run 03_data_transformation.R\n\n")
