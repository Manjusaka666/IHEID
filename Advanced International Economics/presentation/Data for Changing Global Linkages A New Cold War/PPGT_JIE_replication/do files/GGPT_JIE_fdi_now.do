
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

rename source_ifscode ifscode_rpt
merge m:1 ifscode_rpt using "$input\blocs.dta", keepusing(bloc3iea bloc3ipd)
	rename bloc3iea source_bloc3iea
	rename bloc3ipd source_bloc3ipd
	drop if _m==2
	drop _m
rename ifscode_rpt source_ifscode
	
rename destination_ifscode ifscode_rpt
merge m:1 ifscode_rpt using "$input\blocs.dta", keepusing(bloc3iea bloc3ipd)
	rename bloc3iea destination_bloc3iea
	rename bloc3ipd destination_bloc3ipd
	drop if _m==2
	drop _m
rename ifscode_rpt destination_ifscode

cap drop linksiea
gen linksiea = .
replace linksiea = 1 if destination_bloc3iea==1 & source_bloc3iea==1
replace linksiea = 1 if destination_bloc3iea==2 & source_bloc3iea==2
replace linksiea = 2 if destination_bloc3iea==1 & source_bloc3iea==2
replace linksiea = 2 if destination_bloc3iea==2 & source_bloc3iea==1
replace linksiea = 3 if destination_bloc3iea==3 & source_bloc3iea==3
replace linksiea = 3 if destination_bloc3iea==1 & source_bloc3iea==3
replace linksiea = 3 if destination_bloc3iea==2 & source_bloc3iea==3
replace linksiea = 3 if destination_bloc3iea==3 & source_bloc3iea==2
replace linksiea = 3 if destination_bloc3iea==3 & source_bloc3iea==1

cap drop linksipd
gen linksipd = .
replace linksipd = 1 if destination_bloc3ipd==1 & source_bloc3ipd==1
replace linksipd = 1 if destination_bloc3ipd==2 & source_bloc3ipd==2
replace linksipd = 2 if destination_bloc3ipd==1 & source_bloc3ipd==2
replace linksipd = 2 if destination_bloc3ipd==2 & source_bloc3ipd==1
replace linksipd = 3 if destination_bloc3ipd==3 & source_bloc3ipd==3
replace linksipd = 3 if destination_bloc3ipd==1 & source_bloc3ipd==3
replace linksipd = 3 if destination_bloc3ipd==2 & source_bloc3ipd==3
replace linksipd = 3 if destination_bloc3ipd==3 & source_bloc3ipd==2
replace linksipd = 3 if destination_bloc3ipd==3 & source_bloc3ipd==1
********************************************************************************

egen dyad = group(source_ifscode destination_ifscode)
tsset dyad t
fillin dyad t
replace n = 0 if n==.
replace size = 0 if size==.
	gen y = yofd(dofq(t))

bysort dyad: egen linksiea2 = mean(linksiea)
bysort dyad: egen linksipd2 = mean(linksipd)

rangestat (mean) n, i(t -3 0) by(dyad)

bysort dyad: egen total = total(n)
tsset dyad t

gen post18 = 0
replace post18=1 if t>=232
gen postwar = 0
replace postwar=1 if t>=248

gen between_iea = 0
replace between_iea = 1 if linksiea2==2
replace between_iea = . if linksiea2==.

gen between_ipd = 0
replace between_ipd = 1 if linksipd2==2
replace between_ipd = . if linksipd2==.

gen nonaligned_ipd = 0
replace nonaligned_ipd = 1 if linksipd2==3
replace nonaligned_ipd = . if linksipd2==.

bysort dyad: egen sourceifs = max(source_ifscode)
bysort dyad: egen destinationifs = max(destination_ifscode)


preserve
	cap drop total
	local thres 5
	local time 192
	local end  257
	bysort dyad: egen total = total(n) if t>=`time' & t<=`end'


** Table 1, columns 3-4 **

ppmlhdfe n l.n postwar##i.linksipd2 if total>=`thres' & t>=`time' & t<=`end', absorb (dyad t )  vce(cluster dyad) d
	outreg2 using "$tables\T1.xls", nocons ctitle(PPML) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, Y, Source x Time FE, N, Destination x Time FE, N, Blocs, Wider)
ppmlhdfe n l.n postwar##i.linksipd2 if total>=`thres' & t>=`time' & t<=`end', absorb (dyad t#destinationifs t#sourceifs)  vce(cluster dyad) d
	outreg2 using "$tables\T1.xls", nocons ctitle(PPML) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, -, Source x Time FE, Y, Destination x Time FE, Y, Blocs, Wider)
	
ppmlhdfe n l.n postwar##i.linksiea2 if total>=`thres' & t>=`time' & t<=`end', absorb (dyad t ) vce(cluster dyad) d
	outreg2 using "$tables\T1.xls", nocons ctitle(PPML) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, Y, Source x Time FE, N, Destination x Time FE, N, Blocs, Narrow)
ppmlhdfe n l.n postwar##i.linksiea2 if total>=`thres' & t>=`time' & t<=`end', absorb (dyad t#destinationifs t#sourceifs) vce(cluster dyad) d
	outreg2 using "$tables\T1.xls", nocons ctitle(PPML) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, -, Source x Time FE, Y, Destination x Time FE, Y, Blocs, Narrow)


** Table S2.3 **

ppmlhdfe size l.size postwar##i.linksipd2 if total>=`thres' & t>=`time' & t<=`end', absorb (dyad t )  vce(cluster dyad) d
	outreg2 using "$tables\TS2.3.xls", nocons ctitle(PPML) bdec(4) tdec(4) se excel label replace addtext(Country-pair FE, Y, Time FE, Y, Source x Time FE, N, Destination x Time FE, N, Blocs, Wider)
ppmlhdfe size l.size postwar##i.linksipd2 if total>=`thres' & t>=`time' & t<=`end', absorb (dyad t#destinationifs t#sourceifs)  vce(cluster dyad) d
	outreg2 using "$tables\TS2.3.xls", nocons ctitle(PPML) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, -, Source x Time FE, Y, Destination x Time FE, Y, Blocs, Wider)

restore


** Table S2.2, Columns 3-4 **

preserve
	cap drop total
	local thres 5
	local time 192
	local end  257
	bysort dyad: egen total = total(n) if t>=`time' & t<=`end'

drop if sourceifs==111 | destinationifs==111

ppmlhdfe n l.n postwar##i.linksipd2 if total>=`thres' & t>=`time' & t<=`end', absorb (dyad t )  vce(cluster dyad) d
	outreg2 using "$tables\TS2.2.xls", nocons ctitle(PPML) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, Y, Source x Time FE, N, Destination x Time FE, N, Blocs, Wider, Sample, No US)
ppmlhdfe n l.n postwar##i.linksipd2 if total>=`thres' & t>=`time' & t<=`end', absorb (dyad t#destinationifs t#sourceifs)  vce(cluster dyad) d
	outreg2 using "$tables\TS2.2.xls", nocons ctitle(PPML) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, -, Source x Time FE, Y, Destination x Time FE, Y, Blocs, Wider, Sample, No US)

restore
	
preserve
	cap drop total
	local thres 5
	local time 192
	local end  257
	bysort dyad: egen total = total(n) if t>=`time' & t<=`end'

drop if sourceifs==924 | destinationifs==924

ppmlhdfe n l.n postwar##i.linksipd2 if total>=`thres' & t>=`time' & t<=`end', absorb (dyad t )  vce(cluster dyad) d
	outreg2 using "$tables\TS2.2.xls", nocons ctitle(PPML) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, Y, Source x Time FE, N, Destination x Time FE, N, Blocs, Wider, Sample, No CN)
ppmlhdfe n l.n postwar##i.linksipd2 if total>=`thres' & t>=`time' & t<=`end', absorb (dyad t#destinationifs t#sourceifs)  vce(cluster dyad) d
	outreg2 using "$tables\TS2.2.xls", nocons ctitle(PPML) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, -, Source x Time FE, Y, Destination x Time FE, Y, Blocs, Wider, Sample, No CN)

restore
