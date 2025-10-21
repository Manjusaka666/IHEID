# -*- coding: utf-8 -*-
"""
Build SW-style observables for PS3 from FRED + BLS.

Outputs:
  - usmodel_data_new.xlsx  (sheet 'Obs' with columns:
      date, dy, dc, dinve, dw, hours, pinfobs, robs)
Conventions:
  - Quarterly frequency
  - Logs are natural logs * 100
  - Growth observables are first differences of the logged per-capita levels
  - Indices normalized at 2017Q3 = 1 for CE16OV (employment) and CNP16OV (population)
  - EFFR is averaged monthly->quarterly, then divided by 4 to make a quarterly "rate"
"""

import os, json, requests
import pandas as pd
import numpy as np
from dateutil.relativedelta import relativedelta
from fredapi import Fred

# --------------------------
# 0) YOUR API KEYS (embedded)
# --------------------------
FRED_API_KEY = "f01b09fa5b1f987f649d603ee3bf4f88"  # you provided this
BLS_KEY = "17480a40f59e4e07a0678178edbe6e0a"  # you provided this

fred = Fred(api_key=FRED_API_KEY)


# -----------------------------------
# 1) Helper: monthly -> quarterly avg
# -----------------------------------
def to_quarterly_avg(s):
    s = s.copy()
    s.index = pd.to_datetime(s.index)
    return s.resample("Q").mean()


def ln100(x):
    # safe log: coerce non-positive to NaN to avoid -inf
    x = pd.to_numeric(x, errors="coerce")
    x = x.where(x > 0)
    return 100.0 * np.log(x)


def normalize_at(series, period_str="2017Q3"):
    s = pd.to_numeric(series, errors="coerce").astype(float).copy()
    per = pd.Period(period_str, freq="Q")
    if per not in s.index:
        raise KeyError(
            f"Anchor period {period_str} not found in series index. Available from {s.index.min()} to {s.index.max()}"
        )
    anchor = s.loc[per]
    if pd.isna(anchor) or anchor == 0:
        raise ValueError(f"Anchor value for {period_str} is missing or zero: {anchor}")
    return s / anchor


# ----------------------------------
# 2) Pull FRED series (metadata refs)
# ----------------------------------
# GDPC1 (real GDP, chained 2017$, quarterly)         — FRED: GDPC1
# GDPDEF (GDP deflator, 2017=100, quarterly)         — FRED: GDPDEF
# FPI (Fixed Private Investment, nominal $ SAAR, q)  — FRED: FPI
# PCEC (Nominal personal consumption exp., SAAR, m)  — FRED: PCEC
# CE16OV (Employment level, persons 16+, monthly)    — FRED: CE16OV
# CNP16OV (Civilian population 16+, monthly)         — FRED: CNP16OV
# FEDFUNDS (Effective Fed Funds Rate, monthly)       — FRED: FEDFUNDS

series_q = ["GDPC1", "GDPDEF", "FPI"]
qdf = pd.DataFrame()
for s in series_q:
    try:
        ser = fred.get_series(s).to_frame(s)
        ser.index = pd.PeriodIndex(ser.index, freq="Q")
        qdf = pd.concat([qdf, ser], axis=1)
    except Exception as e:
        print(f"Warning: failed to fetch {s} from FRED: {e}")

series_m = ["PCEC", "CE16OV", "CNP16OV", "FEDFUNDS"]
mdf = {}
for s in series_m:
    try:
        ser = fred.get_series(s).to_frame(s)
        ser.index = pd.to_datetime(ser.index)
        mdf[s] = ser
    except Exception as e:
        print(f"Warning: failed to fetch {s} from FRED: {e}")
mqdf = pd.DataFrame()
for s in series_m:
    if s in mdf:
        try:
            mqdf = pd.concat([mqdf, to_quarterly_avg(mdf[s][s])], axis=1)
        except Exception as e:
            print(f"Warning: failed to process monthly series {s}: {e}")
    else:
        mqdf[s] = np.nan
mqdf.columns = series_m
mqdf.index = pd.PeriodIndex(mqdf.index, freq="Q") if len(mqdf.index) > 0 else mqdf.index

df = pd.concat([qdf, mqdf], axis=1).sort_index()

# --------------------------------------
# 3) Pull BLS PRS85006103 via BLS v2 API
#     (Hourly Compensation Index 2017=100, quarterly, SA)
#     We mimic your example: JSON body + headers
# --------------------------------------
headers = {"Content-type": "application/json"}
payload = {
    "seriesid": [
        "PRS85006103"
    ],  # Nonfarm Business Sector: Hourly Compensation (Index 2017=100, Q, SA)
    "startyear": "1947",
    "endyear": "2025",
    "registrationkey": BLS_KEY,
}
rows = []
try:
    resp = requests.post(
        "https://api.bls.gov/publicAPI/v2/timeseries/data/",
        data=json.dumps(payload),
        headers=headers,
        timeout=60,
    )
    resp.raise_for_status()
    js = resp.json()
    for series in js.get("Results", {}).get("series", []):
        sid = series.get("seriesID")
        for item in series.get("data", []):
            per = item.get("period", "")
            if per.startswith("Q"):
                year = int(item.get("year"))
                qtr = int(per[-2:]) if len(per) == 3 else int(per[-1])
                try:
                    val = float(item.get("value"))
                except Exception:
                    val = np.nan
                rows.append([pd.Period(f"{year}Q{qtr}", freq="Q"), val])
except Exception as e:
    print(f"Warning: BLS request failed: {e}. Continuing without BLS series.")

if len(rows) > 0:
    prs = (
        pd.DataFrame(rows, columns=["date", "PRS85006103"])
        .set_index("date")
        .sort_index()
    )
    df = df.join(prs, how="outer")
else:
    # ensure column exists for later code
    df["PRS85006103"] = np.nan

# --------------------------------------------
# 4) Trim the master panel to a safe broad span
#     (lets us compute lags before 1965Q1 window)
# --------------------------------------------
try:
    df = df[(df.index >= pd.Period("1955Q1")) & (df.index <= pd.Period("2025Q2"))]
except Exception as e:
    print(f"Warning trimming df index: {e}")

# --------------------------------------------
# 5) Construct indices normalized at 2017Q3 = 1
#    (PS3/Read_me convention for population & employment)
# --------------------------------------------
try:
    LNSindex = normalize_at(df.get("CNP16OV"), "2017Q3")  # population index
except Exception as e:
    raise RuntimeError(f"Failed to construct LNSindex: {e}")
try:
    CE16index = normalize_at(df.get("CE16OV"), "2017Q3")  # employment index
except Exception as e:
    raise RuntimeError(f"Failed to construct CE16index: {e}")

# ----------------------------------------------------
# 6) Apply SW transforms (be careful with denominators)
#     - All logs are ln(*)*100
#     - Per capita uses CNP16OV index (LNSindex)
#     - Hours: (Hours index * Employment index / 100) / Pop index
#     - Inflation: ln(GDPDEF/GDPDEF(-1))*100
#     - Real wage: ln(PRS85006103 / GDPDEF)*100
#     - Policy rate (robs): quarterly 'level' = (avg monthly EFFR)/4
# ----------------------------------------------------
GDPDEF = pd.to_numeric(df.get("GDPDEF"), errors="coerce")
GDPC1 = pd.to_numeric(df.get("GDPC1"), errors="coerce")
PCEC = pd.to_numeric(df.get("PCEC"), errors="coerce")
FPI = pd.to_numeric(df.get("FPI"), errors="coerce")
HRSIDX = pd.to_numeric(df.get("PRS85006023"), errors="coerce")
HCIDX = pd.to_numeric(df.get("PRS85006103"), errors="coerce")
EFFR = pd.to_numeric(df.get("FEDFUNDS"), errors="coerce")

# If PRS85006023 isn't pre-fetched (rare), grab it quickly
if HRSIDX is None or HRSIDX.isna().all():
    try:
        hrs = fred.get_series("PRS85006023").to_frame("PRS85006023")
        hrs.index = pd.PeriodIndex(hrs.index, freq="Q")
        df = df.join(hrs, how="left")
        HRSIDX = pd.to_numeric(df.get("PRS85006023"), errors="coerce")
    except Exception as e:
        print(f"Warning: failed to fetch PRS85006023: {e}")

# Real per-capita levels
consumption = ln100((PCEC / GDPDEF) / LNSindex)
investment = ln100((FPI / GDPDEF) / LNSindex)
output = ln100(GDPC1 / LNSindex)

# Hours per capita (aggregate hours proxy)
hours = ln100(((HRSIDX * CE16index) / 100.0) / LNSindex)

# Inflation (q/q)
pinfobs = ln100(GDPDEF / GDPDEF.shift(1))

# Real wage (hourly compensation / GDP deflator)
dw_level = ln100(HCIDX / GDPDEF)

# Policy rate (quarterly)
robs = EFFR / 4.0

# Growth observables (first differences)
dy = output.diff()
dc = consumption.diff()
dinve = investment.diff()
dw = dw_level.diff()

obs = pd.DataFrame(
    {
        "dy": dy,
        "dc": dc,
        "dinve": dinve,
        "dw": dw,
        "hours": hours,
        "pinfobs": pinfobs,
        "robs": robs,
    }
).dropna()

# Start the observable panel at 1965Q1 as per PS3
obs = obs[obs.index >= pd.Period("1965Q1")]

# --------------------------------------------
# 7) Write Excel similar to usmodel_data.xls
#     - Sheet 'Obs'
#     - Column A: date string (YYYYQn)
#     - Columns B:H: the 7 observables
# --------------------------------------------
sheet = obs.copy()
sheet.insert(0, "date", sheet.index.astype(str))

out_path = "usmodel_data_new.xlsx"
try:
    with pd.ExcelWriter(out_path, engine="openpyxl") as xlw:
        sheet.to_excel(xlw, sheet_name="Obs", index=False)
    print(f"Wrote {out_path} with sheet 'Obs' and columns:")
    print(list(sheet.columns))
    print(
        f"Rows: {len(sheet)} (from {sheet['date'].iloc[0]} to {sheet['date'].iloc[-1]})"
    )
except Exception as e:
    warn_path = "usmodel_data_new.csv"
    print(
        f"Warning: failed to write Excel file: {e}. Falling back to CSV at {warn_path}"
    )
    sheet.to_csv(warn_path, index=False)
    print(f"Wrote fallback CSV {warn_path} with columns: {list(sheet.columns)}")
