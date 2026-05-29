
use "$input\database_CPIS_1024.dta", clear

	** assign countries to blocs **	

	rename ifscode ifscode_rpt
	merge m:1 ifscode_rpt using "$input\blocs.dta", keepusing(bloc3ipd bloc3iea)
		rename bloc3iea source_bloc3iea
		rename bloc3ipd source_bloc3ipd
		keep if _m==3
		drop _m
		rename ifscode_rpt ifscode_source
	rename partnercode ifscode_rpt
	merge m:1 ifscode_rpt using "$input\blocs.dta", keepusing(bloc3ipd bloc3iea)
		rename bloc3iea destination_bloc3iea
		rename bloc3ipd destination_bloc3ipd
		keep if _m==3
		drop _m
	rename ifscode_rpt ifscode_destination

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

egen dyad = group(ifscode_destination ifscode_source)
gen t = yh(year, half_year)
format t %th
 
tsset dyad t
fillin dyad t

rename I_A_D_T_T_BP6_USD debt
rename I_A_E_T_T_BP6_USD equity
rename I_A_T_T_T_BP6_USD total 
replace equity = equity/1000000000
replace debt = debt/1000000000

foreach x of varlist debt equity total {
	replace `x' = 0 if `x'==.
	replace `x' = 0 if `x'<0
	bysort ifscode_source t: egen `x'_tot = sum(`x')
	gen `x'_share = 100*`x'/`x'_tot
	replace `x'_share = 0 if `x'_tot==0
	tsset dyad t
	gen d`x'_share = (`x'_share-l.`x'_share)
	gen dh`x'_share = ((`x'_share-l.`x'_share)/(.5*`x'_share+.5*l.`x'_share))
	replace dh`x'_share = 0 if (.5*`x'_share+.5*l.`x'_share)==0
	}
	
bysort dyad: egen linksiea2 = mean(linksiea)
bysort dyad: egen linksipd2 = mean(linksipd)

gen postwar = 0
replace postwar=1 if t>=124

gen between_iea = 0
replace between_iea = 1 if linksiea2==2
replace between_iea = . if linksiea2==.

gen between_ipd = 0
replace between_ipd = 1 if linksipd2==2
replace between_ipd = . if linksipd2==.

gen nonaligned_ipd = 0
replace nonaligned_ipd = 1 if linksipd2==3
replace nonaligned_ipd = . if linksipd2==.

bysort dyad: egen sourceifs = max(ifscode_source)
bysort dyad: egen destinationifs = max(ifscode_destination)


** Table 1, columns 5-6 **

preserve 
local time 100

local inst total /*debt equity*/

foreach in of local inst { 
local append replace

	reghdfe d`in'_share l.`in'_share postwar##i.linksipd2 if t>=`time', absorb (dyad t ) cluster(dyad)
		outreg2 using "$tables\T1.xls", nocons ctitle(OLS D) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, Y, Source x Time FE, N, Destination x Time FE, N, Blocs, Wider)
	reghdfe d`in'_share l.`in'_share postwar##i.linksipd2 if t>=`time', absorb (dyad t#destinationifs t#sourceifs) cluster(dyad)
		outreg2 using "$tables\T1.xls", nocons ctitle(OLS D) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, -, Source x Time FE, Y, Destination x Time FE, Y, Blocs, Wider)
		
	reghdfe d`in'_share l.`in'_share postwar##i.linksiea2 if  t>=`time', absorb (dyad t ) cluster(dyad)
		outreg2 using "$tables\T1.xls", nocons ctitle(OLS D) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, Y, Source x Time FE, N, Destination x Time FE, N, Blocs, Narrow)	
	reghdfe d`in'_share l.`in'_share postwar##i.linksiea2 if t>=`time', absorb (dyad t#destinationifs t#sourceifs) cluster(dyad)
		outreg2 using "$tables\T1.xls", nocons ctitle(OLS D) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, -, Source x Time FE, Y, Destination x Time FE, Y, Blocs, Narrow)
		
}
	restore


** Table S2.2, Columns 5-6 **

preserve 
local time 100

drop if sourceifs==111 | destinationifs==111

local inst total

foreach in of local inst { 
local append replace

	reghdfe d`in'_share l.`in'_share postwar##i.linksipd2 if t>=`time', absorb (dyad t ) cluster(dyad)
		outreg2 using "$tables\TS2.2.xls", nocons ctitle(OLS D) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, Y, Source x Time FE, N, Destination x Time FE, N, Blocs, Wider, Sample, No US)
	reghdfe d`in'_share l.`in'_share postwar##i.linksipd2 if t>=`time', absorb (dyad t#destinationifs t#sourceifs) cluster(dyad)
		outreg2 using "$tables\TS2.2.xls", nocons ctitle(OLS D) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, -, Source x Time FE, Y, Destination x Time FE, Y, Blocs, Wider, Sample, No US)

}
	restore	
	
preserve 
local time 100

drop if sourceifs==924 | destinationifs==924

local inst total

foreach in of local inst { 
local append replace

	reghdfe d`in'_share l.`in'_share postwar##i.linksipd2 if t>=`time', absorb (dyad t ) cluster(dyad)
		outreg2 using "$tables\TS2.2.xls", nocons ctitle(OLS D) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, Y, Source x Time FE, N, Destination x Time FE, N, Blocs, Wider, Sample, No CN)
	reghdfe d`in'_share l.`in'_share postwar##i.linksipd2 if t>=`time', absorb (dyad t#destinationifs t#sourceifs) cluster(dyad)
		outreg2 using "$tables\TS2.2.xls", nocons ctitle(OLS D) bdec(4) tdec(4) se excel label append addtext(Country-pair FE, Y, Time FE, -, Source x Time FE, Y, Destination x Time FE, Y, Blocs, Wider, Sample, No CN)

}
	restore	
	
