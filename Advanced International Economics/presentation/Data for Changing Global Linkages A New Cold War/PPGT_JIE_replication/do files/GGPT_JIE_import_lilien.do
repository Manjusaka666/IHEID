
use "$input\lilien_imports.dta", replace
cap drop post2020
gen post2021 = (year>=2021)
gen post2022 = (year>=2022)
cap drop d2013_2019
gen d2013_2020 = (year>=2013 & year<=2020)
gen d2013_2021 = (year>=2013 & year<=2021)
gen all = 1
gen d2000_2007 = (year<2007)
gen wbl = (bloc3ipd==1)
gen nwbl = (bloc3ipd!=1)
gen w2bl = (bloc3iea==1)
gen nw2bl = (bloc3iea!=1)


** Figure 2, Panel A **

lab var year y
	
xi: reghdfe ktotal_imports_MLI ib2017.y , absorb(ifs_rpt) cluster(ifs_rpt)

coefplot, drop (_cons) vert graphregion(color(white)) bgcolor(white) ms(Oh) mc(dknavy) ci(90) ///
	ytitle("Estimated coefficient of the MLI (by year, imports)", size(small)) ylabel(, labsize(small) angle(0)) ///
	xtitle("", size(small)) xlabel( ,labsize(vsmall) angle(90)) title(" ", span size(medlarge)) ///
	legend(off) yline(0, lc(red)) xline(16.5, lc(black) lp(dash)) xline(20.5, lc(black) lp(dash)) ///
	rename(^.*([1-2][0-9][0-9][0-9])\.year\#c\.between$ = \1, regex)
	graph export "$charts\F2L.png", as(png) replace	
	
	
** Table S2.1, Panel A **

	gen str varlabel = ""
	replace varlabel = "2000-2007" if _n==1
	replace varlabel = "2008-2012" if _n==2
	replace varlabel = "2013-2021" if _n==3
	replace varlabel = "2022-2023" if _n==4
	
xi: reghdfe ktotal_imports_MLI d2008_2012 d2013_2021 post2022, absorb(ifs_rpt) cluster(ifs_rpt)
	outreg2 using "$tables\T_S2.1_panelA.xls", nocons ctitle(All) bdec(4) tdec(4) se excel label replace addtext(Country FE, Y)
xi: reghdfe ktotal_imports_MLI d2008_2012 d2013_2021 post2022 if ae==1, absorb(ifs_rpt) cluster(ifs_rpt)
	outreg2 using "$tables\T_S2.1_panelA.xls", nocons ctitle(AEs) bdec(4) tdec(4) se excel label append addtext(Country FE, Y)
xi: reghdfe ktotal_imports_MLI d2008_2012 d2013_2021 post2022 if emde==1, absorb(ifs_rpt) cluster(ifs_rpt)
	outreg2 using "$tables\T_S2.1_panelA.xls", nocons ctitle(EMDEs) bdec(4) tdec(4) se excel label append addtext(Country FE, Y)
xi: reghdfe ktotal_imports_MLI d2008_2012 d2013_2021 post2022 if w2bl==1, absorb(ifs_rpt) cluster(ifs_rpt)
	outreg2 using "$tables\T_S2.1_panelA.xls", nocons ctitle(US bloc) bdec(4) tdec(4) se excel label append addtext(Country FE, Y)
xi: reghdfe ktotal_imports_MLI d2008_2012 d2013_2021 post2022 if nw2bl==1, absorb(ifs_rpt) cluster(ifs_rpt)
	outreg2 using "$tables\T_S2.1_panelA.xls", nocons ctitle(Others) bdec(4) tdec(4) se excel label append addtext(Country FE, Y)
