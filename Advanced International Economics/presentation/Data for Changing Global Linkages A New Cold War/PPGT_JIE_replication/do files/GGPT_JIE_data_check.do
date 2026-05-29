
global keep "country iso3 imf_income imf_region"

** Construct the dataset of fDi at the host-source-year level **
use "$input\fdimarket.dta", clear
collapse (sum) n size, by(year destination_ifscode)
drop if year==2024

rename destination_ifscode ifscode
merge m:1 ifscode using "$input\country_list_use.dta", keepusing($keep)
foreach x of varlist $keep ifscode {
	rename `x' destination_`x'
}
drop if _m==2
drop _m
rename destination_ifscode ifscode

replace destination_imf_region=2 if destination_country=="Taiwan Province of China"
replace destination_imf_region=5 if destination_country=="Venezuela"
replace destination_imf_region=5 if destination_country=="Puerto Rico"
replace destination_imf_region=4 if destination_country=="Syria"
replace destination_imf_region=4 if destination_country=="West Bank and Gaza"

merge 1:1 ifscode year using "$input\weo_bop.dta"
keep if _m==3
unique ifscode 
ta year

replace size=size
replace bfdl_bp6=bfdl_bp6*1000

drop if bfdl_bp6<0

corr bfdl_bp6 size

********************************************************************************
gen log_size = log(size)
gen log_n = log(n)
gen log_bfdl_bp6 = log(bfdl_bp6)

** Figure S3.1 **
kdensity log_size, generate(log_size_x log_size_d) nogr
kdensity log_bfdl_bp6, generate(log_bfdl_bp6_x log_bfdl_bp6_d) nogr

tw  (line log_size_d log_size_x, lp(solid) lc(dknavy) lw(medthick)) ///
	(line log_bfdl_bp6_d log_bfdl_bp6_x, lp(dash) lw(medthick) lc(black)), graphregion(col(white)) ///
	ylabel(, labsize(small) angle(0)) ///
	legend(order(1 "FDI value (from fDi Markets, logs)" 2 "FDI inflows (from IMF WEO (BFDL_BP6), logs)" ) size(medsmall) row(2) bexpand region(lstyle(none) fcolor(none) lcolor(none)) ring(1) pos(6) span) title("") ytitle(density) name(a, replace) xsize(5) ysize(5)
graph export "$charts/FS3.1A.png", as(png) replace 

reg log_bfdl_bp6 log_size

twoway (scatter log_bfdl_bp6 log_size, ms(oh)) (lfit log_bfdl_bp6 log_size, lcolor(cranberry)) (function y=x, range(-2 14) lcolor(black) lw(thin)), ///
		graphregion(col(white)) bgcolor(white) ///
		legend(order(2 "Linear fit" 3 "45 degree line") size(medsmall) row(1) bexpand region(lstyle(none) fcolor(none) lcolor(none)) ring(1) pos(6)) ///
		ytitle("FDI inflows (from IMF WEO (BFDL_BP6), logs)", size(small)) ylabel(-2(2)14, labsize(small) angle(0)) ///
		xtitle("FDI value (from fDi Markets, logs)", size(small)) xlabel(-2(2)14, labsize(small) angle(0)) ///
		xsize(5) ysize(5)
graph export "$charts/FS3.1B.png", as(png) replace 

reg log_bfdl_bp6 log_n

twoway (scatter log_size log_n, ms(oh)) (lfit log_size log_n, lcolor(cranberry)), ///
		graphregion(col(white)) bgcolor(white) ///
		legend(order(2 "Linear fit") size(medsmall) row(1) bexpand region(lstyle(none) fcolor(none) lcolor(none)) ring(1) pos(6)) ///
		ytitle("FDI value (from fDi Markets, logs)", size(small)) ylabel(-2(2)12, labsize(small) angle(0)) ///
		xtitle("FDI count (from fDi Markets, logs)", size(small)) xlabel(0(2)10, labsize(small) angle(0)) ///
		xsize(5) ysize(5)
graph export "$charts/FS3.1C.png", as(png) replace 

		

