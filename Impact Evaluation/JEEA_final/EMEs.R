###############################################################
##  EMEs_replication.R   ––  R rewrite of EMEs_do.do
##  “Sovereign Debt Relief and its Aftermath”
##  Carmen M. Reinhart & Christoph Trebesch
###############################################################

## —— 0  libraries ————————————————————————————————
library(haven)      # read_dta
library(dplyr)      # data wrangling
library(data.table) # fast lag/lead within groups
library(fixest)     # FE & clustered regressions
library(tidyr)      # pivot_wider etc.

## —— 1  read the Stata file ——————————————————————
eme <- read_dta("EMEs.dta") %>%             # same file the do-file reads
        mutate(across(everything(), as.vector))  # avoid labelled <dbl+lbl>

## optional: keep a data.table copy for fast by-group ops
setDT(eme)                                   # convert in-place


## ------------------------------------------------------------------
## 2  DEFINE DEFAULT SPELLS & RESTRUCTURING YEARS
## ------------------------------------------------------------------

## helper tables instead of 200 repetitive replace-lines  --------------
final_restruct <- tribble(
  ~country, "year",
  "Algeria", 1996,
  "Argentina", 1993,
  "Argentina", 2005,
  "Bosnia and Herzegovina", 1997,
  "Brazil", 1994,
  "Bulgaria", 1994,
  "Chile", 1990,
  "Costa Rica", 1990,
  "Croatia", 1996,
  "Dominica", 2005,
  "Dominican Republic", 1994,
  "Dominican Republic", 2005,
  "Ecuador", 1995,
  "Ecuador", 2000,
  "Ecuador", 2009,
  "Gabon", 1994,
  "Grenada", 2005,
  "Jamaica", 1993,
  "Jordan", 1993,
  "Macedonia", 1997,
  "Mexico", 1990,
  "Panama", 1996,
  "Peru", 1997,
  "Poland", 1994,
  "Romania", 1986,
  "Russia", 2000,
  "Serbia and Montenegro", 2004,
  "Seychelles", 2010,
  "Slovenia", 1996,
  "South Africa", 1993,
  "Trinidad and Tobago", 1989,
  "Turkey", 1982,
  "Uruguay", 1991,
  "Uruguay", 2003,
  "Venezuela", 1990
)

default_spells <- tribble(
  ~country,     ~start, ~end,
  "Algeria",     1991,   1996,
  "Argentina",   1983,   1993,
  "Argentina",   2001,   2005,
  "Bosnia and Herzegovina", 1992, 1997,
  "Brazil",      1983,   1994,
  "Bulgaria",    1990,   1994,
  "Chile",       1983,   1990,
  "Costa Rica",  1983,   1990,
  "Croatia",     1992,   1996,
  "Dominica",    2003,   2005,
  "Dominican Republic", 1982, 1994,
  "Dominican Republic", 2005, 2005,
  "Ecuador",     1982,   1995,
  "Ecuador",     1999,   2000,
  "Ecuador",     2008,   2009,
  "Gabon",       1986,   1994,
  "Grenada",     2004,   2005,
  "Jamaica",     1978,   1993,
  "Jordan",      1989,   1993,
  "Macedonia",   1992,   1997,
  "Mexico",      1982,   1990,
  "Panama",      1983,   1996,
  "Peru",        1980,   1997,
  "Poland",      1981,   1994,
  "Romania",     1981,   1986,
  "Russia",      1991,   2000,
  "Serbia and Montenegro", 2003, 2004,
  "Seychelles",  2008,   2010,
  "Slovenia",    1992,   1996,
  "South Africa",1985,   1993,
  "Trinidad and Tobago", 1988, 1989,
  "Turkey",      1978,   1982,
  "Uruguay",     1983,   1991,
  "Uruguay",     2003,   2003,
  "Venezuela",   1983,   1990
)

## flag final-year restructurings --------------------
eme[, EME_finalrestruct := fifelse(
       .(country, year) %chin% final_restruct, 1L, 0L)]

## flag default years --------------------------------
eme[, EME_default := 0L]
for (i in seq_len(nrow(default_spells))) {
  row  <- default_spells[i]
  eme[country == row$country &
      year >  row$start &
      year <  row$end,  EME_default := 1L]
}

## ------------------------------------------------------------------
## 3  BRADY, BAKER dummies & relief magnitudes
## ------------------------------------------------------------------

brady_tbl <- tribble(
  ~country, ~year, ~relief_gdp, ~relief_debt,
  "Argentina", 1993, 24.0,  80.1,
  "Brazil",    1994, 14.3,  59.9,
  "Bulgaria",  1994, 55.6,  45.9,
  "Costa Rica",1990, 43.4,  59.9,
  "Dominican Republic", 1994, 13.3, 42.2,
  "Ecuador",   1995, 31.2,  83.1,
  "Jordan",    1993,  5.3,   4.1,
  "Mexico",    1990, 36.2, 105.1,
  "Panama",    1996, 22.9,  52.3,
  "Peru",      1997, 13.8,  40.4,
  "Poland",    1994, 15.1,  NA,
  "Uruguay",   1991, 34.3,  NA,
  "Venezuela", 1990, 41.6, 105.9
)

baker_tbl <- tribble(
  ~country, ~year,
  "Argentina", 1987,
  "Brazil",    1988,
  "Chile",     1987,
  "Costa Rica",1985,
  "Dominican Republic", 1986,
  "Ecuador",   1985,
  "Mexico",    1987,
  "Panama",    1985,
  "Poland",    1988,
  "Uruguay",   1988,
  "Venezuela", 1986
)

## merge in flags
eme <- eme %>%
  left_join(brady_tbl  %>% select(country, year, relief_gdp, relief_debt)
                         %>% mutate(Brady_deal = 1),
            by = c("country", "year")) %>%
  left_join(baker_tbl %>% mutate(Baker_deal = 1),
            by = c("country", "year")) %>%
  mutate(across(c(Brady_deal, Baker_deal), ~replace_na(., 0)))

## ------------------------------------------------------------------
## 4  EVENT INDICES  (-5 … +5)  around restructuring / 1986 / 1990
## ------------------------------------------------------------------

## helper that turns a “pivot year” vector into an index
make_index <- function(x, pivot) {
  idx <- rep(NA_integer_, length(x))
  for (k in -5:5) {
    idx[shift(x, type = ifelse(k > 0, "lag", "lead"), n = abs(k)) == pivot] <- k
  }
  idx
}

setorder(eme, codeid, year)
eme[, Deal_index  := make_index(EME_finalrestruct, 1),      by = codeid]
eme[, y1986_index := make_index(year, 1986),                by = codeid]
eme[, y1990_index := make_index(year, 1990),                by = codeid]

## ------------------------------------------------------------------
## 5  GDP & RATING INDICES (value = 1 in event year)
## ------------------------------------------------------------------

## helper: index a variable relative to the pivot year
index_to_pivot <- function(v, idx) {
  out <- rep(NA_real_, length(v))
  for (k in -5:5) {
    target <- if (k > 0) shift(v, n = k, type = "lead") else
                            if (k < 0) shift(v, n = -k, type = "lag") else v
    out[idx == k] <- v[idx == k] / target[idx == k]
  }
  out
}

eme[,  `:=`(
  EMEGDP_index       = index_to_pivot(EME_real_pc, Deal_index),
  EMEGDP_1986index   = index_to_pivot(EME_real_pc, y1986_index),
  EMEGDP_1990index   = index_to_pivot(EME_real_pc, y1990_index),
  
  EMErating_index    = index_to_pivot(iir_yearly, Deal_index),
  EMErating_1986index= index_to_pivot(iir_yearly, y1986_index),
  EMErating_1990index= index_to_pivot(iir_yearly, y1990_index)
)]

## ------------------------------------------------------------------
## 6  GROUP & SAMPLE FLAGS  (treatment / control / region)
## ------------------------------------------------------------------

## Brady treatment group = at least one Brady_deal in panel
eme[, Brady_group  := max(Brady_deal), by = codeid]
eme[, Baker_group  := Brady_group]                     # copy
eme[country == "Chile", Baker_group := 1]              # Chile only Baker

## Counterfactual lists
cf_list <- c("Thailand","Malaysia","South Korea","Israel","India",
             "Mauritius","Colombia","Singapore","Egypt",
             "Czech Republic","Hungary","Turkey","China","Taiwan")

eme[, `:=`(
        Baker_counterfactual = ifelse(country %in% cf_list & Baker_group==0, 1, 0),
        Brady_counterfactual = ifelse(country %in% cf_list & Brady_group==0, 1, 0)
)]

## Henry counterfactual
henry_cf <- c("Chile","China","Colombia","Czech Republic","Greece","Hungary",
              "India","Indonesia","South Korea","Malaysia","Pakistan",
              "South Africa","Sri Lanka","Thailand","Turkey","Zimbabwe")
eme[, Henry_counterfactual := fifelse(country %in% henry_cf & Brady_group==0, 1, 0)]

## Final treatment flags
eme[, Baker_treat := 1 - Baker_counterfactual]
eme[, Brady_treat := 1 - Brady_counterfactual]
eme[, Henry_treat := 1 - Henry_counterfactual]

## Regions (simple grepl)
eme[, LatAm := grepl("Argentina|Brazil|Chile|Colombia|Costa Rica|Dominican Republic|Ecuador|Peru|Mexico|Panama|Uruguay|Venezuela|Bolivia|Paraguay|Guatemala|Belize|Haiti|Honduras|El Salvador", country)]
eme[, LatAm_treat := as.integer(Brady_group==1 | country=="Bolivia")]
eme[LatAm & LatAm_treat==0, LatAm_treat := 0]

eme[, EastEurope_EME := grepl("Bulgaria|Poland|Hungary|Czech Republic", country)]
eme[, EastAsia_EME   := grepl("Thailand|Malaysia|South Korea|China|Taiwan|Singapore", country)]

## Sample restrictions
eme[, EME_period := between(year, 1980, 2012)]
eme[, EME_defaulter := max(EME_default), by = codeid]
eme[, EME_alldefaulter := EME_defaulter]
eme[, EME_counterfactual := Baker_counterfactual]

ex_yugo <- c("Bosnia and Herzegovina","Slovenia",
             "Croatia","Macedonia","Serbia and Montenegro")
eme[, ExYugo := country %in% ex_yugo]

eme[, EME_sample := fifelse((EME_alldefaulter==1 | EME_counterfactual==1) &
                            between(year, 1980, 2012) & !ExYugo, 1, NA_integer_)]

## ------------------------------------------------------------------
## 7  RESIDUAL GROWTH (country FE)   — for graphs
## ------------------------------------------------------------------

## fixest automatically removes FE when predicting residuals
eme[, residgrowth_EMEdef :=
        resid(feols(EME_real_pc_growth ~ 0 | codeid,
                    data = eme[EME_alldefaulter==1 & EME_period==1]))]

eme[, residgrowth_brady :=
        resid(feols(EME_real_pc_growth ~ 0 | codeid,
                    data = eme[Brady_treat==1 & EME_period==1]))]

eme[, residgrowth_baker :=
        resid(feols(EME_real_pc_growth ~ 0 | codeid,
                    data = eme[Baker_treat==1 & EME_period==1]))]

eme[, residgrowth_countEME :=
        resid(feols(EME_real_pc_growth ~ 0 | codeid,
                    data = eme[EME_counterfactual==1 & EME_period==1]))]

## ------------------------------------------------------------------
## 8  DIFFERENCE-IN-DIFFERENCES VARIABLES
## ------------------------------------------------------------------

## 5-year windows
eme[, `:=`(
  EMEdefault_window = as.integer(Deal_index > -6 & Deal_index < 6),
  DiD1988_5year = between(year, 1983, 1992),
  DiD1989_5year = between(year, 1984, 1993),
  DiD1990_5year = between(year, 1985, 1994),
  DiD1990_3year = between(year, 1988, 1993),
  DiD1990_4year = between(year, 1987, 1994),
  DiD1990_6year = between(year, 1984, 1996),
  DiD1986_5year = between(year, 1981, 1990)
)]

## post indicators
eme[, after1989 := as.integer(year > 1989)]
eme[, after1990 := as.integer(year > 1990)]
eme[, after1988 := as.integer(year > 1988)]
eme[, after1986 := as.integer(year > 1986)]

## interacted treatment dummies
eme[, post_Brady     := Brady_treat * after1990]
eme[, post_BradLatAm := LatAm_treat * after1990]
eme[, post_1988      := Brady_treat * after1988]
eme[, post_Baker     := Baker_treat * after1986]

## continuous relief vars
eme[, Brady_debtrelief       := max(relief_gdp,  na.rm = TRUE), by = codeid]
eme[!Brady_treat==1, Brady_debtrelief := 0]

eme[, Brady_debtstockrelief  := max(relief_debt, na.rm = TRUE), by = codeid]
eme[!Brady_treat==1, Brady_debtstockrelief := 0]

eme[, after_Bradyrelief      := after1990 * Brady_debtrelief]
eme[, after_Bradystockrelief := after1990 * Brady_debtstockrelief]

## ------------------------------------------------------------------
## 9  QUICK CHECK: MAIN BRADY DiD  (Table 6, col 1)
## ------------------------------------------------------------------

mod_growth_brady <- feols(
  EME_real_pc_growth ~ after1990 + post_Brady | codeid + year,
  cluster = ~codeid,
  data    = eme[DiD1990_5year == 1])

summary(mod_growth_brady)

##  You can now loop through all the robustness & alternative models
##  listed in the do-file using fixest (or plm if you prefer).
##  To export into LaTeX / Word / Excel use modelsummary or
##  etable(mod_growth_brady, file = "DiD_Baker_Brady_Results.html")
