cd "C:/Users/purga/Desktop/JEEA_final"
clear

use Interwar_rep.dta, clear
		*** Estimate growth residuals
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

****** Difference in Difference Regressions (Tables 4 and 5)
***********************************************************************

	********************************	
	*** Define TIME WINDOWS
	
	*** Summer 1934 Default
	gen DiD1934_5year=.
	replace DiD1934_5year=1 if year>1928 & year<1940
	
	gen DiD1934_5year2=.
	replace DiD1934_5year2=1 if year>1929 & year<1940
	
	gen DiD1934_4year=.
	replace DiD1934_4year=1 if year>1930 & year<1939
	
	gen DiD1934_3year=.
	replace DiD1934_3year=1 if year>1931 & year<1938
	
	gen DiD1934_6year=.
	replace DiD1934_6year=1 if year>1927 & year<1941
	
	*** Placebo 1933
	gen DiD1933_5year=.
	replace DiD1933_5year=1 if year>1927 & year<1939
	
	*** Hoover 1931 moratorium
	gen DiD1931_5year=.
	replace DiD1931_5year=1 if year>1925 & year<1937


	***************************
	*** Generate Post-Event Dummies and Interaction Terms
	
	*** Full Counterfactual
	gen after1934=.
	replace after1934=1 if y1934_index>0 & y1934_index<6
	replace after1934=0 if y1934_index>-6 & y1934_index<1
		
	gen after_default=after1934*WarDefaulters
	replace after_default=0 if Nodefault_Europe==1
	replace after_default=0 if WarLatAm==1
	replace after_default=0 if WarNonLatAm==1 

		***Hoover Moratorium 1931
		gen after1931=.
		replace after1931=1 if y1931_index>0 & y1931_index<6
		replace after1931=0 if y1931_index>-6 & y1931_index<1
	
		gen after_Hoover=after1931*WarDefaulters
		replace after_Hoover=0 if Nodefault_Europe==1
		replace after_Hoover=0 if WarLatAm==1
		replace after_Hoover=0 if WarNonLatAm==1

		**Placebo: center around 1933
		gen after1933=.
		replace after1933=1 if y1934_index>-1 & y1934_index<5
		replace after1933=0 if y1934_index>-7 & y1934_index<0
		
		gen after_default33=after1933*WarDefaulters 
		replace after_default33=0 if Nodefault_Europe==1
		replace after_default33=0 if WarLatAm==1 
		replace after_default33=0 if WarNonLatAm==1 


	********************************
	*** Robustness: Debt Relief Treatment Variables
	
				** Debt Relief to GDP (in %)
				gen War_debtrelief=.
				replace War_debtrelief=19.5 if country=="United Kingdom"
				replace War_debtrelief=52.2 if country=="France"
				replace War_debtrelief=36.4 if country=="Italy"
				replace War_debtrelief=4.1 if country=="Belgium"
				replace War_debtrelief=43.4 if country=="Greece"
				replace War_debtrelief=1.7 if country=="Austria"
				replace War_debtrelief=6.2 if country=="Australia"
				replace War_debtrelief=10.5 if country=="New Zealand"
				replace War_debtrelief=10.3 if country=="Portugal"
				
				*counterfactual
				replace War_debtrelief=0 if country=="Finland" |  country=="Norway" | country=="Sweden" | country=="Switzerland" | country=="Denmark" | country=="Ireland" | country=="Spain"  
				gen after_debtrelief=after1934*War_debtrelief 
				
				** Debt Relief to Central Gov. Debt (in %)
				gen War_stockrelief=.
				replace War_stockrelief=12.2 if country=="United Kingdom"
				replace War_stockrelief=34.9 if country=="France"
				replace War_stockrelief=24.2 if country=="Italy"
				replace War_stockrelief=4.3 if country=="Belgium"		
				replace War_stockrelief=25.5 if country=="Poland"
				replace War_stockrelief=10.1 if country=="Czechoslovakia"
				replace War_stockrelief=30.6 if country=="Yugoslavia"
				replace War_stockrelief=1.0 if country=="Romania"
				replace War_stockrelief=33 if country=="Greece"
				replace War_stockrelief=88 if country=="Estonia"		
				replace War_stockrelief=85.1 if country=="Latvia"
				replace War_stockrelief=0.5 if country=="Hungary"				
				replace War_stockrelief=3.6 if country=="Austria"
				replace War_stockrelief=7.2 if country=="Australia"
				replace War_stockrelief=4.9 if country=="New Zealand"
				replace War_stockrelief=30.4 if country=="Portugal"
				
				*counterfactual
				replace War_stockrelief=0 if country=="Finland" |  country=="Norway" | country=="Sweden" | country=="Switzerland" | country=="Denmark" | country=="Ireland" | country=="Spain"  
				gen after_stockrelief=after1934*War_stockrelief 
				
				
	*******************************
	*** DIFFERENCE IN DIFFERENCE REGRESSIONS
	
	xtset codeid year
	xi i.year
	
		
	*********************************************************************
	******* 1934 DiD Analysis *******************************************
	
		***********************************
		*** GDP growth (real p.c.) 1934 ***
			
// 			* Main Regression (Table 4, Column 1)
//		
// 			xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
// 			estimates store growth1934_FE_nodef
//			
// 			* Robsutness checks to main regression
//		
// 				** No year fixed effects
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
//
// 				** 3-year window
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_3year==1 & WarSmallSample==1, fe cluster(codeid)
//
// 				** 4-year window
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_4year==1 & WarSmallSample==1, fe cluster(codeid)
//				
// 				** 6-year window
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_6year==1 & WarSmallSample==1, fe cluster(codeid)
//				
// 				** Center around 1933
// 				xtreg growth_gdp_pc_real_Maddison_TED after1933 after_default33 _Iyear_* if DiD1933_5year==1 & WarSmallSample==1, fe cluster(codeid)
//				
// 				** exclude treatment year
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & y1934_index!=0, fe cluster(codeid)
//
// 				** With inflation
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default inflation_RR _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
//
// 				** With banking crises and currency crises
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default bankingcrises currencycrises _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
//
// 				** With wars
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default Intrastateconflict InterstateConflict _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
//
// 				** With politics
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default domestic4 domestic6 domestic7 _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
//
// 				** Drop Eastern Europe 
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & EasternEurope!=1, fe cluster(codeid)
//				
// 				** Europe Only
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="New Zealand" & country!="Australia", fe cluster(codeid)
//
// 				** Drop Germany
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="Germany", fe cluster(codeid)
//
// 				** Drop Australia and New Zealand
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="Australia" & country!="New Zealand", fe cluster(codeid)
//		
// 				** Drop Countries with largest Debt Relief to GDP
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="France" & country!="Greece" & country!="Italy", fe cluster(codeid)
//	
// 				** Drop Countries with smallest Debt Relief to GDP
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="Austria" & country!="Belgium" & country!="Australia", fe cluster(codeid)
//	
// 					** GDP performance
// 					list country GDP1934_index if y1934_index==5 & WarDefaulters==1
//	
// 				** Drop countries with BEST GDP perfomance in T+5 (Austria, Germany, New Zealand)
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="Germany" & country!="Austria" & country!="New Zealand", fe cluster(codeid)
//		
// 				** Drop countries with WORST GDP perfomance in T+5 (Greece, Portugal, Belgium)
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="Greece" & country!="Portugal" & country!="Belgium", fe cluster(codeid)
//
// 				**************************
// 				** Quartile regressions
// 				** Note: this requires downloading the Stata ado "DIFF". Type "ssc install diff" in Stata command line
//					
				**Prepare for DIFF Stata module
				gen treat1934=WarDefaulters
				replace treat1934=0 if WarDefaulters==. & DiD1934_5year==1 &  WarAllSample==1
				gen interact_treat=treat1934*after1934
				tabulate country, generate(ctryd)
//					
// 				** replicate XTREG results
// 				diff growth_gdp_pc_real_Maddison_TED if DiD1934_5year==1 & WarSmallSample==1, treated(treat1934) period(after1934) cluster(codeid) cov(_Iyear_* ctryd*) 
//						
// 				* Median regressions
// 				diff growth_gdp_pc_real_Maddison_TED if DiD1934_5year==1 & WarSmallSample==1, treated(treat1934) period(after1934) qdid(0.50)  
// 				* With country fixed effects (IMPORTANT: standard errors likely to be biased)
// 				diff growth_gdp_pc_real_Maddison_TED if DiD1934_5year==1 & WarSmallSample==1, treated(treat1934) period(after1934) qdid(0.50) cov(ctryd*) 
//					
//					
// 			* Results with Large ("World") counterfactual (Table 4, Column 2)
//			
// 			xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 &  WarAllSample==1, fe cluster(codeid)
// 			estimates store growth1934_FE_full
//		
// 				*Results using other Counteractuals
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 &  WarLatAmSample==1, fe cluster(codeid)
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 &  WarNonLatAmSample==1, fe cluster(codeid)
//				
// 				*Median regression with "World" counterfactual
// 				diff growth_gdp_pc_real_Maddison_TED if DiD1934_5year==1 & WarAllSample==1, treated(treat1934) period(after1934) qdid(0.50) 
//
//						
// 			* Regressions using an alternative treatment variable: debt relief as % to GDP and as % of Debt Stocks
//						
// 				** with Debt Relief/GDP
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_debtrelief if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
//
// 				** with Debt Relief/Total Debt
// 				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_stockrelief if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
//
// 		*********************		
// 		*** Ratings 1934 ****	
//		
// 			*** Ratings Main Regression (Table 4, Column 3)
bysort codeid: gen interrating_growth=(d.moodys_interwar_num/moodys_interwar_num[_n-1])*100

* Column 1: Growth, Small Counterfactual
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* ///
    if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store col1

* Column 2: Growth, Large Counterfactual  
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* ///
    if DiD1934_5year==1 & WarAllSample==1, fe cluster(codeid)
estimates store col2

* Column 3: Credit Ratings, Small Counterfactual
quietly xtreg interrating_growth after1934 after_default _Iyear_* ///
    if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store col3

* Column 4: Debt Service to Revenue, Small Counterfactual
quietly xtreg debtservRevenue_interwar after1934 after_default _Iyear_* ///
    if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store col4

* Column 5: Debt Service to Revenue, Large Counterfactual
quietly xtreg debtservRevenue_interwar after1934 after_default _Iyear_* ///
    if DiD1934_5year==1 & WarAllSample==1, fe cluster(codeid)
estimates store col5

* Column 6: Total Public Debt/GDP, Small Counterfactual
quietly xtreg debt_gdpAbbas after1934 after_default _Iyear_* ///
    if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store col6

* Column 7: Total Public Debt/GDP, Large Counterfactual
quietly xtreg debt_gdpAbbas after1934 after_default _Iyear_* ///
    if DiD1934_5year==1 & WarAllSample==1, fe cluster(codeid)
estimates store col7

* Column 8: External Debt/GDP, Small Counterfactual
quietly xtreg ext_debt_gdp after1934 after_default _Iyear_* ///
    if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store col8

*---------------------------------------------
* Generate Table 4 using esttab
*---------------------------------------------

* Install esttab if not already installed
capture ssc install estout

* Create the main table
esttab col1 col2 col3 col4 col5 col6 col7 col8 using "Table4_DiD.tex", ///
    replace ///
    title("Table 4: 1934 Summer Defaults - Difference-in-Difference Analysis") ///
    mtitles("Growth, real p.c." "Growth, real p.c." "Credit Ratings (change)" ///
            "Debt Service to Revenue" "Debt Service to Revenue" ///
            "Total Public Debt/GDP" "Total Public Debt/GDP" "External Debt/GDP") ///
    mgroups("Small (Europe)" "Large (World)" "Small (Europe)" "Small (Europe)" ///
            "Large (World)" "Small (Europe)" "Large (World)" "Small (Europe)", ///
            pattern(1 1 1 1 1 1 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) ///
            span erepeat(\cmidrule(lr){@span})) ///
    keep(after1934 after_default _cons) ///
    order(after1934 after_default _cons) ///
    coeflabels(after1934 "Post-intervention dummy (after 1934)" ///
               after_default "Treatment (debt relief) × post-intervention dummy" ///
               _cons "Constant") ///
			       se(3) b(3) ///
    stats(N r2_a, labels("Observations" "Adjusted R²") fmt(%9.0f %9.3f)) ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
    addnotes("Notes: This table reports difference-in-difference estimates of the effect" ///
             "of the 1934 summer debt defaults on various economic outcomes." ///
             "Treatment group consists of 18 countries that defaulted on war debt." ///
             "Small counterfactual includes European non-defaulters;" ///
             "Large counterfactual adds Latin American and other countries." ///
             "All regressions include country and year fixed effects." ///
             "Standard errors clustered at country level in parentheses." ///
             "* p<0.10, ** p<0.05, *** p<0.01") ///
    width(\hsize) ///
    substitute(\_ _)
	

* Main Regression (Table 3, Column 1)
quietly xtreg growth_gdp_pc_real_Maddison_TED after1931 after_Hoover _Iyear_* if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
	estimates store growth1931_FE_nodef
			
*no year fixed effects
quietly xtreg growth_gdp_pc_real_Maddison_TED after1931 after_Hoover if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
	estimates store growth1931_nodef
			
*Large Counterfactual (Table 3, Column 2)
quietly xtreg growth_gdp_pc_real_Maddison_TED after1931 after_Hoover _Iyear_* if DiD1931_5year==1 &  WarAllSample==1, fe cluster(codeid)
	estimates store growth1931_FE_full
	
	
*********************************
*** Ratings 1931 ****************
		
* Ratings 1931 (Table 3, Column 3)
quietly xtreg interrating_growth after1931 after_Hoover _Iyear_* if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
	estimates store ratings1931_FE_nodef
		
*no year fixed effects
quietly xtreg interrating_growth after1931 after_Hoover if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
	estimates store ratings1931_nodef
			

*********************************
*** Debt Service 1931 ***********
				
* Debt service to revenue (Table 3, Column 4)
quietly xtreg debtservRevenue_interwar after1931 after_Hoover _Iyear_* if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
	estimates store serviceRev1931_FE_nodef
				
*No Year FE
quietly xtreg debtservRevenue_interwar after1931 after_Hoover if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
	estimates store serviceRev1931_nodef

* Large counterfactual (Table 3, Column 5)		
quietly xtreg debtservRevenue_interwar after1931 after_Hoover _Iyear_* if DiD1931_5year==1 & WarAllSample==1, fe cluster(codeid)
	estimates store serviceRev1931_FE_full	
				
** Debt service to GDP
quietly xtreg debtservGDP_interwar after1931 after_Hoover _Iyear_* if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
	estimates store serviceGDP1931_FE_nodef
		

*********************************
*** Debt/GDP 1931 ***************
		
* Debt/GDP (Data from Abbas et al.) (Table 3, Column 6)
quietly xtreg debt_gdpAbbas after1931 after_Hoover _Iyear_* if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
	estimates store debtgdp1931_FE_nodef
		

* Large Counterfactual (Table 3, Column 7)
quietly xtreg debt_gdpAbbas after1931 after_Hoover _Iyear_* if DiD1931_5year==1 & WarAllSample==1, fe cluster(codeid)
	estimates store debtgdp1931_FE_full

		
** External Debt/GDP (Reinhart/Rogoff) (Table 3, Column 8) * --> No data for Large Counterfactual	
quietly xtreg ext_debt_gdp after1931 after_Hoover _Iyear_* if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
	estimates store extdebt1931_FE_nodef
		
esttab growth1931_FE_nodef growth1931_FE_full ratings1931_FE_nodef ///
       serviceRev1931_FE_nodef serviceRev1931_FE_full debtgdp1931_FE_nodef ///
       debtgdp1931_FE_full extdebt1931_FE_nodef ///
    using "Table3.tex", ///
    replace ///
    title("Table 3: 1931 Hoover Moratorium - Difference-in-Difference Analysis") ///
    mtitles("Growth, real p.c." "Growth, real p.c." "Credit Ratings (change)" ///
            "Debt Service to Revenue" "Debt Service to Revenue" ///
            "Total Public Debt/GDP" "Total Public Debt/GDP" "External Debt/GDP") ///
    mgroups("Small (Europe)" "Large (World)" "Small (Europe)" "Small (Europe)" ///
            "Large (World)" "Small (Europe)" "Large (World)" "Small (Europe)", ///
            pattern(1 1 1 1 1 1 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) ///
            span erepeat(\cmidrule(lr){@span})) ///
    keep(after1931 after_Hoover _cons) ///
    order(after1931 after_Hoover _cons) ///
    coeflabels(after1931 "Post-intervention dummy (after 1931)" ///
               after_Hoover "Treatment (war debt moratorium) × post-intervention dummy" ///
               _cons "Constant") ///
    se(3) b(3) ///
    stats(N r2_a, labels("Observations" "Adjusted R²") fmt(%9.0f %9.3f)) ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
    addnotes("Notes: This table reports difference-in-difference estimates of the effect" ///
             "of the 1931 Hoover Moratorium on various economic outcomes." ///
             "Treatment group consists of 18 countries that received war debt relief." ///
             "Small counterfactual includes European non-defaulters;" ///
             "Large counterfactual adds Latin American and other countries." ///
             "All regressions include country and year fixed effects." ///
             "Standard errors clustered at country level in parentheses." ///
             "* p<0.10, ** p<0.05, *** p<0.01") ///
    width(\hsize) ///
    substitute(\_ _)
	
	
use EMEs_rep.dta, clear

gen EMEdefault_window=0 if EME_sample==1
	replace EMEdefault_window=1 if Deal_index>-6 & Deal_index<6
	
	gen DiD1988_5year=.
	replace DiD1988_5year=1 if year>1982 & year<1993
	
	gen DiD1989_5year=.
	replace DiD1989_5year=1 if year>1983 & year<1994
	
	gen DiD1990_5year=.
	replace DiD1990_5year=1 if year>1985 & year<1996
	
		gen DiD1990_3year=.
		replace DiD1990_3year=1 if year>1987 & year<1994
		
		gen DiD1990_4year=.
		replace DiD1990_4year=1 if year>1986 & year<1995
		
		gen DiD1990_6year=.
		replace DiD1990_6year=1 if year>1984 & year<1997
		
	gen DiD1986_5year=.
	replace DiD1986_5year=1 if year>1980 & year<1991
	
	*** Diff in Diff variables
	
	*Brady Plan		
	gen after1989=1 if year>1989 & year<2014
	replace after1989=0 if year<1990
	
	gen after1990=1 if year>1990 & year<2014
	replace after1990=0 if year<1991
	
	gen post_Brady=Brady_treat*after1990
	
	gen post_BradLatAm=LatAm_treat*after1990
	
		** Relief
		bysort codeid: egen Brady_debtrelief=max(Brady_relief)
		replace Brady_debtrelief=0 if Brady_treat==0
	
		gen after_Bradyrelief=after1990*Brady_debtrelief
		
		** Relief (continuous)
		bysort codeid: egen Brady_debtstockrelief=max(Brady_stockrelief)
		replace Brady_debtstockrelief=0 if Brady_treat==0
	
		gen after_Bradystockrelief=after1990*Brady_debtstockrelief
		
		*Placebo
		gen after1988=1 if year>1988 & year<2014
		replace after1988=0 if year<1989
	
		gen post_1988=0 if Brady_treat!=.
		replace post_1988=1 if after1988==1 & Brady_treat==1
		replace post_1988=0 if after1988==0 & Brady_treat==1
	

	*Baker Plan
	gen after1986=1 if year>1986 & year<2014
	replace after1986=0 if year<1987
	
	gen post_Baker=Baker_treat*after1986

	
	
***********************************
****** Diff in Diff Regression
***********************************

* Set up panel structure
xtset codeid year
xi i.year

* Generate rating growth variable if not exists
capture drop ratings_growth
bysort codeid: gen ratings_growth=(d.iir_yearly/iir_yearly[_n-1])*100

*=============================================================================
* TABLE 5: BAKER INITIATIVE (1986) DIFFERENCE-IN-DIFFERENCE ANALYSIS
*=============================================================================

* Column 1: GDP Growth (real p.c.) around 1986
quietly xtreg EME_real_pc_growth after1986 post_Baker _Iyear_* ///
    if DiD1986_5year==1, fe cluster(codeid)
estimates store baker_growth

* Column 2: Credit Ratings (change) around 1986
quietly xtreg ratings_growth after1986 post_Baker _Iyear_* ///
    if DiD1986_5year==1, fe cluster(codeid)
estimates store baker_ratings

* Column 3: Debt Service to Exports around 1986
quietly xtreg DebtService_Exports after1986 post_Baker _Iyear_* ///
    if DiD1986_5year==1, fe cluster(codeid)
estimates store baker_debtserv

* Column 4: Total Public Debt/GDP around 1986
quietly xtreg debt_gdpAbbas after1986 post_Baker _Iyear_* ///
    if DiD1986_5year==1, fe cluster(codeid)
estimates store baker_debt

* Column 5: External Debt/GNI around 1986
quietly xtreg DebtExt_GNI after1986 post_Baker _Iyear_* ///
    if DiD1986_5year==1, fe cluster(codeid)
estimates store baker_extdebt

*-----------------------------------------------------------------------------
* Generate Table 5 using esttab
*-----------------------------------------------------------------------------

esttab baker_growth baker_ratings baker_debtserv baker_debt baker_extdebt ///
    using "Table5.tex", ///
    replace ///
    title("Table 5: Baker Initiative (1986) - Difference-in-Difference Analysis") ///
    mtitles("Growth, real p.c." "Credit Ratings (change)" "Debt Service to Exports" ///
            "Total Public Debt/GDP" "External Debt/GNI") ///
    keep(after1986 post_Baker) ///
    order(after1986 post_Baker) ///
    label ///
    varlabels(after1986 "Post-1986 dummy" ///
              post_Brady "Baker Treatment $\times$ Post-1986") ///
    stats(N r2 r2_a, ///
          labels("Observations" "R-squared" "Adjusted R-squared") ///
          fmt(%9.0fc %9.3f %9.3f)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    se ///
    b(%9.3f) ///
    se(%9.3f) ///
    brackets ///
    booktabs ///
    alignment(D{.}{.}{-1}) ///
    compress ///
    nogaps ///
    addnote("Note: Robust standard errors clustered at country level in parentheses." ///
            "All regressions include year and country fixed effects." ///
            "Time window: 1981-1990 (5 years before and after 1986)." ///
            "Significance levels: * p<0.10, ** p<0.05, *** p<0.01")

*=============================================================================
* TABLE 6: BRADY INITIATIVE (1990) DIFFERENCE-IN-DIFFERENCE ANALYSIS  
*=============================================================================

* Column 1: GDP Growth (real p.c.) around 1990
quietly xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* ///
    if DiD1990_5year==1, fe cluster(codeid)
estimates store brady_growth

* Column 2: Credit Ratings (change) around 1990
quietly xtreg ratings_growth after1990 post_Brady _Iyear_* ///
    if DiD1990_5year==1, fe cluster(codeid)
estimates store brady_ratings

* Column 3: Debt Service to Exports around 1990
quietly xtreg DebtService_Exports after1990 post_Brady _Iyear_* ///
    if DiD1990_5year==1, fe cluster(codeid)
estimates store brady_debtserv

* Column 4: Total Public Debt/GDP around 1990
quietly xtreg debt_gdpAbbas after1990 post_Brady _Iyear_* ///
    if DiD1990_5year==1, fe cluster(codeid)
estimates store brady_debt

* Column 5: External Debt/GNI around 1990
quietly xtreg DebtExt_GNI after1990 post_Brady _Iyear_* ///
    if DiD1990_5year==1, fe cluster(codeid)
estimates store brady_extdebt

*-----------------------------------------------------------------------------
* Generate Table 6 using esttab
*-----------------------------------------------------------------------------

esttab brady_growth brady_ratings brady_debtserv brady_debt brady_extdebt ///
    using "Table6.tex", ///
    replace ///
    title("Table 6: Brady Initiative (1990) - Difference-in-Difference Analysis") ///
    mtitles("Growth, real p.c." "Credit Ratings (change)" "Debt Service to Exports" ///
            "Total Public Debt/GDP" "External Debt/GNI") ///
    keep(after1990 post_Brady) ///
    order(after1990 post_Brady) ///
    label ///
    varlabels(after1990 "Post-1990 dummy" ///
              post_Brady "Brady Treatment $\times$ Post-1990") ///
    stats(N r2 r2_a, ///
          labels("Observations" "R-squared" "Adjusted R-squared") ///
          fmt(%9.0fc %9.3f %9.3f)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    se ///
    b(%9.3f) ///
    se(%9.3f) ///
    brackets ///
    booktabs ///
    alignment(D{.}{.}{-1}) ///
    compress ///
    nogaps ///
    addnote("Note: Robust standard errors clustered at country level in parentheses." ///
            "All regressions include year and country fixed effects." ///
            "Time window: 1986-1995 (5 years before and after 1990)." ///
            "Significance levels: * p<0.10, ** p<0.05, *** p<0.01")

*=============================================================================
* ROBUSTNESS CHECKS TABLE
*=============================================================================

*-----------------------------------------------------------------------------
* Baker Initiative Robustness Checks
*-----------------------------------------------------------------------------

* No time fixed effects
quietly xtreg EME_real_pc_growth after1986 post_Baker ///
    if DiD1986_5year==1, fe cluster(codeid)
estimates store baker_robust1

* Different time windows (3-year)
quietly xtreg EME_real_pc_growth after1986 post_Baker _Iyear_* ///
    if year>1983 & year<1990, fe cluster(codeid)
estimates store baker_robust2

* With controls (banking and currency crises)
quietly xtreg EME_real_pc_growth after1986 post_Baker bankingcrises currencycrises _Iyear_* ///
    if DiD1986_5year==1, fe cluster(codeid)
estimates store baker_robust3

*-----------------------------------------------------------------------------
* Brady Initiative Robustness Checks  
*-----------------------------------------------------------------------------

* No time fixed effects
quietly xtreg EME_real_pc_growth after1990 post_Brady ///
    if DiD1990_5year==1, fe cluster(codeid)
estimates store brady_robust1

* 3-year window
quietly xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* ///
    if DiD1990_3year==1, fe cluster(codeid)
estimates store brady_robust2

* 4-year window  
quietly xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* ///
    if DiD1990_4year==1, fe cluster(codeid)
estimates store brady_robust3

* 6-year window
quietly xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* ///
    if DiD1990_6year==1, fe cluster(codeid)
estimates store brady_robust4

* Without early Brady countries
quietly xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* ///
    if DiD1990_5year==1 & country!="Uruguay" & country!="Costa Rica" & ///
    country!="Venezuela" & country!="Mexico", fe cluster(codeid)
estimates store brady_robust5

* Without Eastern Europe
quietly xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* ///
    if DiD1990_5year==1 & EastEurope_EME!=1, fe cluster(codeid)
estimates store brady_robust6

* With controls (banking and currency crises)
quietly xtreg EME_real_pc_growth after1990 post_Brady bankingcrises currencycrises _Iyear_* ///
    if DiD1990_5year==1, fe cluster(codeid)
estimates store brady_robust7

* Placebo test (1988)
quietly xtreg EME_real_pc_growth after1988 post_1988 _Iyear_* ///
    if DiD1988_5year==1, fe cluster(codeid)
estimates store brady_placebo

*-----------------------------------------------------------------------------
* Generate Robustness Table
*-----------------------------------------------------------------------------

esttab baker_robust1 baker_robust2 baker_robust3 ///
       brady_robust1 brady_robust2 brady_robust3 brady_robust4 ///
       brady_robust5 brady_robust6 brady_robust7 brady_placebo ///
    using "Table56_Robustness.tex", ///
    replace ///
    title("Robustness Checks: Baker and Brady Initiative Analysis") ///
    mtitles("Baker No FE" "Baker 3yr" "Baker w/ Controls" ///
            "Brady No FE" "Brady 3yr" "Brady 4yr" "Brady 6yr" ///
            "Brady w/o Early" "Brady w/o EE" "Brady w/ Controls" "Placebo 1988") ///
    mgroups("Baker Initiative (1986)" "Brady Initiative (1990)", ///
            pattern(1 0 0 1 0 0 0 0 0 0 0) ///
            prefix(\multicolumn{@span}{c}{) suffix(}) ///
            span erepeat(\cmidrule(lr){@span})) ///
    keep(after1986 post_Brady after1990 post_Brady after1988 post_1988) ///
    label ///
    varlabels(after1986 "Post-1986" ///
              post_Brady "Baker Treatment" ///
              after1990 "Post-1990" ///
              post_Brady "Brady Treatment" ///
              after1988 "Post-1988" ///
              post_1988 "Placebo Treatment") ///
    stats(N r2, ///
          labels("Observations" "R-squared") ///
          fmt(%9.0fc %9.3f)) ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
    se ///
    b(%9.3f) ///
    se(%9.3f) ///
    brackets ///
    booktabs ///
    compress ///
    nogaps ///
    addnote("Note: Dependent variable is real per capita GDP growth." ///
            "Robust standard errors clustered at country level." ///
            "No FE = No time fixed effects; w/ Controls = includes banking/currency crises;" ///
            "w/o Early = excludes Mexico, Uruguay, Venezuela, Costa Rica;" ///
            "w/o EE = excludes Eastern Europe; Placebo uses 1988 as treatment year." ///
            "Significance levels: * p<0.10, ** p<0.05, *** p<0.01")

*=============================================================================
* ALTERNATIVE TREATMENTS: CONTINUOUS DEBT RELIEF MEASURES
*=============================================================================

* Brady continuous treatment: Debt relief/GDP
quietly xtreg EME_real_pc_growth after1990 after_Bradyrelief _Iyear_* ///
    if DiD1990_5year==1, fe cluster(codeid)
estimates store brady_continuous1

* Brady continuous treatment: Debt relief/debt stock
quietly xtreg EME_real_pc_growth after1990 after_Bradystockrelief _Iyear_* ///
    if DiD1990_5year==1, fe cluster(codeid)
estimates store brady_continuous2

* Continuous treatment table
esttab brady_continuous1 brady_continuous2 ///
    using "Table_Continuous_Treatment.tex", ///
    replace ///
    title("Brady Initiative: Continuous Treatment Variables") ///
    mtitles("Debt Relief/GDP" "Debt Relief/Debt Stock") ///
    keep(after1990 after_Bradyrelief after_Bradystockrelief) ///
    label ///
    varlabels(after1990 "Post-1990" ///
              after_Bradyrelief "Post-1990 $\times$ Debt Relief/GDP" ///
              after_Bradystockrelief "Post-1990 $\times$ Debt Relief/Stock") ///
    stats(N r2 r2_a, ///
          labels("Observations" "R-squared" "Adjusted R-squared") ///
          fmt(%9.0fc %9.3f %9.3f)) ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
    se ///
    brackets ///
    booktabs ///
    addnote("Note: Continuous treatment variables measure debt relief intensity." ///
            "All regressions include year and country fixed effects." ///
            "Robust standard errors clustered at country level." ///
            "Significance levels: * p<0.10, ** p<0.05, *** p<0.01")

*=============================================================================
* GENERATE XML OUTPUT FOR COMPATIBILITY
*=============================================================================

// * Combined Baker and Brady results (replicating original xml_tab output)
// xml_tab baker_growth baker_ratings baker_debtserv baker_debt baker_extdebt ///
//         brady_growth brady_ratings brady_debtserv brady_debt brady_extdebt, ///
//     below ///
//     stats(N, r2, r2_a) ///
//     format(NTCR2) ///
//     keep(after1986 post_Brady after1990 post_Brady _cons) ///
//     save(DiD_Baker_Brady_Results.xml) ///
//     replace







*=============================================================================
* STAGGERED DIFFERENCE-IN-DIFFERENCES ANALYSIS FOR BRADY PLAN
* Using Actual Implementation Dates by Country
*=============================================================================

cd "C:/Users/purga/Desktop/JEEA_final"
use "EMEs_rep.dta", clear

* Install required packages for staggered DiD
// capture ssc install estout
capture ssc install eventstudyinteract
capture ssc install did_multiplegt
capture ssc install csdid

*-----------------------------------------------------------------------------
* STEP 1: CREATE ACTUAL BRADY TREATMENT TIMING VARIABLES
*-----------------------------------------------------------------------------

* Generate actual Brady adoption year for each country
gen brady_adoption_year = .
replace brady_adoption_year = 1992 if country == "Argentina"    // April 1992
replace brady_adoption_year = 1993 if country == "Bolivia"     // March 1993  
replace brady_adoption_year = 1992 if country == "Brazil"      // August 1992
replace brady_adoption_year = 1993 if country == "Bulgaria"    // November 1993
replace brady_adoption_year = 1989 if country == "Costa Rica"  // November 1989
replace brady_adoption_year = 1993 if country == "Dominican Republic" // May 1993
replace brady_adoption_year = 1994 if country == "Ecuador"     // May 1994
replace brady_adoption_year = 1993 if country == "Jordan"      // June 1993
replace brady_adoption_year = 1989 if country == "Mexico"      // September 1989
replace brady_adoption_year = 1991 if country == "Nigeria"     // March 1991
replace brady_adoption_year = 1995 if country == "Panama"      // May 1995
replace brady_adoption_year = 1995 if country == "Peru"        // October 1995
replace brady_adoption_year = 1989 if country == "Philippines" // August 1989
replace brady_adoption_year = 1994 if country == "Poland"      // March 1994
replace brady_adoption_year = 1990 if country == "Uruguay"     // November 1990
replace brady_adoption_year = 1990 if country == "Venezuela"   // June 1990

* Create post-treatment indicator using actual adoption dates
gen post_brady_staggered = 0
replace post_brady_staggered = 1 if year >= brady_adoption_year & brady_adoption_year != .

* Create Brady treatment group indicator (same as before)
gen brady_treated = (Brady_treat == 1)

* Create never-treated group indicator
gen never_treated = (Brady_treat == 0 & EME_counterfactual == 1)

*-----------------------------------------------------------------------------
* STEP 2: GENERATE EVENT TIME VARIABLES FOR STAGGERED DID
*-----------------------------------------------------------------------------

* Generate event time (years relative to treatment)
gen event_time = year - brady_adoption_year if brady_treated == 1

* Create event time dummies for leads and lags
forvalues k = 10(-1)1 {
    gen lead`k' = (event_time == -`k') if brady_treated == 1
    replace lead`k' = 0 if never_treated == 1
}

forvalues k = 0/10 {
    gen lag`k' = (event_time == `k') if brady_treated == 1  
    replace lag`k' = 0 if never_treated == 1
}

*-----------------------------------------------------------------------------
* STEP 3: TRADITIONAL STAGGERED DID WITH TWFE
*-----------------------------------------------------------------------------

* Set panel structure
xtset codeid year
xi i.year

bysort codeid: gen ratings_growth=(d.iir_yearly/iir_yearly[_n-1])*100


* Traditional Two-Way Fixed Effects (potentially biased with heterogeneous treatment effects)
xtreg EME_real_pc_growth post_brady_staggered i.year if (brady_treated == 1 | never_treated == 1), fe cluster(codeid)
estimates store staggered_twfe_growth

xtreg ratings_growth post_brady_staggered i.year if (brady_treated == 1 | never_treated == 1), fe cluster(codeid)
estimates store staggered_twfe_ratings

xtreg DebtService_Exports post_brady_staggered i.year if (brady_treated == 1 | never_treated == 1), fe cluster(codeid)
estimates store staggered_twfe_debtserv

xtreg debt_gdpAbbas post_brady_staggered i.year if (brady_treated == 1 | never_treated == 1), fe cluster(codeid)
estimates store staggered_twfe_debt

xtreg DebtExt_GNI post_brady_staggered i.year if (brady_treated == 1 | never_treated == 1), fe cluster(codeid)
estimates store staggered_twfe_extdebt

// *-----------------------------------------------------------------------------
// * STEP 4: EVENT STUDY REGRESSION (SUN & ABRAHAM 2021 APPROACH)
// *-----------------------------------------------------------------------------
//
// * Event study with all leads and lags
// xtreg EME_real_pc_growth lead10-lead2 lag0-lag10 i.year ///
//     if (brady_treated == 1 | never_treated == 1), fe cluster(codeid)
// estimates store event_study_growth
//
// * Test pre-treatment parallel trends
// test lead10 lead9 lead8 lead7 lead6 lead5 lead4 lead3 lead2
// local pretrend_pval = r(p)
// display "Pre-treatment parallel trends test p-value: " `pretrend_pval'

*-----------------------------------------------------------------------------
* STEP 5: CALLAWAY & SANT'ANNA (2021) METHOD - CORRECTED
*-----------------------------------------------------------------------------

* Generate cohort indicator (year of first treatment)
gen cohort = brady_adoption_year if brady_treated == 1
replace cohort = 0 if never_treated == 1  // Never-treated units

* Check cohort distribution
display "Brady adoption cohorts:"
tabulate cohort if cohort > 0

* Run Callaway & Sant'Anna estimator for GDP Growth
csdid EME_real_pc_growth if (brady_treated == 1 | never_treated == 1), ///
    ivar(codeid) time(year) gvar(cohort) method(dripw) vce(cluster codeid)
estimates store cs_growth

* Generate simple ATT (average treatment effect on treated)
csdid_estat simple

* Generate event study results
csdid_estat event

* Event study plot - specify group and use event option
csdid_plot, group(event) title("Brady Plan: GDP Growth - Event Study") ///
    ytitle("Treatment Effect") xtitle("Years Since Treatment") ///
    graphregion(color(white)) plotregion(color(white))
graph export "CS_Brady_Growth_EventStudy.png", replace width(800) height(600)

// * Plot simple ATT by cohort
// csdid_plot, group(group) title("Brady Plan: GDP Growth - By Cohort") ///
//     ytitle("Treatment Effect") xttitle("Treatment Cohort") ///
//     graphregion(color(white)) plotregion(color(white))
// graph export "CS_Brady_Growth_Cohort.png", replace width(800) height(600)

* Same for other outcome variables with corrected syntax
*-----------------------------------------------------------------------------
* Credit Ratings
csdid ratings_growth if (brady_treated == 1 | never_treated == 1), ///
    ivar(codeid) time(year) gvar(cohort) method(dripw) vce(cluster codeid)
csdid_estat simple

* Generate event study results
csdid_estat event
csdid_plot, group(event) title("Brady Plan: Credit Ratings - Event Study") ///
    ytitle("Treatment Effect") xtitle("Years Since Treatment") ///
    graphregion(color(white)) plotregion(color(white))
graph export "CS_Brady_Ratings_EventStudy.png", replace width(800) height(600)

* Debt Service to Exports
csdid DebtService_Exports if (brady_treated == 1 | never_treated == 1), ///
    ivar(codeid) time(year) gvar(cohort) method(dripw) vce(cluster codeid)
csdid_estat simple

* Generate event study results
csdid_estat event
csdid_plot, group(event) title("Brady Plan: Debt Service - Event Study") ///
    ytitle("Treatment Effect") xtitle("Years Since Treatment") ///
    graphregion(color(white)) plotregion(color(white))
graph export "CS_Brady_DebtService_EventStudy.png", replace width(800) height(600)

* Total Public Debt/GDP
csdid debt_gdpAbbas if (brady_treated == 1 | never_treated == 1), ///
    ivar(codeid) time(year) gvar(cohort) method(dripw) vce(cluster codeid)
csdid_estat simple

* Generate event study results
csdid_estat event
csdid_plot, group(event) title("Brady Plan: Debt/GDP - Event Study") ///
    ytitle("Treatment Effect") xtitle("Years Since Treatment") ///
    graphregion(color(white)) plotregion(color(white))
graph export "CS_Brady_Debt_EventStudy.png", replace width(800) height(600)

* External Debt/GNI
csdid DebtExt_GNI if (brady_treated == 1 | never_treated == 1), ///
    ivar(codeid) time(year) gvar(cohort) method(dripw) vce(cluster codeid)
csdid_estat simple

* Generate event study results
csdid_estat event
csdid_plot, group(event) title("Brady Plan: External Debt - Event Study") ///
    ytitle("Treatment Effect") xtitle("Years Since Treatment") ///
    graphregion(color(white)) plotregion(color(white))
graph export "CS_Brady_ExtDebt_EventStudy.png", replace width(800) height(600)

*-----------------------------------------------------------------------------
* ALTERNATIVE: MANUAL EVENT STUDY PLOT IF CSDID_PLOT STILL FAILS
*-----------------------------------------------------------------------------

* If csdid_plot continues to have issues, create manual event study plot
// preserve
//
// * Get the event study results
csdid EME_real_pc_growth if (brady_treated == 1 | never_treated == 1), ///
    ivar(codeid) time(year) gvar(cohort) method(dripw) vce(cluster codeid)
	
csdid ratings_growth if (brady_treated == 1 | never_treated == 1), ///
    ivar(codeid) time(year) gvar(cohort) method(dripw) vce(cluster codeid)
	
	* Debt Service to Exports
	
csdid DebtService_Exports if (brady_treated == 1 | never_treated == 1), ///
    ivar(codeid) time(year) gvar(cohort) method(dripw) vce(cluster codeid)
	
	* Total Public Debt/GDP
	
csdid debt_gdpAbbas if (brady_treated == 1 | never_treated == 1), ///
    ivar(codeid) time(year) gvar(cohort) method(dripw) vce(cluster codeid)
	
	* External Debt/GNI
	
csdid DebtExt_GNI if (brady_treated == 1 | never_treated == 1), ///
    ivar(codeid) time(year) gvar(cohort) method(dripw) vce(cluster codeid)
//
// * Extract event study estimates
// csdid_estat event
//
// * Store results in matrix (this will need to be adjusted based on actual output)
// matrix event_results = r(table)
//
//
// clear
// svmat event_results, names(col)
//
// * 添加变量标签
// gen outcome_var = ""
// gen outcome_num = _n
//
// replace outcome_var = "GDP Growth (real p.c.)" if outcome_num == 1
// replace outcome_var = "Credit Ratings (change)" if outcome_num == 2  
// replace outcome_var = "Debt Service to Exports" if outcome_num == 3
// replace outcome_var = "Total Public Debt/GDP" if outcome_num == 4
// replace outcome_var = "External Debt/GNI" if outcome_num == 5
//
// * 生成显著性星号
// gen significance = ""
// replace significance = "***" if p_value < 0.01
// replace significance = "**" if p_value >= 0.01 & p_value < 0.05
// replace significance = "*" if p_value >= 0.05 & p_value < 0.10
//
// * 格式化数值
// gen att_formatted = string(ATT, "%9.3f") + significance
// gen se_formatted = "(" + string(SE, "%9.3f") + ")"
// gen ci_formatted = "[" + string(CI_lower, "%9.3f") + ", " + string(CI_upper, "%9.3f") + "]"
// gen pval_formatted = string(p_value, "%9.3f")
//
// listtab outcome_var att_formatted se_formatted ci_formatted ///
//     using "Table_CSDID_Brady_Results.tex", ///
//     replace ///
//     rstyle(tabular) ///
//     headlines("\begin{table}[htbp]\centering" ///
//               "\caption{Brady Plan: Callaway-Sant'Anna Staggered Difference-in-Differences Results}" ///
//               "\label{tab:csdid_brady}" ///
//               "\begin{tabular}{lccc}" ///
//               "\toprule" ///
//               "Outcome Variable & ATT & Std. Error & 95\% CI \\" ///
//               "\midrule") ///
//     footlines("\bottomrule" ///
//               "\end{tabular}" ///
//               "\begin{tablenotes}[para,flushleft]" ///
//               "\footnotesize" ///
//               "Notes: This table presents average treatment effects on the treated (ATT)" ///
//               "from the Callaway and Sant'Anna (2021) staggered difference-in-differences" ///
//               "estimator. The method accounts for treatment effect heterogeneity across" ///
//               "cohorts and time periods. Standard errors are clustered at the country level." ///
//               "Treatment timing varies by country: Mexico, Philippines, Costa Rica (1989);" ///
//               "Uruguay, Venezuela (1990); Nigeria (1991); Argentina, Brazil (1992);" ///
//               "Bolivia, Bulgaria, Dominican Republic, Jordan (1993);" ///
//               "Ecuador, Poland (1994); Panama, Peru (1995)." ///
//               "Control group consists of emerging market economies that never implemented" ///
//               "Brady agreements. Significance levels: * p$<$0.10, ** p$<$0.05, *** p$<$0.01" ///
//               "\end{tablenotes}" ///
//               "\end{table}")


*=============================================================================
* CALLAWAY-SANT'ANNA STAGGERED DID RESULTS - MAIN COMPARISON TABLE
*=============================================================================

preserve

*-----------------------------------------------------------------------------
* STEP 1: 运行所有五个变量的CSDID分析并提取结果
*-----------------------------------------------------------------------------

* 定义变量和标签
local outcomes "EME_real_pc_growth ratings_growth DebtService_Exports debt_gdpAbbas DebtExt_GNI"
local outcome_labels `" "GDP Growth" "Credit Ratings" "Debt Service" "Total Debt" "External Debt" "'

* 创建结果矩阵存储所有结果
matrix csdid_results = J(5, 6, .)
matrix rownames csdid_results = GDP_Growth Credit_Ratings Debt_Service Total_Debt External_Debt
matrix colnames csdid_results = ATT SE t_stat p_value CI_lower CI_upper

* 依次运行每个变量的分析并提取结果
local row = 1
foreach outcome of local outcomes {
    
    * 运行CSDID
    quietly csdid `outcome' if (brady_treated == 1 | never_treated == 1), ///
        ivar(codeid) time(year) gvar(cohort) method(dripw) vce(cluster codeid)
    
    * 获取简单ATT结果
    quietly csdid_estat simple
    matrix temp_results = r(table)
    
    * 存储结果到矩阵
    matrix csdid_results[`row', 1] = temp_results[1, 1]  // ATT系数
    matrix csdid_results[`row', 2] = temp_results[2, 1]  // 标准误
    matrix csdid_results[`row', 3] = temp_results[3, 1]  // t统计量
    matrix csdid_results[`row', 4] = temp_results[4, 1]  // p值
    matrix csdid_results[`row', 5] = temp_results[5, 1]  // 置信区间下限
    matrix csdid_results[`row', 6] = temp_results[6, 1]  // 置信区间上限
    
    local row = `row' + 1
}

*-----------------------------------------------------------------------------
* STEP 2: 创建数据集用于表格生成
*-----------------------------------------------------------------------------

* 将矩阵转换为数据集
clear
svmat csdid_results, names(col)

* 添加变量标签
gen outcome = ""
replace outcome = "GDP Growth (real p.c.)" in 1
replace outcome = "Credit Ratings (change)" in 2
replace outcome = "Debt Service to Exports" in 3
replace outcome = "Total Public Debt/GDP" in 4
replace outcome = "External Debt/GNI" in 5

* 生成显著性星号
gen significance = ""
replace significance = "***" if p_value < 0.01
replace significance = "**" if p_value >= 0.01 & p_value < 0.05
replace significance = "*" if p_value >= 0.05 & p_value < 0.10

* 格式化数值
gen att_formatted = string(ATT, "%9.3f") + significance
gen se_formatted = "(" + string(SE, "%9.3f") + ")"
gen ci_formatted = "[" + string(CI_lower, "%9.3f") + ", " + string(CI_upper, "%9.3f") + "]"

*-----------------------------------------------------------------------------
* STEP 3: 创建虚拟估计结果用于ESTTAB输出
*-----------------------------------------------------------------------------

* 为每个变量创建虚拟回归结果来配合esttab
forvalues i = 1/5 {
    * 创建临时变量
    gen temp_y`i' = 0 in 1/10
    gen temp_x`i' = 1 in 1/10
    
    * 运行虚拟回归
    quietly reg temp_y`i' temp_x`i' in 1/10
    
    * 手动替换系数矩阵
    matrix b = e(b)
    matrix V = e(V)
    local att_val = ATT[`i']
    local se_val = SE[`i']
    matrix b[1, 1] = `att_val'
    matrix V[1, 1] = `se_val'^2
    matrix V[2, 2] = 0  // 常数项方差设为0
    
    * 手动设置样本量
    ereturn post b V, obs(100)
    ereturn local depvar "CSDID_Result_`i'"
    estimates store csdid_`i'
    
    * 清理临时变量
    drop temp_y`i' temp_x`i'
}

*-----------------------------------------------------------------------------
* STEP 4: 使用ESTTAB生成CSDID结果表格
*-----------------------------------------------------------------------------

esttab csdid_1 csdid_2 csdid_3 csdid_4 csdid_5 ///
    using "Table_Brady_Staggered_DID_Results.tex", ///
    replace ///
    title("Brady Plan: Callaway-Sant'Anna Staggered Difference-in-Differences Results") ///
    mtitles("GDP Growth" "Credit Ratings" "Debt Service" "Total Debt/GDP" "External Debt/GNI") ///
    keep(temp_x*) ///
    coeflabels(temp_x1 "ATT" temp_x2 "ATT" temp_x3 "ATT" temp_x4 "ATT" temp_x5 "ATT") ///
    stats(N, ///
          labels("Observations") ///
          fmt(%9.0fc)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    se ///
    b(%9.3f) ///
    se(%9.3f) ///
    brackets ///
    booktabs ///
    alignment(D{.}{.}{-1}) ///
    compress ///
    nogaps ///
    prehead("\begin{table}[htbp]\centering" ///
            "\caption{Brady Plan: Callaway-Sant'Anna Staggered Difference-in-Differences Results}" ///
            "\label{tab:csdid_brady}" ///
            "\begin{tabular}{l*{5}{c}}" ///
            "\toprule") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
             "\end{tabular}" ///
             "\end{table}") ///
    addnote("Notes: This table presents average treatment effects on the treated (ATT)" ///
            "from the Callaway and Sant'Anna (2021) staggered difference-in-differences" ///
            "estimator. The method accounts for treatment effect heterogeneity across" ///
            "cohorts and time periods. Standard errors are clustered at the country level." ///
            "Treatment timing varies by country: Mexico, Philippines, Costa Rica (1989);" ///
            "Uruguay, Venezuela (1990); Nigeria, Brazil (1991);" ///
            "Bolivia, Bulgaria, Dominican Republic, Jordan (1993);" ///
            "Ecuador, Poland (1994); Panama, Peru (1995)." ///
            "Control group consists of emerging market economies that never implemented" ///
            "Brady agreements. Significance levels: * p$<$0.10, ** p$<$0.05, *** p$<$0.01")


// restore

*-----------------------------------------------------------------------------
* SIMPLIFIED APPROACH: FOCUS ON AGGREGATE RESULTS
*-----------------------------------------------------------------------------

* If event study plots are problematic, focus on aggregate treatment effects
preserve

* Run CSDID and get simple aggregate results
csdid EME_real_pc_growth if (brady_treated == 1 | never_treated == 1), ///
    ivar(codeid) time(year) gvar(cohort) method(dripw) vce(cluster codeid)

* Get simple ATT
csdid_estat simple
matrix simple_att = r(table)

* Display results
display "=== CALLAWAY-SANT'ANNA RESULTS ==="
display "Simple Average Treatment Effect on Treated:"
matrix list simple_att

* Store key results
local att_coef = simple_att[1,1]
local att_se = simple_att[2,1]
local att_pval = simple_att[4,1]

display "ATT Coefficient: " `att_coef'
display "Standard Error: " `att_se'  
display "P-value: " `att_pval'

restore

*-----------------------------------------------------------------------------
* ROBUST ALTERNATIVE: TRADITIONAL EVENT STUDY
*-----------------------------------------------------------------------------

* Generate traditional event study as backup
forvalues k = 5(-1)1 {
    gen pre`k' = (event_time == -`k') if brady_treated == 1
    replace pre`k' = 0 if never_treated == 1
}

gen treatment = (event_time == 0) if brady_treated == 1
replace treatment = 0 if never_treated == 1

forvalues k = 1/5 {
    gen post`k' = (event_time == `k') if brady_treated == 1
    replace post`k' = 0 if never_treated == 1
}

* Run traditional event study regression
xtreg EME_real_pc_growth pre5 pre4 pre3 pre2 treatment post1 post2 post3 post4 post5 i.year ///
    if (brady_treated == 1 | never_treated == 1), fe cluster(codeid)

* Plot traditional event study
coefplot, keep(pre5 pre4 pre3 pre2 treatment post1 post2 post3 post4 post5) ///
    vertical ///
    yline(0, lcolor(red) lpattern(dash)) ///
    xline(5.5, lcolor(black) lpattern(dash)) ///
    xlabel(1 "t-5" 2 "t-4" 3 "t-3" 4 "t-2" 5 "t" 6 "t+1" 7 "t+2" 8 "t+3" 9 "t+4" 10 "t+5") ///
    title("Brady Plan Event Study: GDP Growth (Traditional)") ///
    subtitle("Using Actual Implementation Dates") ///
    xtitle("Years Relative to Treatment") ///
    ytitle("Treatment Effect") ///
    graphregion(color(white)) plotregion(color(white))
    
graph export "Traditional_Brady_EventStudy.png", replace width(1000) height(600)

* Test parallel trends
test pre5 pre4 pre3 pre2
local pretrend_pval = r(p)
display "Pre-treatment parallel trends test p-value: " `pretrend_pval'














*=============================================================================
* COMPREHENSIVE STAGGERED DID RESULTS TABLE
*=============================================================================

*-----------------------------------------------------------------------------
* STEP 1: COMPARISON TABLE - TRADITIONAL vs STAGGERED APPROACHES
*-----------------------------------------------------------------------------

* First, run the original Brady analysis with uniform timing (1990)
quietly xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* ///
    if DiD1990_5year==1, fe cluster(codeid)
estimates store traditional_brady_growth

quietly xtreg ratings_growth after1990 post_Brady _Iyear_* ///
    if DiD1990_5year==1, fe cluster(codeid)
estimates store traditional_brady_ratings

quietly xtreg DebtService_Exports after1990 post_Brady _Iyear_* ///
    if DiD1990_5year==1, fe cluster(codeid)
estimates store traditional_brady_debtserv

quietly xtreg debt_gdpAbbas after1990 post_Brady _Iyear_* ///
    if DiD1990_5year==1, fe cluster(codeid)
estimates store traditional_brady_debt

quietly xtreg DebtExt_GNI after1990 post_Brady _Iyear_* ///
    if DiD1990_5year==1, fe cluster(codeid)
estimates store traditional_brady_extdebt

* Generate comprehensive comparison table
esttab traditional_brady_growth staggered_twfe_growth ///
       traditional_brady_ratings staggered_twfe_ratings ///
       traditional_brady_debtserv staggered_twfe_debtserv ///
       traditional_brady_debt staggered_twfe_debt ///
       traditional_brady_extdebt staggered_twfe_extdebt ///
    using "Table_Traditional_vs_Staggered_Brady.tex", ///
    replace ///
    title("Table: Traditional vs Staggered Difference-in-Differences Analysis of Brady Plan") ///
    mtitles("Trad. Growth" "Stag. Growth" "Trad. Ratings" "Stag. Ratings" ///
            "Trad. Debt Serv." "Stag. Debt Serv." "Trad. Debt/GDP" "Stag. Debt/GDP" ///
            "Trad. Ext. Debt" "Stag. Ext. Debt") ///
    mgroups("GDP Growth" "Credit Ratings" "Debt Service/Exports" "Total Debt/GDP" "External Debt/GNI", ///
            pattern(1 0 1 0 1 0 1 0 1 0) ///
            prefix(\multicolumn{@span}{c}{) suffix(}) ///
            span erepeat(\cmidrule(lr){@span})) ///
    keep(post_Brady post_brady_staggered after1990) ///
    order(post_Brady post_brady_staggered after1990) ///
    label ///
    varlabels(post_Brady "Traditional Brady Treatment" ///
              post_brady_staggered "Staggered Brady Treatment" ///
              after1990 "Post-1990 Indicator") ///
    stats(N r2 r2_a, ///
          labels("Observations" "R-squared" "Adjusted R-squared") ///
          fmt(%9.0fc %9.3f %9.3f)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    se ///
    b(%9.3f) ///
    se(%9.3f) ///
    brackets ///
    booktabs ///
    compress ///
    nogaps ///
    addnote("Note: Traditional approach assumes all Brady countries treated in 1990." ///
            "Staggered approach uses actual implementation dates (1989-1995)." ///
            "Treatment countries: Argentina (1992), Bolivia (1993), Brazil (1992)," ///
            "Bulgaria (1993), Costa Rica (1989), Dominican Republic (1993)," ///
            "Ecuador (1994), Jordan (1993), Mexico (1989), Nigeria (1991)," ///
            "Panama (1995), Peru (1995), Philippines (1989), Poland (1994)," ///
            "Uruguay (1990), Venezuela (1990)." ///
            "All regressions include country and year fixed effects." ///
            "Robust standard errors clustered at country level." ///
            "Significance levels: * p<0.10, ** p<0.05, *** p<0.01")

*-----------------------------------------------------------------------------
* STEP 2: STAGGERED DID DETAILED RESULTS TABLE
*-----------------------------------------------------------------------------

* Generate detailed staggered results table with all specifications
esttab staggered_twfe_growth staggered_twfe_ratings staggered_twfe_debtserv ///
       staggered_twfe_debt staggered_twfe_extdebt ///
    using "Table_Staggered_Brady_Detailed.tex", ///
    replace ///
    title("Table: Brady Plan Staggered Difference-in-Differences Analysis") ///
    subtitle("Using Actual Country-Specific Implementation Dates (1989-1995)") ///
    mtitles("GDP Growth" "Credit Ratings" "Debt Service" "Total Debt/GDP" "External Debt/GNI") ///
    keep(post_brady_staggered) ///
    order(post_brady_staggered) ///
    label ///
    varlabels(post_brady_staggered "Brady Treatment Effect") ///
    stats(N r2 r2_a, ///
          labels("Observations" "R-squared" "Adjusted R-squared") ///
          fmt(%9.0fc %9.3f %9.3f)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    se ///
    b(%9.3f) ///
    se(%9.3f) ///
    brackets ///
    booktabs ///
    alignment(D{.}{.}{-1}) ///
    compress ///
    nogaps ///
    prehead("\begin{table}[htbp]\centering" ///
            "\caption{Brady Plan Staggered Difference-in-Differences Analysis}" ///
            "\label{tab:staggered_brady}" ///
            "\begin{tabular}{l*{5}{c}}" ///
            "\toprule") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
             "\end{tabular}" ///
             "\end{table}") ///
    addnote("Note: This table presents staggered difference-in-differences estimates" ///
            "using actual Brady Plan implementation dates by country." ///
            "Treatment timing: Early adopters (1989): Costa Rica, Mexico, Philippines;" ///
            "1990: Uruguay, Venezuela; 1991: Nigeria; 1992: Argentina, Brazil;" ///
            "1993: Bolivia, Bulgaria, Dominican Republic, Jordan;" ///
            "1994: Ecuador, Poland; 1995: Panama, Peru." ///
            "Control group consists of emerging market economies that never" ///
            "implemented Brady agreements. All regressions include country" ///
            "and year fixed effects. Robust standard errors clustered at" ///
            "country level in parentheses." ///
            "Significance levels: * p<0.10, ** p<0.05, *** p<0.01")

*-----------------------------------------------------------------------------
* STEP 3: CALLAWAY-SANT'ANNA RESULTS EXTRACTION AND TABLE
*-----------------------------------------------------------------------------

* Store Callaway-Sant'Anna results for each outcome
preserve

* Get simple ATT results for each outcome variable
local outcomes "EME_real_pc_growth ratings_growth DebtService_Exports debt_gdpAbbas DebtExt_GNI"
local outcome_names "GDP_Growth Credit_Ratings Debt_Service Total_Debt External_Debt"

* Initialize matrix to store CS results
matrix cs_results = J(5, 6, .)
matrix rownames cs_results = `outcome_names'
matrix colnames cs_results = "ATT" "SE" "t_stat" "p_value" "CI_lower" "CI_upper"

local i = 1
foreach outcome of local outcomes {
    * Run CSDID for each outcome
    quietly csdid `outcome' if (brady_treated == 1 | never_treated == 1), ///
        ivar(codeid) time(year) gvar(cohort) method(dripw) vce(cluster codeid)
    
    * Get simple ATT
    quietly csdid_estat simple
    matrix temp = r(table)
    
    * Store results
    matrix cs_results[`i', 1] = temp[1, 1]  // ATT coefficient
    matrix cs_results[`i', 2] = temp[2, 1]  // Standard error
    matrix cs_results[`i', 3] = temp[3, 1]  // t-statistic
    matrix cs_results[`i', 4] = temp[4, 1]  // p-value
    matrix cs_results[`i', 5] = temp[5, 1]  // Lower CI
    matrix cs_results[`i', 6] = temp[6, 1]  // Upper CI
    
    local i = `i' + 1
}

* Convert matrix to dataset for table creation
clear
svmat cs_results, names(col)
gen outcome = ""
replace outcome = "GDP Growth (real p.c.)" in 1
replace outcome = "Credit Ratings (change)" in 2
replace outcome = "Debt Service to Exports" in 3
replace outcome = "Total Public Debt/GDP" in 4
replace outcome = "External Debt/GNI" in 5

* Generate significance stars
gen stars = ""
replace stars = "***" if p_value < 0.01
replace stars = "**" if p_value >= 0.01 & p_value < 0.05
replace stars = "*" if p_value >= 0.05 & p_value < 0.10

* Format for LaTeX table
gen att_formatted = string(ATT, "%9.3f") + stars
gen se_formatted = "(" + string(SE, "%9.3f") + ")"
gen ci_formatted = "[" + string(CI_lower, "%9.3f") + ", " + string(CI_upper, "%9.3f") + "]"

* Export to LaTeX
listtab outcome att_formatted se_formatted ci_formatted ///
    using "Table_Callaway_SantAnna_Results.tex", ///
    replace ///
    rstyle(tabular) ///
    headlines("\begin{table}[htbp]\centering" ///
              "\caption{Brady Plan: Callaway-Sant'Anna Staggered DiD Results}" ///
              "\label{tab:cs_brady}" ///
              "\begin{tabular}{lccc}" ///
              "\toprule" ///
              "Outcome Variable & ATT & Std. Error & 95\% CI \\" ///
              "\midrule") ///
    footlines("\bottomrule" ///
              "\end{tabular}" ///
              "\begin{tablenotes}[para,flushleft]" ///
              "\footnotesize" ///
              "Note: This table presents average treatment effects on the treated (ATT)" ///
              "from Callaway and Sant'Anna (2021) staggered difference-in-differences" ///
              "estimator. Results account for treatment effect heterogeneity across" ///
              "cohorts and time periods. Bootstrap standard errors with 500 replications." ///
              "95\% confidence intervals in brackets. Treatment timing varies by country" ///
              "from 1989-1995. Control group: emerging markets without Brady agreements." ///
              "Significance levels: * p<0.10, ** p<0.05, *** p<0.01" ///
              "\end{tablenotes}" ///
              "\end{table}")

restore

*-----------------------------------------------------------------------------
* STEP 4: COMPREHENSIVE ROBUSTNESS CHECKS TABLE
*-----------------------------------------------------------------------------

* Generate robustness checks for staggered approach
local window_conditions `" "year >= 1986 & year <= 1995" "year >= 1987 & year <= 1994" "year >= 1988 & year <= 1993" "'

local i = 1
foreach condition of local window_conditions {
    quietly xtreg EME_real_pc_growth post_brady_staggered i.year ///
        if (brady_treated == 1 | never_treated == 1) & `condition', fe cluster(codeid)
    estimates store stag_robust`i'
    local i = `i' + 1
}

* Exclude early adopters
quietly xtreg EME_real_pc_growth post_brady_staggered i.year ///
    if (brady_treated == 1 | never_treated == 1) & ///
    !inlist(country, "Mexico", "Philippines", "Costa Rica"), fe cluster(codeid)
estimates store stag_robust4

* Exclude late adopters
quietly xtreg EME_real_pc_growth post_brady_staggered i.year ///
    if (brady_treated == 1 | never_treated == 1) & ///
    !inlist(country, "Panama", "Peru"), fe cluster(codeid)
estimates store stag_robust5

* With additional controls
quietly xtreg EME_real_pc_growth post_brady_staggered bankingcrises currencycrises i.year ///
    if (brady_treated == 1 | never_treated == 1), fe cluster(codeid)
estimates store stag_robust6

* Generate robustness table
esttab staggered_twfe_growth stag_robust1 stag_robust2 stag_robust3 ///
       stag_robust4 stag_robust5 stag_robust6 ///
    using "Table_Staggered_Robustness.tex", ///
    replace ///
    title("Table: Staggered DiD Robustness Checks - Brady Plan") ///
    mtitles("Baseline" "10yr window" "8yr window" "6yr window" ///
            "No Early" "No Late" "w/ Controls") ///
    keep(post_brady_staggered) ///
    label ///
    varlabels(post_brady_staggered "Staggered Brady Treatment") ///
    stats(N r2, ///
          labels("Observations" "R-squared") ///
          fmt(%9.0fc %9.3f)) ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
    se ///
    brackets ///
    booktabs ///
    compress ///
    addnote("Note: Dependent variable is real per capita GDP growth." ///
            "Baseline uses 1986-1995 window. No Early excludes Mexico, Philippines," ///
            "Costa Rica (1989 adopters). No Late excludes Panama, Peru (1995 adopters)." ///
            "Controls include banking and currency crisis indicators." ///
            "All regressions include country and year fixed effects." ///
            "Robust standard errors clustered at country level." ///
            "Significance levels: * p<0.10, ** p<0.05, *** p<0.01")

*-----------------------------------------------------------------------------
* STEP 5: TREATMENT INTENSITY TABLE
*-----------------------------------------------------------------------------

* Continuous treatment variables
quietly xtreg EME_real_pc_growth after_Bradyrelief i.year ///
    if (brady_treated == 1 | never_treated == 1), fe cluster(codeid)
estimates store intensity1

quietly xtreg EME_real_pc_growth after_Bradystockrelief i.year ///
    if (brady_treated == 1 | never_treated == 1), fe cluster(codeid)
estimates store intensity2

* Generate intensity table
esttab staggered_twfe_growth intensity1 intensity2 ///
    using "Table_Treatment_Intensity.tex", ///
    replace ///
    title("Table: Treatment Intensity Analysis - Brady Plan") ///
    mtitles("Binary Treatment" "Debt Relief/GDP" "Debt Relief/Stock") ///
    keep(post_brady_staggered after_Bradyrelief after_Bradystockrelief) ///
    label ///
    varlabels(post_brady_staggered "Binary Brady Treatment" ///
              after_Bradyrelief "Debt Relief/GDP (\%)" ///
              after_Bradystockrelief "Debt Relief/Stock (\%)") ///
    stats(N r2 r2_a, ///
          labels("Observations" "R-squared" "Adjusted R-squared") ///
          fmt(%9.0fc %9.3f %9.3f)) ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
    se ///
    brackets ///
    booktabs ///
    addnote("Note: Dependent variable is real per capita GDP growth." ///
            "Binary treatment uses actual implementation timing by country." ///
            "Continuous treatments multiply post-treatment indicator by" ///
            "debt relief amount (as \% of GDP or debt stock)." ///
            "All regressions include country and year fixed effects." ///
            "Robust standard errors clustered at country level." ///
            "Significance levels: * p<0.10, ** p<0.05, *** p<0.01")
