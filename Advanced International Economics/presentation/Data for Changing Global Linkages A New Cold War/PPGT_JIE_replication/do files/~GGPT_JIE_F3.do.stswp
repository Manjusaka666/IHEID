
** To get the underlying data, look at "GGPT_JIE_trade_now.do" and "GGPT_JIE_trade_coldwar" **

** Figure 3, panel A **

import excel "$input\GGPT_tables.xlsx", sheet("dataF3A") firstrow clear
gen Zero = 0
drop if t>36

gen l_tw = b_tw - 1.645*se_tw
gen h_tw = b_tw + 1.645*se_tw
gen l_cw = b_cw - 1.645*se_cw
gen h_cw = b_cw + 1.645*se_cw

			twoway ///
					(rarea l_tw h_tw t if t>=0,  ///
					fcolor(cranberry%20) lcolor(gs13) lw(none) lpattern(solid)) ///
					(rarea l_cw h_cw t if t>=0,  ///
					fcolor(eltblue%20) lcolor(gs13) lw(none) lpattern(solid)) ///
					(line b_tw t if t>=0, lcolor(cranberry) ///
					lpattern(solid) lwidth(thick)) /// 
					(line b_cw t if t>=0, lcolor(blue) ///
					lpattern(solid) lwidth(thick)) /// 
					(line Zero t, lcolor(black)), xsize(6) ///
					legend(order(3 4)  lab(3 "Post Russia's invasion of Ukraine") lab(4 "Cold War (initial year: 1947)") size(small) row(4) region(lstyle(none) fcolor(none)) pos(1) ring(0)) ///
					title(" ", color(black) size(medsmall)) ///
					ytitle("Trade semi-elasticity for flows between blocs", size(medsmall)) ///
					xtitle("Number of quarters since the start of the episode", size(medsmall)) ///
					xlabel(0(4)36, angle(0) labsize(small)) ylabel(, angle(0) labsize(small) format(%9.1f)) ///
					graphregion(color(white)) plotregion(color(white))  bgcolor(white)
				graph export "$charts/F3A.png", as(png) replace
				
** Figure 3, panel B **

import excel "$input\GGPT_tables.xlsx", sheet("dataF3B") firstrow clear
gen Zero = 0
drop if t>36

gen l_tw = b_tw - 1.645*se_tw
gen h_tw = b_tw + 1.645*se_tw
gen l_cw = b_cw - 1.645*se_cw
gen h_cw = b_cw + 1.645*se_cw
				
			twoway ///
					(rarea l_tw h_tw t if t>=0,  ///
					fcolor(cranberry%20) lcolor(gs13) lw(none) lpattern(solid)) ///
					(rarea l_cw h_cw t if t>=0,  ///
					fcolor(eltblue%20) lcolor(gs13) lw(none) lpattern(solid)) ///
					(line b_tw t if t>=0, lcolor(cranberry) ///
					lpattern(solid) lwidth(thick)) /// 
					(line b_cw t if t>=0, lcolor(blue) ///
					lpattern(solid) lwidth(thick)) /// 
					(line Zero t, lcolor(black)), xsize(6) ///
					legend(order(3 4)  lab(3 "Post Russia's invasion of Ukraine") lab(4 "Cold War (initial year: 1947)") size(small) row(4) region(lstyle(none) fcolor(none)) pos(7) ring(0)) ///
					title(" ", color(black) size(medsmall)) ///
					ytitle("Trade semi-elasticity for flows with nonaligned", size(medsmall)) ///
					xtitle("Number of quarters since the start of the episode", size(medsmall)) ///
					xlabel(0(4)36, angle(0) labsize(small)) ylabel(, angle(0) labsize(small) format(%9.1f)) ///
					graphregion(color(white)) plotregion(color(white))  bgcolor(white)
				graph export "$charts/F3B.png", as(png) replace
			
********************************************************************************
