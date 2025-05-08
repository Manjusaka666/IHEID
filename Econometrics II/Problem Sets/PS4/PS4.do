clear
cd "E:\IHEID国际经济学硕士\IHEID\Econometrics II\Problem Sets\PS4"

*----------------------------------------------*
* 1(a)  Import & merge, take logs, plot series *
*----------------------------------------------*

import delimited using "GDP.csv", varnames(1) clear
gen date = date(observation_date, "YMD") 
format date %td                      
gen tq = qofd(date)               
format tq %tq   
rename gdpc1 GDP
keep tq GDP
save gdp_temp, replace

import delimited using "RPCE.csv", varnames(1) clear
gen date = date(observation_date, "YMD")   
format date %td                  
gen tq = qofd(date)     
format tq %tq   
rename pcecc96 PCE
keep tq PCE
save pce_temp, replace

import delimited using "GPDI.csv", varnames(1) clear
gen date = date(observation_date, "YMD") 
format date %td 
gen tq = qofd(date)                        
format tq %tq   
rename gpdic1 GPDI
keep tq GPDI

merge m:1 tq using gdp_temp
drop _merge
merge m:1 tq using pce_temp
drop _merge

tsset tq, quarterly
gen lnGDP  = ln(GDP)
gen lnPCE  = ln(PCE)
gen lnGPDI = ln(GPDI)

set scheme s2color

tsline lnGDP lnPCE lnGPDI, ///
    legend(order(1 "Log GDP" 2 "Log Consumption" 3 "Log Investment")) ///
    title("Quarterly log‐levels of GDP, Consumption, Investment") 

graph export "a.png", as(png) replace

*------------------------------------*
* 1(b)  Trend regressions on three samples *
* 1(c)  Display annualized growth   *
*------------------------------------*

gen t = _n

* 1) 1965Q1–2006Q4
reg lnGDP t if inrange(tq, tq(1965q1), tq(2006q4))
predict uhat_GDP_65_06, resid
display "GDP 1965–06 annualized % = " _b[t]*4*100
reg lnPCE t if inrange(tq, tq(1965q1), tq(2006q4))
predict uhat_PCE_65_06, resid
display "PCE 1965–06 annualized % = " _b[t]*4*100
reg lnGPDI t if inrange(tq, tq(1965q1), tq(2006q4))
predict uhat_GPDI_65_06, resid
display "GPDI 1965–06 annualized % = " _b[t]*4*100

* 2) 2007Q1–2019Q4
reg lnGDP t if inrange(tq, tq(2007q1), tq(2019q4))
predict uhat_GDP_07_19, resid
display "GDP 2007-19 annualized % = " _b[t]*4*100

reg lnPCE t if inrange(tq, tq(2007q1), tq(2019q4))
predict uhat_PCE_07_19, resid
display "PCE 2007-19 annualized % = " _b[t]*4*100

reg lnGPDI t if inrange(tq, tq(2007q1), tq(2019q4))
predict uhat_GPDI_07_19, resid
display "PDI 2007-19 annualized % = " _b[t]*4*100


* 3) 2007Q1–2022Q2
reg lnGDP t if inrange(tq, tq(2007q1), tq(2022q2))
predict uhat_GDP_07_22, resid
display "GDP 2007-22 annualized % = " _b[t]*4*100

reg lnPCE t if inrange(tq, tq(2007q1), tq(2022q2))
predict uhat_PCE_07_22, resid
display "PCE 2007-22 annualized % = " _b[t]*4*100

reg lnGPDI t if inrange(tq, tq(2007q1), tq(2022q2))
predict uhat_GPDI_07_22, resid
display "GPDI 2007-22 annualized % = " _b[t]*4*100

*-------------------------------------------*
* 1(d)  ACF of û_t for each subsample     *
*-------------------------------------------*

corrgram uhat_GDP_65_06 if inrange(tq, tq(1965q1), tq(2006q4)), lags(8)
corrgram uhat_PCE_65_06, if inrange(tq, tq(1965q1), tq(2006q4)), lags(8)
corrgram uhat_GPDI_65_06, if inrange(tq, tq(1965q1), tq(2006q4)), lags(8)


corrgram uhat_GDP_07_19 if inrange(tq, tq(2007q1), tq(2019q4)), lags(8)
corrgram uhat_PCE_07_19, if inrange(tq, tq(2007q1), tq(2019q4)), lags(8)
corrgram uhat_GPDI_07_19, if inrange(tq, tq(2007q1), tq(2019q4)), lags(8)

*---------------------------------------------*
* 1(e)  生成并绘制季度环比增长率            *
*---------------------------------------------*
gen dgdp  = D.lnGDP
gen dpce  = D.lnPCE
gen dgpdi = D.lnGPDI

tsline dgdp dpce dgpdi, ///
    legend(order(1 "GDP growth" 2 "Cons growth" 3 "Inv growth")) ///
    title("Quarter‐on‐quarter log‐growth rates")

graph export "e.png", as(png) replace


*---------------------------------------------*
* 1(f)  各区间增长率的均值和标准差          *
*---------------------------------------------*
* 1965Q2–2006Q4
sum dgdp dpce dgpdi if inrange(tq, tq(1965q2), tq(2006q4))

* 2007Q2–2019Q4
sum dgdp dpce dgpdi if inrange(tq, tq(2007q2), tq(2019q4))

* 2007Q2–2022Q2
sum dgdp dpce dgpdi if inrange(tq, tq(2007q2), tq(2022q2))


*---------------------------------------------*
* 1(g)  "Great Moderation" 前后比较           *
*---------------------------------------------*
* 1965Q2–1983Q4
sum dgdp dpce dgpdi if inrange(tq, tq(1965q2), tq(1983q4))

* 1984Q1–2006Q4
sum dgdp dpce dgpdi if inrange(tq, tq(1984q1), tq(2006q4))

corrgram uhat_GDP_07_22 if inrange(tq, tq(2007q1), tq(2022q2)), lags(8)
corrgram uhat_PCE_07_22, if inrange(tq, tq(2007q1), tq(2022q2)), lags(8)
corrgram uhat_GPDI_07_22, if inrange(tq, tq(2007q1), tq(2022q2)), lags(8)
