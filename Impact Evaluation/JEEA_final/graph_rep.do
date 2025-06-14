cd "C:/Users/purga/Desktop/JEEA_final"

clear 

clear frames 
*clear all

* Create frames for each dataset
frame create eme_rep
frame create interwar_rep

* Load datasets into respective frames
frame eme_rep: use "EMEs_rep.dta", clear
frame interwar_rep: use "Interwar_rep.dta", clear

*---------------------------------------------
* Process EMEs dataset
*---------------------------------------------
frame eme_rep {
    xtset codeid year
    xi i.code

    xtreg EME_real_pc_growth _Icode_* if EME_alldefaulter==1 & EME_period==1, robust
    predict residgrowth_EMEdef, ue
    label var residgrowth_EMEdef "Residual growth: EME defaulters"

    xtreg EME_real_pc_growth _Icode_* if Brady_treat==1 & EME_period==1, robust
    predict residgrowth_brady, ue
    label var residgrowth_brady "Residual growth: Brady treatment"

    xtreg EME_real_pc_growth _Icode_* if Baker_treat==1 & EME_period==1, robust
    predict residgrowth_baker, ue
    label var residgrowth_baker "Residual growth: Baker treatment"

    xtreg EME_real_pc_growth _Icode_* if EME_counterfactual==1 & EME_period==1, cluster(codeid)
    predict residgrowth_countEME, ue
    label var residgrowth_countEME "Residual growth: Counterfactual"

    * Tabulate summary statistics for Figures 3-6
    preserve
    keep if ExYugo==0
    quietly {
        tabstat EMEGDP_index, by(Deal_index) stat(mean sd count median p75 p25)
        tabstat EME_real_pc_growth, by(Deal_index) stat(mean sd count)
        tabstat residgrowth_EMEdef, by(Deal_index) stat(mean sd count)
        tabstat EMErating_index, by(Deal_index) stat(mean sd count median p75 p25)
        tabstat DebtServTotal_GDP, by(Deal_index) stat(mean sd count median p75 p25)
        tabstat debt_gdpAbbas, by(Deal_index) stat(mean sd count median p75 p25)
    }
    restore

    * Example plotting of EME GDP index
    /* twoway (line EMEGDP_index Deal_index if ExYugo==0, sort), ///
        name(eme_gdp, replace) title("EME GDP around restructuring") ///
        xtitle("Years since final restructuring") ///
        ytitle("GDP Index (base=1)") */
    preserve
    keep if ExYugo==0
    collapse (mean) EMEGDP_index_mean=EMEGDP_index, by(Deal_index)
    gen data_source = "EMEs"
    rename Deal_index time_index
    tempfile eme_fig3
    save `eme_fig3'
    restore

    * Extract Figure 4 data: Rating Index
    preserve
    keep if ExYugo==0
    collapse (mean) EMErating_index_mean=EMErating_index, by(Deal_index)
    gen data_source = "EMEs"
    rename Deal_index time_index
    tempfile eme_fig4
    save `eme_fig4'
    restore

    * Extract Figure 5 data: Debt Service to GDP
    preserve
    keep if ExYugo==0
    collapse (mean) DebtServTotal_GDP_mean=DebtServTotal_GDP, by(Deal_index)
    gen data_source = "EMEs"
    rename Deal_index time_index
    tempfile eme_fig5
    save `eme_fig5'
    restore

* Extract Figure 6 data: Debt to GDP
    preserve
    keep if ExYugo==0
    collapse (mean) debt_gdpAbbas_mean=debt_gdpAbbas, by(Deal_index)
    gen data_source = "EMEs"
    rename Deal_index time_index
    tempfile eme_fig6
    save `eme_fig6'
    restore    
}

*---------------------------------------------
* Process Interwar dataset
*---------------------------------------------
frame interwar_rep {
    xtset codeid year
    xi i.code

    xtreg growth_gdp_pc_real_Maddison_TED _Icode_* if WarDefaulters==1, robust
    predict residgrowth_def, ue
    label var residgrowth_def "Residual growth: War defaulters"

    xtreg growth_gdp_pc_real_Maddison_TED _Icode_* if Nodefault_Europe==1, cluster(codeid)
    predict residgrowth_counter, ue
    label var residgrowth_counter "Residual growth: European counterfactual"

    * Tabulate summary statistics for Figures 3-6
    preserve
    keep if WarDefaulters==1
    quietly {
        tabstat GDP1934_index, by(y1934_index) stat(mean sd count median p75 p25)
        tabstat Rating1934_index, by(y1934_index) stat(mean sd count median p75 p25)
        tabstat debtservGDP_interwar, by(y1934_index) stat(mean sd count median p75 p25)
        tabstat debt_gdpAbbas, by(y1934_index) stat(mean sd count median p75 p25)
    }
    restore

    /* * Example plotting of Interwar GDP index
    twoway (line GDP1934_index y1934_index if WarDefaulters==1, sort), ///
        name(interwar_gdp, replace) title("Interwar GDP around 1934 defaults") ///
        xtitle("Years since 1934 default") ///
        ytitle("GDP Index (base=1)") */
    * Extract Figure 3 data: GDP Index
    preserve
    keep if WarDefaulters==1
    collapse (mean) GDP1934_index_mean=GDP1934_index, by(y1934_index)
    gen data_source = "Interwar"
    rename y1934_index time_index
    tempfile interwar_fig3
    save `interwar_fig3'
    restore

    * Extract Figure 4 data: Rating Index
    preserve
    keep if WarDefaulters==1
    collapse (mean) Rating1934_index_mean=Rating1934_index, by(y1934_index)
    gen data_source = "Interwar"
    rename y1934_index time_index
    tempfile interwar_fig4
    save `interwar_fig4'
    restore

    * Extract Figure 5 data: Debt Service to GDP
    preserve
    keep if WarDefaulters==1
    collapse (mean) debtservGDP_interwar_mean=debtservGDP_interwar, by(y1934_index)
    gen data_source = "Interwar"
    rename y1934_index time_index
    tempfile interwar_fig5
    save `interwar_fig5'
    restore

    * Extract Figure 6 data: Debt to GDP
    preserve
    keep if WarDefaulters==1
    collapse (mean) debt_gdpAbbas_mean=debt_gdpAbbas, by(y1934_index)
    gen data_source = "Interwar"
    rename y1934_index time_index
    tempfile interwar_fig6
    save `interwar_fig6'
    restore
}

*---------------------------------------------
* Create Figure 3: GDP Index Comparison
*---------------------------------------------
clear
use `interwar_fig3'
append using `eme_fig3'

* Standardize variable names
gen gdp_mean = GDP1934_index_mean if data_source == "Interwar"
replace gdp_mean = EMEGDP_index_mean if data_source == "EMEs"

twoway (connected gdp_mean time_index if data_source=="Interwar", ///
        lcolor(blue) mcolor(blue) msymbol(circle) lwidth(small)) ///
       (connected gdp_mean time_index if data_source=="EMEs", ///
        lcolor(red) mcolor(red) msymbol(triangle) lwidth(small)), ///
       xlabel(-5(1)5) ylabel(, format(%9.2f)) ///
       legend(label(1 "1934 Default") label(2 "EME(Final Reconstruction)") ///
              position(6) rows(1)) ///
       title("Figure 3: GDP") ///
       xtitle("Relative to T") ytitle("GDP Index") ///
       scheme(s2color8) graphregion(color(white)) plotregion(color(white))

graph export "Figure3_GDP_Comparison.png", replace width(800) height(600)

*---------------------------------------------
* Create Figure 4: Credit Rating Index Comparison
*---------------------------------------------
clear
use `interwar_fig4'
append using `eme_fig4'

* Standardize variable names
gen rating_mean = Rating1934_index_mean if data_source == "Interwar"
replace rating_mean = EMErating_index_mean if data_source == "EMEs"

twoway (connected rating_mean time_index if data_source=="Interwar", ///
        lcolor(blue) mcolor(blue) msymbol(circle) lwidth(small)) ///
       (connected rating_mean time_index if data_source=="EMEs", ///
        lcolor(red) mcolor(red) msymbol(triangle) lwidth(small)), ///
       xlabel(-5(1)5) ylabel(, format(%9.2f)) ///
       legend(label(1 "1934 Default") label(2 "EME(Final Reconstruction)") ///
              position(6) rows(1)) ///
       title("Figure 4: Moody's Rating Index") ///
       xtitle("Relative to T") ytitle("Rating Index") ///
       scheme(s2color8) graphregion(color(white)) plotregion(color(white))

graph export "Figure4_Rating_Comparison.png", replace width(800) height(600)

*---------------------------------------------
* Create Figure 5: Debt Service to GDP Comparison
*---------------------------------------------
clear
use `interwar_fig5'
append using `eme_fig5'

* Standardize variable names
gen debtserv_mean = debtservGDP_interwar_mean if data_source == "Interwar"
replace debtserv_mean = DebtServTotal_GDP_mean if data_source == "EMEs"

twoway (connected debtserv_mean time_index if data_source=="Interwar", ///
        lcolor(blue) mcolor(blue) msymbol(circle) lwidth(small)) ///
       (connected debtserv_mean time_index if data_source=="EMEs", ///
        lcolor(red) mcolor(red) msymbol(triangle) lwidth(small)), ///
       xlabel(-5(1)5) ylabel(, format(%9.2f)) ///
       legend(label(1 "1934 Default") label(2 "EME(Final Reconstruction)") ///
              position(6) rows(1)) ///
       title("Figure 5: Debt Service") ///
       xtitle("Relative to T") ytitle("Debt service to GDP (%)") ///
       scheme(s2color8) graphregion(color(white)) plotregion(color(white))

graph export "Figure5_DebtService_Comparison.png", replace width(800) height(600)

*---------------------------------------------
* Create Figure 6: Debt to GDP Comparison
*---------------------------------------------
clear
use `interwar_fig6'
append using `eme_fig6'

* Standardize variable names
gen debt_mean = debt_gdpAbbas_mean

twoway (connected debt_mean time_index if data_source=="Interwar", ///
        lcolor(blue) mcolor(blue) msymbol(circle) lwidth(small)) ///
       (connected debt_mean time_index if data_source=="EMEs", ///
        lcolor(red) mcolor(red) msymbol(triangle) lwidth(small)), ///
       xlabel(-5(1)5) ylabel(, format(%9.2f)) ///
       legend(label(1 "1934 Default") label(2 "EME(Final Reconstruction)") ///
              position(6) rows(1)) ///
       title("Figure 6: Debt Amount") ///
       xtitle("Relative to T") ytitle("Debt to GDP (%)") ///
       scheme(s2color8) graphregion(color(white)) plotregion(color(white))

graph export "Figure6_DebtStock_Comparison.png", replace width(800) height(600)




*---------------------------------------------
* Create Figure 8
*---------------------------------------------

use "Interwar_rep.dta", clear
*GDP (normalized to 1 in 1934) --- Right Panel of Figure 8
*Treatment Group (Defaulters):
tabstat GDP1934_index if WarDefaulters==1, by (y1934_index) stat(mean sd count)
*** Control Group:
/*Europe*/ tabstat GDP1934_index if Nodefault_Europe==1, by (y1934_index) stat(mean sd count)
/*World*/ tabstat GDP1934_index if WarCounterfact_all==1, by (y1934_index) stat(mean sd count)

*** 1931 Hoover Moratorium
	*******************************************
*** Difference in Difference Analysis 1931 --- Figure 8 and Figure C.5 in the Appendix
*** Treatment vs Control Group
		
*GDP (normalized to 1 in 1931) --- Left Panel of Figure 8
*Treatment Group (Defaulters):
tabstat GDP1931_index if WarDefaulters==1, by (y1931_index) stat(mean sd count)
*Control Group (European Non-Defaulters):
tabstat GDP1931_index if Nodefault_Europe==1, by (y1931_index) stat(mean sd count)

preserve
collapse (mean) GDP1931_index_treat=GDP1931_index if WarDefaulters==1, by(y1931_index)
gen group = "Treatment"
gen event_year = "1931"
rename y1931_index time_index
rename GDP1931_index_treat gdp_mean
tempfile fig8_left_treat
save `fig8_left_treat'
restore

preserve
collapse (mean) GDP1931_index_control=GDP1931_index if Nodefault_Europe==1, by(y1931_index)
gen group = "Control"
gen event_year = "1931"
rename y1931_index time_index
rename GDP1931_index_control gdp_mean
tempfile fig8_left_control
save `fig8_left_control'
restore

preserve
collapse (mean) GDP1934_index_treat=GDP1934_index if WarDefaulters==1, by(y1934_index)
gen group = "Treatment"
gen event_year = "1934"
rename y1934_index time_index
rename GDP1934_index_treat gdp_mean
tempfile fig8_right_treat
save `fig8_right_treat'
restore

preserve
collapse (mean) GDP1934_index_control=GDP1934_index if Nodefault_Europe==1, by(y1934_index)
gen group = "Control"
gen event_year = "1934"
rename y1934_index time_index
rename GDP1934_index_control gdp_mean
tempfile fig8_right_control
save `fig8_right_control'
restore

* Combine all data for Figure 8
clear
use `fig8_left_treat'
append using `fig8_left_control'
append using `fig8_right_treat'
append using `fig8_right_control'

* Create Figure 8 Left Panel: 1931 Hoover Moratorium
preserve
keep if event_year == "1931"

twoway (connected gdp_mean time_index if group=="Treatment", ///
        lcolor(blue) mcolor(blue) msymbol(circle) lwidth(small)) ///
       (connected gdp_mean time_index if group=="Control", ///
        lcolor(red) mcolor(red) msymbol(triangle) lwidth(small)), ///
       xlabel(-5(1)5) ylabel(0.8(0.1)1.2, format(%9.1f)) ///
       legend(label(1 "Avg Defaulters") label(2 "Avg Counterfactual") ///
              position(6) rows(1)) ///
       title("Left Panel: 1931 Hoover Moratorium") ///
       xtitle("Years relative to 1931") ///
       scheme(s2color8) graphregion(color(white)) plotregion(color(white)) ///
       name(fig8_left, replace)

restore

* Create Figure 8 Right Panel: 1934 Summer Defaults
preserve
keep if event_year == "1934"

twoway (connected gdp_mean time_index if group=="Treatment", ///
        lcolor(blue) mcolor(blue) msymbol(circle) lwidth(small)) ///
       (connected gdp_mean time_index if group=="Control", ///
        lcolor(red) mcolor(red) msymbol(triangle) lwidth(small)), ///
       xlabel(-5(1)5) ylabel(0.8(0.1)1.2, format(%9.1f)) ///
       legend(label(1 "Avg Defaulters") label(2 "Avg Counterfactual") ///
              position(6) rows(1)) ///
       title("Right Panel: 1934 Summer Defaults") ///
       xtitle("Years relative to 1934") ///
       scheme(s2color8) graphregion(color(white)) plotregion(color(white)) ///
       name(fig8_right, replace)

restore

* Combine both panels into Figure 8
graph combine fig8_left fig8_right, ///
       cols(2) rows(1) ///
       title("Figure 8: GDP trends around 1931 and 1934", size(large)) ///
       note("Note: GDP normalized to 1 in event year. Treatment group: War debt defaulters. Control group: European non-defaulters.") ///
       scheme(s2color8) graphregion(color(white)) ///
       name(figure8_combined, replace)

graph export "Figure8_GDP_trends_1931_1934.png", replace width(1200) height(600)



*---------------------------------------------
* Create Figure C.5
*---------------------------------------------

use "Interwar_rep.dta", clear
xtset codeid year
			xi i.code
			
			* War Defaulters
			xtreg growth_gdp_pc_real_Maddison_TED _Icode_* if WarDefaulters==1, robust
			predict residgrowth_def, ue
			label var residgrowth_def residgrowth_def
			
			* European counterfactual of non-defaulters
			xtreg growth_gdp_pc_real_Maddison_TED _Icode_* if Nodefault_Europe==1, cluster(codeid)
			predict residgrowth_counter, ue
			label var residgrowth_counter residgrowth_counter
*GDP (normalized to 1 in 1931) --- Left Panel of Figure 8
*Treatment Group (Defaulters):
tabstat GDP1931_index if WarDefaulters==1, by (y1931_index) stat(mean sd count)
*Control Group (European Non-Defaulters):
tabstat GDP1931_index if Nodefault_Europe==1, by (y1931_index) stat(mean sd count)

*Residual growth rates 
*Treatment Group (Defaulters):
tabstat residgrowth_def if WarDefaulters==1, by (y1931_index) stat(mean sd count)
*Control Group (European Non-Defaulters):
tabstat residgrowth_counter if Nodefault_Europe==1, by (y1931_index) stat(mean sd count)

**Ratings
*Treatment Group (Defaulters):
tabstat Rating1931_index if WarDefaulters==1, by (y1931_index) stat(mean sd count)
*Control Group (European Non-Defaulters):
tabstat Rating1931_index if Nodefault_Europe==1, by (y1931_index) stat(mean sd count)
		
**Debt Service to Revenue
*Treatment Group (Defaulters):
tabstat debtservRevenue_interwar if WarDefaulters==1, by (y1931_index) stat(mean sd count)
*Control Group (European Non-Defaulters):
tabstat debtservRevenue_interwar if Nodefault_Europe==1, by (y1931_index) stat(mean sd count)

** Debt to GDP
tabstat debt_gdpAbbas if WarDefaulters==1, by (y1931_index) stat(mean sd count)
*Control Group (European Non-Defaulters):
tabstat debt_gdpAbbas if Nodefault_Europe==1, by (y1931_index) stat(mean sd count)
		
// *---------------------------------------------
// * Panel 1: GDP Index (1931=1)
// *---------------------------------------------
// preserve
// collapse (mean) GDP1931_index_treat=GDP1931_index if WarDefaulters==1, by(y1931_index)
// gen group = "Treatment"
// gen panel = "A. GDP Index"
// rename y1931_index time_index
// rename GDP1931_index_treat value_mean
// tempfile figc5_gdp_treat
// save `figc5_gdp_treat'
// restore
//
// preserve
// collapse (mean) GDP1931_index_control=GDP1931_index if Nodefault_Europe==1, by(y1931_index)
// gen group = "Control"
// gen panel = "A. GDP Index"
// rename y1931_index time_index
// rename GDP1931_index_control value_mean
// tempfile figc5_gdp_control
// save `figc5_gdp_control'
// restore

*---------------------------------------------
* Panel 1: Residual Growth Rates
*---------------------------------------------
preserve
collapse (mean) residgrowth_def_treat=residgrowth_def if WarDefaulters==1, by(y1931_index)
gen group = "Treatment"
gen panel = "A. Residual Growth"
rename y1931_index time_index
rename residgrowth_def_treat value_mean
tempfile figc5_resid_treat
save `figc5_resid_treat'
restore

preserve
collapse (mean) residgrowth_counter_control=residgrowth_counter if Nodefault_Europe==1, by(y1931_index)
gen group = "Control"
gen panel = "A. Residual Growth"
rename y1931_index time_index
rename residgrowth_counter_control value_mean
tempfile figc5_resid_control
save `figc5_resid_control'
restore

*---------------------------------------------
* Panel 2: Ratings Index (1931=1)
*---------------------------------------------
preserve
collapse (mean) Rating1931_index_treat=Rating1931_index if WarDefaulters==1, by(y1931_index)
gen group = "Treatment"
gen panel = "B. Rating Index"
rename y1931_index time_index
rename Rating1931_index_treat value_mean
tempfile figc5_rating_treat
save `figc5_rating_treat'
restore

preserve
collapse (mean) Rating1931_index_control=Rating1931_index if Nodefault_Europe==1, by(y1931_index)
gen group = "Control"
gen panel = "B. Rating Index"
rename y1931_index time_index
rename Rating1931_index_control value_mean
tempfile figc5_rating_control
save `figc5_rating_control'
restore

*---------------------------------------------
* Panel 3: Debt Service to Revenue
*---------------------------------------------
preserve
collapse (mean) debtservRevenue_treat=debtservRevenue_interwar if WarDefaulters==1, by(y1931_index)
gen group = "Treatment"
gen panel = "C. Debt Service to Revenue"
rename y1931_index time_index
rename debtservRevenue_treat value_mean
tempfile figc5_debtserv_treat
save `figc5_debtserv_treat'
restore

preserve
collapse (mean) debtservRevenue_control=debtservRevenue_interwar if Nodefault_Europe==1, by(y1931_index)
gen group = "Control"
gen panel = "C. Debt Service to Revenue"
rename y1931_index time_index
rename debtservRevenue_control value_mean
tempfile figc5_debtserv_control
save `figc5_debtserv_control'
restore

*---------------------------------------------
* Panel 4: Debt to GDP
*---------------------------------------------
preserve
collapse (mean) debt_gdpAbbas_treat=debt_gdpAbbas if WarDefaulters==1, by(y1931_index)
gen group = "Treatment"
gen panel = "D. Debt to GDP"
rename y1931_index time_index
rename debt_gdpAbbas_treat value_mean
tempfile figc5_debtgdp_treat
save `figc5_debtgdp_treat'
restore

preserve
collapse (mean) debt_gdpAbbas_control=debt_gdpAbbas if Nodefault_Europe==1, by(y1931_index)
gen group = "Control"
gen panel = "D. Debt to GDP"
rename y1931_index time_index
rename debt_gdpAbbas_control value_mean
tempfile figc5_debtgdp_control
save `figc5_debtgdp_control'
restore

*---------------------------------------------
* Combine all data for Figure C.5
*---------------------------------------------
clear
use `figc5_resid_treat'
append using `figc5_resid_control'
append using `figc5_rating_treat'
append using `figc5_rating_control'
append using `figc5_debtserv_treat'
append using `figc5_debtserv_control'
append using `figc5_debtgdp_treat'
append using `figc5_debtgdp_control'

* Create individual panel graphs
*---------------------------------------------
* Panel A: GDP Index
*---------------------------------------------
// ...existing code...

*---------------------------------------------
* Create Figure C.5 - Four separate graphs (figc5_a to figc5_d)
*---------------------------------------------

*---------------------------------------------
* Panel D: Debt to GDP
*---------------------------------------------
preserve
keep if panel == "D. Debt to GDP"

twoway (connected value_mean time_index if group=="Treatment", ///
        lcolor(blue) mcolor(blue) msymbol(circle) lwidth(small)) ///
       (connected value_mean time_index if group=="Control", ///
        lcolor(red) mcolor(red) msymbol(triangle) lwidth(small)), ///
       xlabel(-5(1)5) ylabel(0(20)100, format(%9.1f)) ///
       legend(label(1 "Avg Defaulters") label(2 "Avg Counterfactual") ///
              position(6) rows(1)) ///
       title("GDP Index (1931=1)") ///
	   ytitle("") ///
       scheme(s2color8) graphregion(color(white)) plotregion(color(white)) ///
       name(figc5_d, replace)

graph export "figc5_d.png", replace width(1200) height(800)

restore

*---------------------------------------------
* Panel A: Residual Growth
*---------------------------------------------
preserve
keep if panel == "A. Residual Growth"

twoway (connected value_mean time_index if group=="Treatment", ///
        lcolor(blue) mcolor(blue) msymbol(circle) lwidth(small)) ///
       (connected value_mean time_index if group=="Control", ///
        lcolor(red) mcolor(red) msymbol(triangle) lwidth(small)), ///
       xlabel(-5(1)5) ylabel(, format(%9.2f)) ///
       legend(label(1 "Avg Defaulters") label(2 "Avg Counterfactual") ///
              position(6) rows(1)) ///
       title("Residual Growth Rates") ///
	   	   ytitle("") ///
       scheme(s2color8) graphregion(color(white)) plotregion(color(white)) ///
       name(figc5_a, replace)

graph export "figc5_a.png", replace width(1200) height(800)

restore

*---------------------------------------------
* Panel B: Rating Index
*---------------------------------------------
preserve
keep if panel == "B. Rating Index"

twoway (connected value_mean time_index if group=="Treatment", ///
        lcolor(blue) mcolor(blue) msymbol(circle) lwidth(small)) ///
       (connected value_mean time_index if group=="Control", ///
        lcolor(red) mcolor(red) msymbol(triangle) lwidth(small)), ///
       xlabel(-5(1)5) ylabel(0.8(0.1)1.2, format(%9.1f)) ///
       legend(label(1 "Avg Defaulters") label(2 "Avg Counterfactual") ///
              position(6) rows(1)) ///
       title("Credit Rating Index (1931=1)") ///
	   	   ytitle("") ///
       scheme(s2color8) graphregion(color(white)) plotregion(color(white)) ///
       name(figc5_b, replace)
graph export "figc5_b.png", replace width(1200) height(800)

restore

*---------------------------------------------
* Panel C: Debt Service to Revenue
*---------------------------------------------
preserve
keep if panel == "C. Debt Service to Revenue"

twoway (connected value_mean time_index if group=="Treatment", ///
        lcolor(blue) mcolor(blue) msymbol(circle) lwidth(small)) ///
       (connected value_mean time_index if group=="Control", ///
        lcolor(red) mcolor(red) msymbol(triangle) lwidth(small)), ///
       xlabel(-5(1)5) ylabel(, format(%9.1f)) ///
       legend(label(1 "Avg Defaulters") label(2 "Avg Counterfactual") ///
              position(6) rows(1)) ///
       title("Debt Service") ///
	   	   ytitle("") ///
       scheme(s2color8) graphregion(color(white)) plotregion(color(white)) ///
       name(figc5_c, replace)

graph export "figc5_c.png", replace width(1200) height(800)

restore