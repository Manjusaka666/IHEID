
** Figure 1, LHS **
import excel "$input\GGPT_tables.xlsx", sheet("dataF1L") firstrow clear
drop y

cap drop upper
generate upper = 50
local cw upper year if inrange(year, 1947, 1990), bcolor(gs14%30) base(0)
local ww upper year if inrange(year, 1939, 1945), bcolor(emidblue%20) base(0)

			twoway (bar `cw' ) (bar `ww' )  ///
					(line Totaltrade year if year>=1920, lcolor(blue) ///
					lpattern(solid) lwidth(medthick)) /// 
					(line betweenCW year if year>=1920, yaxis(2) lwidth(medthick) lcolor(red) lp(solid )), xsize(6) ///
					legend(off) ///
					title(" ", color(black) size(medsmall)) ///
					ytitle(" ", size(medsmall)) ///
					ytitle(" ", size(medsmall) axis(2)) ///
					xtitle(" ", size(medsmall)) ///
					xlabel(1920(10)2010 2023, angle(0) labsize(small)) ///
					ylabel(0(10)50, angle(0) labsize(small) format(%9.0f)) ///
					ylabel(0(4)24, angle(0) labsize(small) format(%9.0f) axis(2)) ///
					graphregion(color(white)) plotregion(color(white))  bgcolor(white) ///
					text(29 1975 "Global goods trade" "(% GDP, left axis)", size(small) place(w)  color(blue)) ///
					text(6 1988 "Goods trade between Cold War blocs" "(% total trade, right axis)", size(small) place(c)  color(red)) ///
					text(45 1938.5 "WW2", size(small) place(e)) ///
					text(45 1960 "Cold War", size(small) place(e))
				graph export "$charts/F1L.png", as(png) replace


** Figure 1, RHS **
import excel "$input\GGPT_tables.xlsx", sheet("dataF1R") firstrow clear

graph bar trade, over(type) xsize(4) ///
		bar(1, lc(black) lw(thin) c(midblue%90)) ///
		ylabel(, angle(0) labsize(small) format(%9.1f)) ///
		ytitle("Change in trade growth (percentage points)", size(medsmall)) 
	graph export "$charts/F1R.png", as(png) replace