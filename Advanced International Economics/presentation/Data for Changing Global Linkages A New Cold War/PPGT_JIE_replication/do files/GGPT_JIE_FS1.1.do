
** Figure S1.1, panel A **

** Import the latest data 
** Get the latest file from here: https://intlmonetaryfund.sharepoint.com/teams/SPRHome/SPRXP/SitePages/Trade%20Monitor.aspx

import excel "$input\GGPT_tables.xlsx", sheet("dataFS1.1A") firstrow clear
drop if year==2024
graph bar Goods Investments Services, over (year, label(labsize(medsmall))) stack xsize(6) ///
		bar(1, lc(black) lw(thin) c(midblue%90)) ///
		bar(2, lc(black) lw(thin) c(gold%90)) ///
		bar(3, lc(black) lw(thin) c(cranberry%90)) ///
		ylabel(, angle(0) labsize(small) format(%9.0f)) ///
		ytitle("Number of harmful restrictions", size(medsmall))  ///
		graphregion(color(white)) plotregion(color(white))  bgcolor(white)  ///
		legend(order(1 2 3) lab(3 "Services") lab(2 "Investments") lab(1 "Goods")  size(medsmall) row(3) pos(10) ring(0) region(lstyle(none) fcolor(none) lcolor(none)))
		graph export "$charts\FS1.1A.png", as(png) replace

		
		
** Figure S1.1, panel B **
		
** Import the Caldara Iacoviello and go from monthly to quarterly **
** Get the latest (monthly) dta from here: https://www.matteoiacoviello.com/gpr.htm
use "$input\data_gpr_export.dta", clear
gen q = quarter(dofm(month))
gen y = year(dofm(month))
keep month y q GPR

gen t =yq(y,q)
keep if y>=2000
collapse (mean) GPR, by(t)
format %tq t
save "$input\GPR_q", replace

** Import the fragmentation keyword index **
** Data are from NL Analytics
import excel "$input\GGPT_tables.xlsx", sheet("dataFS1.1B") firstrow clear
split period, parse("q")
destring period1, gen(y)
destring period2, gen(q)
gen t =yq(y,q)
format %tq t
rename exposure_n FKI
keep t FKI
drop if t==.
save "$input\FKI_q.dta", replace

** Chart fragmentation and geopolitical risk **
use "$input\GPR_q", clear
merge 1:1 t using "$input\FKI_q"
keep if _m==3
drop _m

foreach x of varlist GPR FKI {
	gen `x'_tmp = `x' if t==220
	egen `x'_den = max(`x'_tmp)
	gen `x'_norm = 100*`x'/`x'_den
}

		twoway  (line GPR_norm t, lcolor(blue) ///
				lpattern(solid) lwidth(medthick) xsize(6)) /// 
				(line FKI_norm t, yaxis(2) lwidth(medthick) lcolor(red) lp(solid )), ///
				title(" ", color(black) size(medsmall)) ///
				ytitle("Geopolitical risk index (2015:q1=100)", size(medsmall)) ///
				ytitle("Fragmentation keyword index (2015:q1=100)", size(medsmall) axis(2)) ///
				xtitle(" ", size(medsmall)) ///
				xlabel(#10, angle(0) labsize(small)) ///
				ylabel(, angle(0) labsize(small) format(%9.0f)) ///
				ylabel(, angle(0) labsize(small) format(%9.0f) axis(2)) ///
				graphregion(color(white)) plotregion(color(white))  bgcolor(white) ///
				legend(order(1 2) lab(1 "Geopolitical risk index") lab(2 "Fragmentation keywork index") size(medsmall) row(2) pos(10) ring(0) region(lstyle(none) fcolor(none) lcolor(none)))
		graph export "$charts\FS1.1B.png", as(png) replace

