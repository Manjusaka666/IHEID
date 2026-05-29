
********************************************************************************
** Trade chart **

use "$input\imports_annual", clear 
gen time = .
replace time = 1 if year >=2013 & year<=2017
replace time = 2 if year >=2018 & year<=2023
drop if time==.
preserve	
	keep if ifs_rpt==111
	drop if ifs_ptn==ifs_rpt
	collapse (sum) value , by(time ifs_ptn)
	bysort time: egen total = sum(value)
	gen USimportshare = 100*value/total
	drop total
	reshape wide value USimportshare, j(time) i(ifs_ptn)
	rename value1 USimports_pre
	rename value2 USimports_post
	rename USimportshare1 USimportshare_pre
	rename USimportshare2 USimportshare_post
	rename ifs_ptn ifscode 
	sort ifscode 
	save trade_tmp, replace
restore 

	keep if ifs_ptn==924
	drop if ifs_ptn==ifs_rpt
	collapse (sum) value , by(time ifs_rpt)
	bysort time: egen total = sum(value)
	gen CNexportshare = 100*value/total
	drop total
	reshape wide value CNexportshare, j(time) i(ifs_rpt)
	rename value1 CNexports_pre
	rename value2 CNexports_post
	rename CNexportshare1 CNexportshare_pre
	rename CNexportshare2 CNexportshare_post
	rename ifs_rpt ifscode 
	sort ifscode 
	merge 1:1 ifscode using trade_tmp
	keep if _m==3 
	drop _m
 
merge 1:1 ifscode using "$input\country_list_use.dta", keepusing($keep)
	keep if _m==3 
	drop _m
merge 1:1 ifscode using "$input\weo_2018_23.dta"
	keep if _m==3 
	drop _m

rename ifscode ifscode_rpt
merge m:1 ifscode_rpt using "$input\blocs.dta", keepusing(bloc3iea bloc3ipd)
	drop if _m==2
	drop _m
rename ifscode_rpt ifscode

save trade_tmp, replace

** 
use trade_tmp, clear

gen delta_CNexp = CNexportshare_post-CNexportshare_pre
gen delta_USimp = USimportshare_post-USimportshare_pre

	gen weight = ( USimports_pre)
	replace weight = weight/1000000

** Figure 4A **
reg delta_USimp delta_CNexp [aw=weight] if bloc3ipd==3, rob

	twoway (scatter delta_USimp delta_CNexp [aw=weight] if bloc3ipd==3, ms(oh) ///
		   	graphregion(color(white)) bgcolor(white) xsize(5) ///
			ytitle("Change in US imports share (2013-2017 vs 2018-2023)", size(small)) ///
			ylabel(,labsize(small) angle(0) format(%9.1f)) ///
			xtitle("Change in Chinese export share (2013-2017 vs 2018-2023)", size(small)) ///
			xlabel(,labsize(small) angle(0) format(%9.1f)) ///
			legend(off) )  ///
			(lfit delta_USimp delta_CNexp [aw=weight] if bloc3ipd==3, lcolor(red)) ///
			(scatter delta_USimp delta_CNexp if weight>40000 & bloc3ipd==3, ms(i) mlabel(iso3) mlabc(black) mlabs(vsmall))
		graph export "$charts\F4A.png", as(png) replace

** Figure S1.4A **
reg delta_USimp delta_CNexp [aw=weight] if bloc3ipd==3 & ifscode!=158, rob

	twoway (scatter delta_USimp delta_CNexp [aw=weight] if bloc3ipd==3 & ifscode!=158, ms(oh) ///
		   	graphregion(color(white)) bgcolor(white) xsize(5) ///
			ytitle("Change in US imports share (2013-2017 vs 2018-2023)", size(small)) ///
			ylabel(,labsize(small) angle(0) format(%9.1f)) ///
			xtitle("Change in Chinese export share (2013-2017 vs 2018-2023)", size(small)) ///
			xlabel(,labsize(small) angle(0) format(%9.1f)) ///
			legend(off) )  ///
			(lfit delta_USimp delta_CNexp [aw=weight] if bloc3ipd==3 & ifscode!=158, lcolor(red)) ///
			(scatter delta_USimp delta_CNexp if weight>40000 & bloc3ipd==3 & ifscode!=158, ms(i) mlabel(iso3) mlabc(black) mlabs(vsmall))
		graph export "$charts\FS1.4A.png", as(png) replace

	
********************************************************************************
** FDI and trade chart **

global keep "country iso3 imf_income imf_region"

** Construct the dataset of fDi at the host-source-year level **
use "$input\fdimarket.dta", clear
drop if source_phantom==1 | destination_phantom==1
collapse (sum) n size, by(t source_ifscode destination_ifscode)

rename source_ifscode ifscode
merge m:1 ifscode using "$input\country_list_use.dta", keepusing($keep)
foreach x of varlist $keep ifscode {
	rename `x' source_`x'
}
drop if _m==2
drop _m

rename destination_ifscode ifscode
merge m:1 ifscode using "$input\country_list_use.dta", keepusing($keep)
foreach x of varlist $keep ifscode {
	rename `x' destination_`x'
}
drop if _m==2
drop _m

replace destination_imf_region=2 if destination_country=="Taiwan Province of China"
replace source_imf_region=2 if source_country=="Taiwan Province of China"
replace destination_imf_region=5 if destination_country=="Venezuela"
replace source_imf_region=5 if source_country=="Venezuela"
replace destination_imf_region=5 if destination_country=="Puerto Rico"
replace source_imf_region=5 if source_country=="Puerto Rico"
replace destination_imf_region=4 if destination_country=="Syria"
replace source_imf_region=4 if source_country=="Syria"
replace destination_imf_region=4 if destination_country=="West Bank and Gaza"
replace source_imf_region=4 if source_country=="West Bank and Gaza"


	keep if source_ifscode==924
	drop if t >255 
	keep if t>=212
	gen time = 0
	replace time = 1 if t>=232
	
	collapse (sum) n size, by(time destination_ifscode destination_iso3 destination_imf_income destination_imf_region destination_country)
	tsset destination_ifscode time
	fillin destination_ifscode time
	replace n = 0 if _fillin==1
	replace size = 0 if _fillin==1
	drop _fillin 
	
	bysort destination_ifscode: egen n_country = total(n)
	bysort destination_ifscode: egen s_country = total(size)

	tsset destination_ifscode time
	gen delta = n-l.n
	gen dh = (n-l.n)/(0.5*n+0.5*l.n)
	bysort time: egen total = total(n)
	gen share = 100*n/total
	bysort time: egen totals = total(size)
	gen shares = 100*size/totals

	tsset destination_ifscode time
	gen deltash = share - l.share
	gen deltashs = shares - l.shares
	keep if time==1
	rename destination_iso3 iso_ptn 
	
	drop if iso_ptn ==""
	rename destination_ifscode ifscode
	merge 1:1 ifscode using trade_tmp
	keep if _m==3
	drop _m
	merge 1:1 ifscode using "$input\weo_2018_23.dta"
	keep if _m==3 
	drop _m

	rename ifscode ifscode_rpt
	merge m:1 ifscode_rpt using "$input\blocs.dta", keepusing(bloc3iea bloc3ipd)
		drop if _m==2
		drop _m
	rename ifscode_rpt ifscode

	gen weight = ( USimports_pre)
	replace weight = weight/1000000
	
	gen delta_USimp = USimportshare_post-USimportshare_pre

	reg delta_USimp deltash [aw= weight] , rob
	reg delta_USimp deltash growth [aw= weight] , rob
	reg delta_USimp deltash if bloc3ipd==3, rob
	

** Figure 4C **

	reg delta_USimp deltash [aw= weight] if bloc3ipd==3, rob

		twoway (scatter delta_USimp deltash [aw=weight] if bloc3ipd==3, ms(oh) ///
		   	graphregion(color(white)) bgcolor(white) xsize(5) ///
			ytitle("Change in US imports share (2013-2017 vs 2018-2023)", size(small)) ///
			ylabel(,labsize(small) angle(0) format(%9.1f)) ///
			xtitle("Change in Chinese FDI share (2013-2017 vs 2018-2023)", size(small)) ///
			xlabel(,labsize(small) angle(0) format(%9.1f)) ///
			legend(off) )  ///
			(lfit delta_USimp deltash [aw=weight] if bloc3ipd==3, lcolor(red)) ///
			(scatter delta_USimp deltash if weight>30000 & bloc3ipd==3, ms(i) mlabel(iso_ptn) mlabc(black) mlabs(vsmall))
		graph export "$charts\F4C.png", as(png) replace

** Figure S1.5 **
	reg delta_USimp deltashs [aw= weight] if bloc3ipd==3, rob

		twoway (scatter delta_USimp deltashs [aw=weight] if bloc3ipd==3, ms(oh) ///
		   	graphregion(color(white)) bgcolor(white) xsize(5) ///
			ytitle("Change in US imports share (2013-2017 vs 2018-2023)", size(small)) ///
			ylabel(,labsize(small) angle(0) format(%9.1f)) ///
			xtitle("Change in Chinese FDI share (2013-2017 vs 2018-2023)", size(small)) ///
			xlabel(,labsize(small) angle(0) format(%9.1f)) ///
			legend(off) )  ///
			(lfit delta_USimp deltashs [aw=weight] if bloc3ipd==3, lcolor(red)) ///
			(scatter delta_USimp deltashs if weight>30000 & bloc3ipd==3, ms(i) mlabel(iso_ptn) mlabc(black) mlabs(vsmall))
		graph export "$charts\FS1.5.png", as(png) replace

** Figure S1.4B **
	reg delta_USimp deltash [aw= weight] if bloc3ipd==3 & ifscode!=158, rob

		twoway (scatter delta_USimp deltash [aw=weight] if bloc3ipd==3 & ifscode!=158, ms(oh) ///
		   	graphregion(color(white)) bgcolor(white) xsize(5) ///
			ytitle("Change in US imports share (2013-2017 vs 2018-2023)", size(small)) ///
			ylabel(,labsize(small) angle(0) format(%9.1f)) ///
			xtitle("Change in Chinese FDI share (2013-2017 vs 2018-2023)", size(small)) ///
			xlabel(,labsize(small) angle(0) format(%9.1f)) ///
			legend(off) )  ///
			(lfit delta_USimp deltash [aw=weight] if bloc3ipd==3 & ifscode!=158, lcolor(red)) ///
			(scatter delta_USimp deltash if weight>30000 & bloc3ipd==3 & ifscode!=158, ms(i) mlabel(iso_ptn) mlabc(black) mlabs(vsmall))
		graph export "$charts\FS1.4B.png", as(png) replace


********************************************************************************
** Trade chart during the Cold War **

use "TRADHIST_blocs.dta", replace

gen id_ifs = iso_o+iso_d
tostring year, gen(yyy)
gen iso_o_year = iso_o+yyy
gen iso_d_year = iso_d+yyy
gen between = 0
replace between = 1 if tradetype==4
gen una = 0 
replace una = 1 if blocs_o==3 | blocs_d==3

encode iso_o, gen(c_o)
encode iso_d, gen(c_d)
replace between=. if tradetype==.

gen coldwar = (year>=1947 & year<=1991)
gen btw_coldwar = between*coldwar
gen una_coldwar = una*coldwar

gen time = .
replace time = 1 if year >=1934 & year<=1938
replace time = 2 if year >=1952 & year<=1956
drop if time==.
preserve	
	keep if blocs_o==1
	collapse (sum) value=FLOW, by(iso_d time)
	bysort time: egen total = sum(value)
	gen USimportshare = 100*value/total
	drop total
	reshape wide value USimportshare, j(time) i(iso_d)
	rename value1 USimports_pre
	rename value2 USimports_post
	rename USimportshare1 USimportshare_pre
	rename USimportshare2 USimportshare_post
	rename iso_d ifscode 
	sort ifscode 
	save trade_tmp2, replace
restore 

	keep if blocs_d==2
	collapse (sum) value=FLOW (mean) blocs_o blocs_d, by(time iso_o)
	bysort time: egen total = sum(value)
	gen CNexportshare = 100*value/total
	drop total
	reshape wide value CNexportshare, j(time) i(iso_o)
	rename value1 CNexports_pre
	rename value2 CNexports_post
	rename CNexportshare1 CNexportshare_pre
	rename CNexportshare2 CNexportshare_post
	rename iso_o ifscode 
	sort ifscode 
	merge 1:1 ifscode using trade_tmp2
	keep if _m==3 
	drop _m

gen delta_CNexp = CNexportshare_post-CNexportshare_pre
gen delta_USimp = USimportshare_post-USimportshare_pre

	gen weight = ( USimports_pre)
	replace weight = weight/1000000

reg delta_USimp delta_CNexp [aw=weight], rob


** Figure 4B **

reg delta_USimp delta_CNexp [aw=weight] if blocs_o==3 | blocs_d==3, rob
		
	twoway (scatter delta_USimp delta_CNexp [aw=weight] if blocs_o==3 | blocs_d==3, ms(oh) ///
		   	graphregion(color(white)) bgcolor(white) xsize(5) ///
			ytitle("Change in Western bloc imports share (1934-38 vs 1952-56)", size(small)) ///
			ylabel(,labsize(small) angle(0) format(%9.1f)) ///
			xtitle("Change in Estern bloc export share (1934-38 vs 1952-56)", size(small)) ///
			xlabel(,labsize(small) angle(0) format(%9.1f)) ///
			legend(off) )  ///
			(lfit delta_USimp delta_CNexp [aw=weight] if blocs_o==3 | blocs_d==3, lcolor(red)) ///
			(scatter delta_USimp delta_CNexp if weight>60 & (blocs_o==3 | blocs_d==3), ms(i) mlabel(ifscode) mlabc(black) mlabs(vsmall))
		graph export "$charts\F4B.png", as(png) replace

erase trade_tmp.dta
erase trade_tmp2.dta