**********************************************************************
*** Do File 1 "Interwar" underlying the paper "Sovereign Debt Relief and its Aftermath" by Carmen M. Reinhart and Christoph Trebesch
*** This do file generates the descriptive figures and regressions results for the 1931 and 1934 debt relief events
	cd "C:/Users/purga/Desktop/JEEA_final"
	clear
	use Interwar.dta
	
	**install ado files "diff" and "xml_tab"
	capture ssc install diff
	capture ssc install xml_tab

***********************************************************************
***** Define War Samples & Counterfactuals

*** DEFAULTERs: sample of 18 countries that defaulted on the war debt (excluding Finland, which repaid in full, and the US domestic case)

	gen WarDefaulters=.
	replace WarDefaulters=1 if country=="Austria" | country=="Belgium" | country=="Czechoslovakia" | country=="Estonia" | country=="France" | country=="Greece" | country=="Yugoslavia" 
	replace WarDefaulters=1 if country=="Hungary" | country=="Italy"  | country=="Lithuania"  | country=="Latvia"  | country=="Poland"  | country=="Romania" | country=="United Kingdom" | country=="Germany"
	replace WarDefaulters=1 if country=="Australia" | country=="Portugal" | country=="New Zealand"

*** COUNTERFACTUAL 1920s/30s:
	
	* No credit event: Canada, Argentina, Finland, Norway, Sweden, Switzerland, Denmark, Japan, Thailand
	* Defaulted on private debt, but not official debt: Brazil, Chile, Colombia, Mexico, Turkey, Peru
	
	*** No Default
	gen Nodefault_Europe=.
	replace Nodefault_Europe=1 if country=="Finland" |  country=="Norway" | country=="Sweden" | country=="Switzerland" | country=="Denmark" | country=="Ireland" | country=="Spain"  

	*** Add South Amrican Countries (all but Venezuela and Argentina defaulted)
	gen WarLatAm=.
	replace WarLatAm=1 if country=="Argentina" | country=="Uruguay" | country=="Chile" | country=="Brazil" | country=="Colombia" | country=="Mexico" | country=="Peru" | country=="Venezuela"   
	
	*** Add Other Non-South American Countries
	gen WarNonLatAm=.
	replace WarNonLatAm=1 if country=="Russia" | country=="Japan" | country=="China" | country=="Bulgaria" | country=="Turkey" | country=="Thailand" 
		
	*** Eastern Europe Dummy
	gen EasternEurope=.
	replace EasternEurope=1 if country=="Czechoslovakia" | country=="Estonia" | country=="Hungary" | country=="Latvia" | country=="Lithuania" | country=="Poland"  | country=="Romania" | country=="Yugoslavia" 
	
//| country=="Colombia"
*** FINAL SAMPLES (treatment and control)

	gen WarSmallSample=.
	replace WarSmallSample=1 if WarDefaulters==1
	replace WarSmallSample=1 if Nodefault_Europe==1

	gen WarLatAmSample=.
	replace WarLatAmSample=1 if WarDefaulters==1
	replace WarLatAmSample=1 if Nodefault_Europe==1
	replace WarLatAmSample=1 if WarLatAm==1
	
	gen WarNonLatAmSample=.
	replace WarNonLatAmSample=1 if WarDefaulters==1
	replace WarNonLatAmSample=1 if Nodefault_Europe==1
	replace WarNonLatAmSample=1 if WarNonLatAm==1
	
	gen WarAllSample=WarSmallSample
	replace WarAllSample=1 if WarLatAm==1
	replace WarAllSample=1 if WarNonLatAm==1

	gen WarCounterfact_all=.
	replace WarCounterfact_all=1 if Nodefault_Europe==1
	replace WarCounterfact_all=1 if WarNonLatAm==1
	replace WarCounterfact_all=1 if WarLatAm==1

	
***********************************************************************
**** Time Windows and Normalization
***********************************************************************

	**** War Debt Index 1934
	sort codeid year
	gen y1934_index=.
	bysort codeid: replace y1934_index=-5 if year[_n+5]==1934
	bysort codeid: replace y1934_index=-4 if year[_n+4]==1934
	bysort codeid: replace y1934_index=-3 if year[_n+3]==1934
	bysort codeid: replace y1934_index=-2 if year[_n+2]==1934
	bysort codeid: replace y1934_index=-1 if year[_n+1]==1934
	bysort codeid: replace y1934_index=0 if year==1934
	bysort codeid: replace y1934_index=1 if year[_n-1]==1934
	bysort codeid: replace y1934_index=2 if year[_n-2]==1934
	bysort codeid: replace y1934_index=3 if year[_n-3]==1934
	bysort codeid: replace y1934_index=4 if year[_n-4]==1934
	bysort codeid: replace y1934_index=5 if year[_n-5]==1934
		
		**** War Debt Index 1931
		sort codeid year
		gen y1931_index=.
		bysort codeid: replace y1931_index=-5 if year[_n+5]==1931
		bysort codeid: replace y1931_index=-4 if year[_n+4]==1931
		bysort codeid: replace y1931_index=-3 if year[_n+3]==1931
		bysort codeid: replace y1931_index=-2 if year[_n+2]==1931
		bysort codeid: replace y1931_index=-1 if year[_n+1]==1931
		bysort codeid: replace y1931_index=0 if year==1931
		bysort codeid: replace y1931_index=1 if year[_n-1]==1931
		bysort codeid: replace y1931_index=2 if year[_n-2]==1931
		bysort codeid: replace y1931_index=3 if year[_n-3]==1931
		bysort codeid: replace y1931_index=4 if year[_n-4]==1931
		bysort codeid: replace y1931_index=5 if year[_n-5]==1931
	

	**** GDP (normalized to 1 in T=1934)
	
	sort codeid year
	gen GDP1934_index=.
	bysort codeid: replace GDP1934_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n+5] if y1934_index==-5
	bysort codeid: replace GDP1934_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n+4] if y1934_index==-4
	bysort codeid: replace GDP1934_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n+3] if y1934_index==-3
	bysort codeid: replace GDP1934_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n+2] if y1934_index==-2
	bysort codeid: replace GDP1934_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n+1] if y1934_index==-1
	bysort codeid: replace GDP1934_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED if y1934_index==0
	bysort codeid: replace GDP1934_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n-1] if y1934_index==1
	bysort codeid: replace GDP1934_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n-2] if y1934_index==2
	bysort codeid: replace GDP1934_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n-3] if y1934_index==3
	bysort codeid: replace GDP1934_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n-4] if y1934_index==4
	bysort codeid: replace GDP1934_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n-5] if y1934_index==5
	
	**** GDP (normalized to 1 in T=1931)
	
	sort codeid year
	gen GDP1931_index=.
	bysort codeid: replace GDP1931_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n+5] if y1931_index==-5
	bysort codeid: replace GDP1931_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n+4] if y1931_index==-4
	bysort codeid: replace GDP1931_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n+3] if y1931_index==-3
	bysort codeid: replace GDP1931_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n+2] if y1931_index==-2
	bysort codeid: replace GDP1931_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n+1] if y1931_index==-1
	bysort codeid: replace GDP1931_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED if y1931_index==0
	bysort codeid: replace GDP1931_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n-1] if y1931_index==1
	bysort codeid: replace GDP1931_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n-2] if y1931_index==2
	bysort codeid: replace GDP1931_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n-3] if y1931_index==3
	bysort codeid: replace GDP1931_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n-4] if y1931_index==4
	bysort codeid: replace GDP1931_index=gdp_pc_real_Maddison_TED/gdp_pc_real_Maddison_TED[_n-5] if y1931_index==5
	

	*** Rating (normalized to 1 in T=1934)
	sort codeid year
	gen Rating1934_index=.
	bysort codeid: replace Rating1934_index=moodys_interwar_num/moodys_interwar_num[_n+5] if y1934_index==-5
	bysort codeid: replace Rating1934_index=moodys_interwar_num/moodys_interwar_num[_n+4] if y1934_index==-4
	bysort codeid: replace Rating1934_index=moodys_interwar_num/moodys_interwar_num[_n+3] if y1934_index==-3
	bysort codeid: replace Rating1934_index=moodys_interwar_num/moodys_interwar_num[_n+2] if y1934_index==-2
	bysort codeid: replace Rating1934_index=moodys_interwar_num/moodys_interwar_num[_n+1] if y1934_index==-1
	bysort codeid: replace Rating1934_index=moodys_interwar_num/moodys_interwar_num if y1934_index==0
	bysort codeid: replace Rating1934_index=moodys_interwar_num/moodys_interwar_num[_n-1] if y1934_index==1
	bysort codeid: replace Rating1934_index=moodys_interwar_num/moodys_interwar_num[_n-2] if y1934_index==2
	bysort codeid: replace Rating1934_index=moodys_interwar_num/moodys_interwar_num[_n-3] if y1934_index==3
	bysort codeid: replace Rating1934_index=moodys_interwar_num/moodys_interwar_num[_n-4] if y1934_index==4
	bysort codeid: replace Rating1934_index=moodys_interwar_num/moodys_interwar_num[_n-5] if y1934_index==5
	
	*** Rating (normalized to 1 in T=1931)
	sort codeid year
	gen Rating1931_index=.
	bysort codeid: replace Rating1931_index=moodys_interwar_num/moodys_interwar_num[_n+5] if y1931_index==-5
	bysort codeid: replace Rating1931_index=moodys_interwar_num/moodys_interwar_num[_n+4] if y1931_index==-4
	bysort codeid: replace Rating1931_index=moodys_interwar_num/moodys_interwar_num[_n+3] if y1931_index==-3
	bysort codeid: replace Rating1931_index=moodys_interwar_num/moodys_interwar_num[_n+2] if y1931_index==-2
	bysort codeid: replace Rating1931_index=moodys_interwar_num/moodys_interwar_num[_n+1] if y1931_index==-1
	bysort codeid: replace Rating1931_index=moodys_interwar_num/moodys_interwar_num if y1931_index==0
	bysort codeid: replace Rating1931_index=moodys_interwar_num/moodys_interwar_num[_n-1] if y1931_index==1
	bysort codeid: replace Rating1931_index=moodys_interwar_num/moodys_interwar_num[_n-2] if y1931_index==2
	bysort codeid: replace Rating1931_index=moodys_interwar_num/moodys_interwar_num[_n-3] if y1931_index==3
	bysort codeid: replace Rating1931_index=moodys_interwar_num/moodys_interwar_num[_n-4] if y1931_index==4
	bysort codeid: replace Rating1931_index=moodys_interwar_num/moodys_interwar_num[_n-5] if y1931_index==5

	save Interwar_rep.dta, replace
***************************************************************************************************************
***************************************************************************************************************
********* MAIN GRAPHS
***************************************************************************************************************
***************************************************************************************************************
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
			
	
	************************
	*** 1934 summer defaults 
	
	
		*** Replicate Figures 3, 4, 5 and 6 (Stylized Facts in Section 3), and the 25%, 50% and 75% percentiles, respectively (Figure C.1 in the Appendix)
		
		*GDP (real, p.c., indexed at 1) around 1934 (Figure 3)
		tabstat GDP1934_index if WarDefaulters==1, by (y1934_index) stat(mean sd count median p75 p25)
		
		*Ratings (indexed at 1) around 1934 (Figure 4)
		tabstat Rating1934_index if WarDefaulters==1, by (y1934_index) stat(mean sd count median p75 p25)
		
		*Debt Service around 1934 (Figure 5)
		tabstat debtservGDP_interwar if WarDefaulters==1, by (y1934_index) stat(mean sd count median p75 p25)
		
		*Debt/GDP around 1934 (Figure 6)
		tabstat debt_gdpAbbas if WarDefaulters==1, by (y1934_index) stat(mean sd count median p75 p25)
		
		*******************************************
		*** Difference in Difference Analysis 1934 --- Figure 8 and Figure C.6 in the Appendix
		*** Treatment vs Control Group
		
		
		*GDP (normalized to 1 in 1934) --- Right Panel of Figure 8
			*Treatment Group (Defaulters):
			tabstat GDP1934_index if WarDefaulters==1, by (y1934_index) stat(mean sd count)
			*** Control Group:
			/*Europe*/ tabstat GDP1934_index if Nodefault_Europe==1, by (y1934_index) stat(mean sd count)
			/*World*/ tabstat GDP1934_index if WarCounterfact_all==1, by (y1934_index) stat(mean sd count)

		*Residual growth (Figure C.6)
			*Treatment Group (Defaulters):
			tabstat residgrowth_def if WarDefaulters==1, by (y1934_index) stat(mean sd count)
			*Control Group (European Non-Defaulters):
			tabstat residgrowth_counter if Nodefault_Europe==1, by (y1934_index) stat(mean sd count)
	
		*Ratings (Figure C.6)
			*Treatment Group (Defaulters):
			tabstat Rating1934_index if WarDefaulters==1, by (y1934_index) stat(mean sd count median)
			*Control Group (European Non-Defaulters):
			tabstat Rating1934_index if Nodefault_Europe==1, by (y1934_index) stat(mean sd count)
		
		**Debt Service to Revenues (Figure C.6)
			*Treatment Group (Defaulters):
			tabstat debtservRevenue_interwar if WarDefaulters==1, by (y1934_index) stat(mean sd count)
			*Control Group (European Non-Defaulters):
			tabstat debtservRevenue_interwar if Nodefault_Europe==1, by (y1934_index) stat(mean sd count)
		
		**Debt/GDP, data from Abbas et al. 2011 (Figure C.6)
			*Treatment Group (Defaulters):
			tabstat debt_gdpAbbas if WarDefaulters==1, by (y1934_index) stat(mean sd count)
			*Control Group (European Non-Defaulters):
			tabstat debt_gdpAbbas if Nodefault_Europe==1, by (y1934_index) stat(mean sd count)
		
		
	**************
	*** Dispersion Stats (Table C.2 in the Appendix)
	
			tabstat GDP1934_index if WarDefaulters==1, by (y1934_index) stat(mean max min p25 median p75 sd)

			
	*************************
	*** 1931 Hoover Moratorium
	
		*******************************************
		*** Difference in Difference Analysis 1931 --- Figure 8 and Figure C.5 in the Appendix
		*** Treatment vs Control Group
		
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
		
		


***********************************************************************
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
				
		*=============================================================================
* PARALLEL TRENDS TESTS
*=============================================================================

*=============================================================================
* SETUP FOR PARALLEL TRENDS TESTS
*=============================================================================

* Set panel structure and generate year dummies
xtset codeid year
xi i.year

bysort codeid: gen interrating_growth=(d.moodys_interwar_num/moodys_interwar_num[_n-1])*100

*=============================================================================
* PARALLEL TRENDS TESTS
*=============================================================================

*-----------------------------------------------------------------------------
* 1934 DEFAULT EVENT - PARALLEL TRENDS TEST
*-----------------------------------------------------------------------------

* Generate lead and lag indicators for 1934 event
forval i = 5(-1)1 {
    capture drop lead`i'_1934 lead`i'_1934_all
    gen lead`i'_1934 = (y1934_index == -`i') & WarDefaulters==1
    gen lead`i'_1934_all = (y1934_index == -`i')
}

forval i = 1/5 {
    capture drop lag`i'_1934 lag`i'_1934_all
    gen lag`i'_1934 = (y1934_index == `i') & WarDefaulters==1
    gen lag`i'_1934_all = (y1934_index == `i')
}

* Parallel trends test for GDP growth (1934) - Small Sample
quietly xtreg growth_gdp_pc_real_Maddison_TED lead5_1934 lead4_1934 lead3_1934 lead2_1934 ///
    lag1_1934 lag2_1934 lag3_1934 lag4_1934 lag5_1934 _Iyear_* ///
    if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store pt_growth1934_small

* Test joint significance of leads (pre-treatment periods)
test lead5_1934 lead4_1934 lead3_1934 lead2_1934
local p_val_growth1934_small = r(p)
display "1934 GDP Growth (Small Sample) - Parallel Trends Test p-value: " `p_val_growth1934_small'

* Parallel trends test for GDP growth (1934) - Large Sample  
quietly xtreg growth_gdp_pc_real_Maddison_TED lead5_1934 lead4_1934 lead3_1934 lead2_1934 ///
    lag1_1934 lag2_1934 lag3_1934 lag4_1934 lag5_1934 _Iyear_* ///
    if DiD1934_5year==1 & WarAllSample==1, fe cluster(codeid)
estimates store pt_growth1934_large

test lead5_1934 lead4_1934 lead3_1934 lead2_1934
local p_val_growth1934_large = r(p)
display "1934 GDP Growth (Large Sample) - Parallel Trends Test p-value: " `p_val_growth1934_large'

* Parallel trends test for Credit Ratings (1934)
quietly xtreg interrating_growth lead5_1934 lead4_1934 lead3_1934 lead2_1934 ///
    lag1_1934 lag2_1934 lag3_1934 lag4_1934 lag5_1934 _Iyear_* ///
    if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store pt_ratings1934

test lead5_1934 lead4_1934 lead3_1934 lead2_1934
local p_val_ratings1934 = r(p)
display "1934 Credit Ratings - Parallel Trends Test p-value: " `p_val_ratings1934'

* Parallel trends test for Debt Service to Revenue (1934) - Small Sample
quietly xtreg debtservRevenue_interwar lead5_1934 lead4_1934 lead3_1934 lead2_1934 ///
    lag1_1934 lag2_1934 lag3_1934 lag4_1934 lag5_1934 _Iyear_* ///
    if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store pt_debtserv1934_small

test lead5_1934 lead4_1934 lead3_1934 lead2_1934
local p_val_debtserv1934_small = r(p)
display "1934 Debt Service (Small Sample) - Parallel Trends Test p-value: " `p_val_debtserv1934_small'

* Parallel trends test for Debt Service to Revenue (1934) - Large Sample
quietly xtreg debtservRevenue_interwar lead5_1934 lead4_1934 lead3_1934 lead2_1934 ///
    lag1_1934 lag2_1934 lag3_1934 lag4_1934 lag5_1934 _Iyear_* ///
    if DiD1934_5year==1 & WarAllSample==1, fe cluster(codeid)
estimates store pt_debtserv1934_large

test lead5_1934 lead4_1934 lead3_1934 lead2_1934
local p_val_debtserv1934_large = r(p)
display "1934 Debt Service (Large Sample) - Parallel Trends Test p-value: " `p_val_debtserv1934_large'

* Parallel trends test for Debt/GDP (1934) - Small Sample
quietly xtreg debt_gdpAbbas lead5_1934 lead4_1934 lead3_1934 lead2_1934 ///
    lag1_1934 lag2_1934 lag3_1934 lag4_1934 lag5_1934 _Iyear_* ///
    if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store pt_debt1934_small

test lead5_1934 lead4_1934 lead3_1934 lead2_1934
local p_val_debt1934_small = r(p)
display "1934 Debt/GDP (Small Sample) - Parallel Trends Test p-value: " `p_val_debt1934_small'

* Parallel trends test for Debt/GDP (1934) - Large Sample
quietly xtreg debt_gdpAbbas lead5_1934 lead4_1934 lead3_1934 lead2_1934 ///
    lag1_1934 lag2_1934 lag3_1934 lag4_1934 lag5_1934 _Iyear_* ///
    if DiD1934_5year==1 & WarAllSample==1, fe cluster(codeid)
estimates store pt_debt1934_large

test lead5_1934 lead4_1934 lead3_1934 lead2_1934
local p_val_debt1934_large = r(p)
display "1934 Debt/GDP (Large Sample) - Parallel Trends Test p-value: " `p_val_debt1934_large'

* Parallel trends test for External Debt/GDP (1934)
quietly xtreg ext_debt_gdp lead5_1934 lead4_1934 lead3_1934 lead2_1934 ///
    lag1_1934 lag2_1934 lag3_1934 lag4_1934 lag5_1934 _Iyear_* ///
    if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store pt_extdebt1934

test lead5_1934 lead4_1934 lead3_1934 lead2_1934
local p_val_extdebt1934 = r(p)
display "1934 External Debt/GDP - Parallel Trends Test p-value: " `p_val_extdebt1934'

*-----------------------------------------------------------------------------
* 1931 HOOVER MORATORIUM - PARALLEL TRENDS TEST
*-----------------------------------------------------------------------------

* Generate lead and lag indicators for 1931 event
forval i = 5(-1)1 {
    capture drop lead`i'_1931
    gen lead`i'_1931 = (y1931_index == -`i') & WarDefaulters==1
}

forval i = 1/5 {
    capture drop lag`i'_1931
    gen lag`i'_1931 = (y1931_index == `i') & WarDefaulters==1
}

* Parallel trends test for GDP growth (1931) - Small Sample
quietly xtreg growth_gdp_pc_real_Maddison_TED lead5_1931 lead4_1931 lead3_1931 lead2_1931 ///
    lag1_1931 lag2_1931 lag3_1931 lag4_1931 lag5_1931 _Iyear_* ///
    if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store pt_growth1931_small

test lead5_1931 lead4_1931 lead3_1931 lead2_1931
local p_val_growth1931_small = r(p)
display "1931 GDP Growth (Small Sample) - Parallel Trends Test p-value: " `p_val_growth1931_small'

* Parallel trends test for GDP growth (1931) - Large Sample
quietly xtreg growth_gdp_pc_real_Maddison_TED lead5_1931 lead4_1931 lead3_1931 lead2_1931 ///
    lag1_1931 lag2_1931 lag3_1931 lag4_1931 lag5_1931 _Iyear_* ///
    if DiD1931_5year==1 & WarAllSample==1, fe cluster(codeid)
estimates store pt_growth1931_large

test lead5_1931 lead4_1931 lead3_1931 lead2_1931
local p_val_growth1931_large = r(p)
display "1931 GDP Growth (Large Sample) - Parallel Trends Test p-value: " `p_val_growth1931_large'

* Parallel trends test for Credit Ratings (1931)
quietly xtreg interrating_growth lead5_1931 lead4_1931 lead3_1931 lead2_1931 ///
    lag1_1931 lag2_1931 lag3_1931 lag4_1931 lag5_1931 _Iyear_* ///
    if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store pt_ratings1931

test lead5_1931 lead4_1931 lead3_1931 lead2_1931
local p_val_ratings1931 = r(p)
display "1931 Credit Ratings - Parallel Trends Test p-value: " `p_val_ratings1931'

* Parallel trends test for Debt Service to Revenue (1931) - Small Sample
quietly xtreg debtservRevenue_interwar lead5_1931 lead4_1931 lead3_1931 lead2_1931 ///
    lag1_1931 lag2_1931 lag3_1931 lag4_1931 lag5_1931 _Iyear_* ///
    if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store pt_debtserv1931_small

test lead5_1931 lead4_1931 lead3_1931 lead2_1931
local p_val_debtserv1931_small = r(p)
display "1931 Debt Service (Small Sample) - Parallel Trends Test p-value: " `p_val_debtserv1931_small'

* Parallel trends test for Debt Service to Revenue (1931) - Large Sample
quietly xtreg debtservRevenue_interwar lead5_1931 lead4_1931 lead3_1931 lead2_1931 ///
    lag1_1931 lag2_1931 lag3_1931 lag4_1931 lag5_1931 _Iyear_* ///
    if DiD1931_5year==1 & WarAllSample==1, fe cluster(codeid)
estimates store pt_debtserv1931_large

test lead5_1931 lead4_1931 lead3_1931 lead2_1931
local p_val_debtserv1931_large = r(p)
display "1931 Debt Service (Large Sample) - Parallel Trends Test p-value: " `p_val_debtserv1931_large'

* Parallel trends test for Debt/GDP (1931) - Small Sample
quietly xtreg debt_gdpAbbas lead5_1931 lead4_1931 lead3_1931 lead2_1931 ///
    lag1_1931 lag2_1931 lag3_1931 lag4_1931 lag5_1931 _Iyear_* ///
    if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store pt_debt1931_small

test lead5_1931 lead4_1931 lead3_1931 lead2_1931
local p_val_debt1931_small = r(p)
display "1931 Debt/GDP (Small Sample) - Parallel Trends Test p-value: " `p_val_debt1931_small'

* Parallel trends test for Debt/GDP (1931) - Large Sample
quietly xtreg debt_gdpAbbas lead5_1931 lead4_1931 lead3_1931 lead2_1931 ///
    lag1_1931 lag2_1931 lag3_1931 lag4_1931 lag5_1931 _Iyear_* ///
    if DiD1931_5year==1 & WarAllSample==1, fe cluster(codeid)
estimates store pt_debt1931_large

test lead5_1931 lead4_1931 lead3_1931 lead2_1931
local p_val_debt1931_large = r(p)
display "1931 Debt/GDP (Large Sample) - Parallel Trends Test p-value: " `p_val_debt1931_large'

* Parallel trends test for External Debt/GDP (1931)
quietly xtreg ext_debt_gdp lead5_1931 lead4_1931 lead3_1931 lead2_1931 ///
    lag1_1931 lag2_1931 lag3_1931 lag4_1931 lag5_1931 _Iyear_* ///
    if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store pt_extdebt1931

test lead5_1931 lead4_1931 lead3_1931 lead2_1931
local p_val_extdebt1931 = r(p)
display "1931 External Debt/GDP - Parallel Trends Test p-value: " `p_val_extdebt1931'

*-----------------------------------------------------------------------------
* GENERATE PARALLEL TRENDS TEST RESULTS SUMMARY
*-----------------------------------------------------------------------------

* Create matrix to store results
matrix pt_results = J(16, 3, .)
matrix rownames pt_results = "GDP_Growth_1934_Small" "GDP_Growth_1934_Large" ///
    "Ratings_1934" "DebtServ_1934_Small" "DebtServ_1934_Large" ///
    "Debt_GDP_1934_Small" "Debt_GDP_1934_Large" "ExtDebt_1934" ///
    "GDP_Growth_1931_Small" "GDP_Growth_1931_Large" ///
    "Ratings_1931" "DebtServ_1931_Small" "DebtServ_1931_Large" ///
    "Debt_GDP_1931_Small" "Debt_GDP_1931_Large" "ExtDebt_1931"
matrix colnames pt_results = "P_Value" "Pass_5pct" "Pass_10pct"

* Fill in results
matrix pt_results[1,1] = `p_val_growth1934_small'
matrix pt_results[1,2] = (`p_val_growth1934_small' > 0.05)
matrix pt_results[1,3] = (`p_val_growth1934_small' > 0.10)

matrix pt_results[2,1] = `p_val_growth1934_large'
matrix pt_results[2,2] = (`p_val_growth1934_large' > 0.05)
matrix pt_results[2,3] = (`p_val_growth1934_large' > 0.10)

matrix pt_results[3,1] = `p_val_ratings1934'
matrix pt_results[3,2] = (`p_val_ratings1934' > 0.05)
matrix pt_results[3,3] = (`p_val_ratings1934' > 0.10)

matrix pt_results[4,1] = `p_val_debtserv1934_small'
matrix pt_results[4,2] = (`p_val_debtserv1934_small' > 0.05)
matrix pt_results[4,3] = (`p_val_debtserv1934_small' > 0.10)

matrix pt_results[5,1] = `p_val_debtserv1934_large'
matrix pt_results[5,2] = (`p_val_debtserv1934_large' > 0.05)
matrix pt_results[5,3] = (`p_val_debtserv1934_large' > 0.10)

matrix pt_results[6,1] = `p_val_debt1934_small'
matrix pt_results[6,2] = (`p_val_debt1934_small' > 0.05)
matrix pt_results[6,3] = (`p_val_debt1934_small' > 0.10)

matrix pt_results[7,1] = `p_val_debt1934_large'
matrix pt_results[7,2] = (`p_val_debt1934_large' > 0.05)
matrix pt_results[7,3] = (`p_val_debt1934_large' > 0.10)

matrix pt_results[8,1] = `p_val_extdebt1934'
matrix pt_results[8,2] = (`p_val_extdebt1934' > 0.05)
matrix pt_results[8,3] = (`p_val_extdebt1934' > 0.10)

matrix pt_results[9,1] = `p_val_growth1931_small'
matrix pt_results[9,2] = (`p_val_growth1931_small' > 0.05)
matrix pt_results[9,3] = (`p_val_growth1931_small' > 0.10)

matrix pt_results[10,1] = `p_val_growth1931_large'
matrix pt_results[10,2] = (`p_val_growth1931_large' > 0.05)
matrix pt_results[10,3] = (`p_val_growth1931_large' > 0.10)

matrix pt_results[11,1] = `p_val_ratings1931'
matrix pt_results[11,2] = (`p_val_ratings1931' > 0.05)
matrix pt_results[11,3] = (`p_val_ratings1931' > 0.10)

matrix pt_results[12,1] = `p_val_debtserv1931_small'
matrix pt_results[12,2] = (`p_val_debtserv1931_small' > 0.05)
matrix pt_results[12,3] = (`p_val_debtserv1931_small' > 0.10)

matrix pt_results[13,1] = `p_val_debtserv1931_large'
matrix pt_results[13,2] = (`p_val_debtserv1931_large' > 0.05)
matrix pt_results[13,3] = (`p_val_debtserv1931_large' > 0.10)

matrix pt_results[14,1] = `p_val_debt1931_small'
matrix pt_results[14,2] = (`p_val_debt1931_small' > 0.05)
matrix pt_results[14,3] = (`p_val_debt1931_small' > 0.10)

matrix pt_results[15,1] = `p_val_debt1931_large'
matrix pt_results[15,2] = (`p_val_debt1931_large' > 0.05)
matrix pt_results[15,3] = (`p_val_debt1931_large' > 0.10)

matrix pt_results[16,1] = `p_val_extdebt1931'
matrix pt_results[16,2] = (`p_val_extdebt1931' > 0.05)
matrix pt_results[16,3] = (`p_val_extdebt1931' > 0.10)

* Display results
display ""
display "=== PARALLEL TRENDS TEST RESULTS ==="
display ""
matrix list pt_results

*-----------------------------------------------------------------------------
* GENERATE PARALLEL TRENDS PLOTS
*-----------------------------------------------------------------------------

* Install required packages for plotting
capture ssc install coefplot
capture ssc install grstyle

*-----------------------------------------------------------------------------
* 1934 DEFAULT EVENT - PARALLEL TRENDS PLOTS
*-----------------------------------------------------------------------------

* Plot for GDP Growth (Small Sample) - 1934
coefplot pt_growth1934_small, ///
    keep(lead5_1934 lead4_1934 lead3_1934 lead2_1934 lag1_1934 lag2_1934 lag3_1934 lag4_1934 lag5_1934) ///
    vertical ///
    yline(0, lcolor(red) lpattern(dash)) ///
    xlabel(1 "t-5" 2 "t-4" 3 "t-3" 4 "t-2" 5 "t+1" 6 "t+2" 7 "t+3" 8 "t+4" 9 "t+5") ///
	ytitle("") ///
    title("Parallel Trends Test: GDP Growth (1934 Default)") ///
    subtitle("Small Counterfactual (Europe)") ///
    note("Pre-treatment coefficients (t-5 to t-2) test parallel trends assumption") ///
    graphregion(color(white)) plotregion(color(white))
graph export "PT_GDP_1934_Small.png", replace width(800) height(600)

* Plot for GDP Growth (Large Sample) - 1934
coefplot pt_growth1934_large, ///
    keep(lead5_1934 lead4_1934 lead3_1934 lead2_1934 lag1_1934 lag2_1934 lag3_1934 lag4_1934 lag5_1934) ///
    vertical ///
    yline(0, lcolor(red) lpattern(dash)) ///
    xlabel(1 "t-5" 2 "t-4" 3 "t-3" 4 "t-2" 5 "t+1" 6 "t+2" 7 "t+3" 8 "t+4" 9 "t+5") ///
		ytitle("") ///
    title("Parallel Trends Test: GDP Growth (1934 Default)") ///
    subtitle("Large Counterfactual (World)") ///
    note("Pre-treatment coefficients (t-5 to t-2) test parallel trends assumption") ///
    graphregion(color(white)) plotregion(color(white))
graph export "PT_GDP_1934_Large.png", replace width(800) height(600)

* Plot for Credit Ratings - 1934
coefplot pt_ratings1934, ///
    keep(lead5_1934 lead4_1934 lead3_1934 lead2_1934 lag1_1934 lag2_1934 lag3_1934 lag4_1934 lag5_1934) ///
    vertical ///
    yline(0, lcolor(red) lpattern(dash)) ///
    xlabel(1 "t-5" 2 "t-4" 3 "t-3" 4 "t-2" 5 "t+1" 6 "t+2" 7 "t+3" 8 "t+4" 9 "t+5") ///
		ytitle("") ///
    title("Parallel Trends Test: Credit Ratings (1934 Default)") ///
    subtitle("Small Counterfactual (Europe)") ///
    note("Pre-treatment coefficients (t-5 to t-2) test parallel trends assumption") ///
    graphregion(color(white)) plotregion(color(white))
graph export "PT_Ratings_1934.png", replace width(800) height(600)

* Plot for Debt Service to Revenue (Small Sample) - 1934
coefplot pt_debtserv1934_small, ///
    keep(lead5_1934 lead4_1934 lead3_1934 lead2_1934 lag1_1934 lag2_1934 lag3_1934 lag4_1934 lag5_1934) ///
    vertical ///
    yline(0, lcolor(red) lpattern(dash)) ///
    xlabel(1 "t-5" 2 "t-4" 3 "t-3" 4 "t-2" 5 "t+1" 6 "t+2" 7 "t+3" 8 "t+4" 9 "t+5") ///
		ytitle("") ///
    title("Parallel Trends Test: Debt Service to Revenue (1934 Default)") ///
    subtitle("Small Counterfactual (Europe)") ///
    note("Pre-treatment coefficients (t-5 to t-2) test parallel trends assumption") ///
    graphregion(color(white)) plotregion(color(white))
graph export "PT_DebtServ_1934_Small.png", replace width(800) height(600)

* Plot for Debt/GDP (Small Sample) - 1934
coefplot pt_debt1934_small, ///
    keep(lead5_1934 lead4_1934 lead3_1934 lead2_1934 lag1_1934 lag2_1934 lag3_1934 lag4_1934 lag5_1934) ///
    vertical ///
    yline(0, lcolor(red) lpattern(dash)) ///
    xlabel(1 "t-5" 2 "t-4" 3 "t-3" 4 "t-2" 5 "t+1" 6 "t+2" 7 "t+3" 8 "t+4" 9 "t+5") ///
		ytitle("") ///
    title("Parallel Trends Test: Debt/GDP (1934 Default)") ///
    subtitle("Small Counterfactual (Europe)") ///
    note("Pre-treatment coefficients (t-5 to t-2) test parallel trends assumption") ///
    graphregion(color(white)) plotregion(color(white))
graph export "PT_Debt_1934_Small.png", replace width(800) height(600)

* Plot for External Debt/GDP - 1934
coefplot pt_extdebt1934, ///
    keep(lead5_1934 lead4_1934 lead3_1934 lead2_1934 lag1_1934 lag2_1934 lag3_1934 lag4_1934 lag5_1934) ///
    vertical ///
    yline(0, lcolor(red) lpattern(dash)) ///
    xlabel(1 "t-5" 2 "t-4" 3 "t-3" 4 "t-2" 5 "t+1" 6 "t+2" 7 "t+3" 8 "t+4" 9 "t+5") ///
		ytitle("") ///
    title("Parallel Trends Test: External Debt/GDP (1934 Default)") ///
    subtitle("Small Counterfactual (Europe)") ///
    note("Pre-treatment coefficients (t-5 to t-2) test parallel trends assumption") ///
    graphregion(color(white)) plotregion(color(white))
graph export "PT_ExtDebt_1934.png", replace width(800) height(600)

*-----------------------------------------------------------------------------
* 1931 HOOVER MORATORIUM - PARALLEL TRENDS PLOTS
*-----------------------------------------------------------------------------

* Plot for GDP Growth (Small Sample) - 1931
coefplot pt_growth1931_small, ///
    keep(lead5_1931 lead4_1931 lead3_1931 lead2_1931 lag1_1931 lag2_1931 lag3_1931 lag4_1931 lag5_1931) ///
    vertical ///
    yline(0, lcolor(red) lpattern(dash)) ///
    xlabel(1 "t-5" 2 "t-4" 3 "t-3" 4 "t-2" 5 "t+1" 6 "t+2" 7 "t+3" 8 "t+4" 9 "t+5") ///
		ytitle("") ///
    title("Parallel Trends Test: GDP Growth (1931 Hoover Moratorium)") ///
    subtitle("Small Counterfactual (Europe)") ///
    note("Pre-treatment coefficients (t-5 to t-2) test parallel trends assumption") ///
    graphregion(color(white)) plotregion(color(white))
graph export "PT_GDP_1931_Small.png", replace width(800) height(600)

* Plot for GDP Growth (Large Sample) - 1931
coefplot pt_growth1931_large, ///
    keep(lead5_1931 lead4_1931 lead3_1931 lead2_1931 lag1_1931 lag2_1931 lag3_1931 lag4_1931 lag5_1931) ///
    vertical ///
    yline(0, lcolor(red) lpattern(dash)) ///
    xlabel(1 "t-5" 2 "t-4" 3 "t-3" 4 "t-2" 5 "t+1" 6 "t+2" 7 "t+3" 8 "t+4" 9 "t+5") ///
		ytitle("") ///
    title("Parallel Trends Test: GDP Growth (1931 Hoover Moratorium)") ///
    subtitle("Large Counterfactual (World)") ///
    note("Pre-treatment coefficients (t-5 to t-2) test parallel trends assumption") ///
    graphregion(color(white)) plotregion(color(white))
graph export "PT_GDP_1931_Large.png", replace width(800) height(600)

* Plot for Credit Ratings - 1931
coefplot pt_ratings1931, ///
    keep(lead5_1931 lead4_1931 lead3_1931 lead2_1931 lag1_1931 lag2_1931 lag3_1931 lag4_1931 lag5_1931) ///
    vertical ///
    yline(0, lcolor(red) lpattern(dash)) ///
    xlabel(1 "t-5" 2 "t-4" 3 "t-3" 4 "t-2" 5 "t+1" 6 "t+2" 7 "t+3" 8 "t+4" 9 "t+5") ///
		ytitle("") ///
    title("Parallel Trends Test: Credit Ratings (1931 Hoover Moratorium)") ///
    subtitle("Small Counterfactual (Europe)") ///
    note("Pre-treatment coefficients (t-5 to t-2) test parallel trends assumption") ///
    graphregion(color(white)) plotregion(color(white))
graph export "PT_Ratings_1931.png", replace width(800) height(600)

* Plot for Debt Service to Revenue (Small Sample) - 1931
coefplot pt_debtserv1931_small, ///
    keep(lead5_1931 lead4_1931 lead3_1931 lead2_1931 lag1_1931 lag2_1931 lag3_1931 lag4_1931 lag5_1931) ///
    vertical ///
    yline(0, lcolor(red) lpattern(dash)) ///
    xlabel(1 "t-5" 2 "t-4" 3 "t-3" 4 "t-2" 5 "t+1" 6 "t+2" 7 "t+3" 8 "t+4" 9 "t+5") ///
		ytitle("") ///
    title("Parallel Trends Test: Debt Service to Revenue (1931 Hoover Moratorium)") ///
    subtitle("Small Counterfactual (Europe)") ///
    note("Pre-treatment coefficients (t-5 to t-2) test parallel trends assumption") ///
    graphregion(color(white)) plotregion(color(white))
graph export "PT_DebtServ_1931_Small.png", replace width(800) height(600)

* Plot for Debt/GDP (Small Sample) - 1931
coefplot pt_debt1931_small, ///
    keep(lead5_1931 lead4_1931 lead3_1931 lead2_1931 lag1_1931 lag2_1931 lag3_1931 lag4_1931 lag5_1931) ///
    vertical ///
    yline(0, lcolor(red) lpattern(dash)) ///
    xlabel(1 "t-5" 2 "t-4" 3 "t-3" 4 "t-2" 5 "t+1" 6 "t+2" 7 "t+3" 8 "t+4" 9 "t+5") ///
		ytitle("") ///
    title("Parallel Trends Test: Debt/GDP (1931 Hoover Moratorium)") ///
    subtitle("Small Counterfactual (Europe)") ///
    note("Pre-treatment coefficients (t-5 to t-2) test parallel trends assumption") ///
    graphregion(color(white)) plotregion(color(white))
graph export "PT_Debt_1931_Small.png", replace width(800) height(600)

* Plot for External Debt/GDP - 1931
coefplot pt_extdebt1931, ///
    keep(lead5_1931 lead4_1931 lead3_1931 lead2_1931 lag1_1931 lag2_1931 lag3_1931 lag4_1931 lag5_1931) ///
    vertical ///
    yline(0, lcolor(red) lpattern(dash)) ///
    xlabel(1 "t-5" 2 "t-4" 3 "t-3" 4 "t-2" 5 "t+1" 6 "t+2" 7 "t+3" 8 "t+4" 9 "t+5") ///
		ytitle("") ///
    title("Parallel Trends Test: External Debt/GDP (1931 Hoover Moratorium)") ///
    subtitle("Small Counterfactual (Europe)") ///
    note("Pre-treatment coefficients (t-5 to t-2) test parallel trends assumption") ///
    graphregion(color(white)) plotregion(color(white))
graph export "PT_ExtDebt_1931.png", replace width(800) height(600)

// *-----------------------------------------------------------------------------
// * COMBINED PLOTS FOR MAIN VARIABLES
// *-----------------------------------------------------------------------------
//
// * Combined plot for GDP Growth (both events and samples)
// graph combine "PT_GDP_1931_Small.gph" "PT_GDP_1931_Large.gph" ///
//               "PT_GDP_1934_Small.gph" "PT_GDP_1934_Large.gph", ///
//     title("Parallel Trends Tests: GDP Growth") ///
//     subtitle("1931 Hoover Moratorium vs. 1934 Summer Defaults") ///
//     note("Red dashed line indicates zero effect. Pre-treatment period: t-5 to t-2") ///
//     graphregion(color(white)) plotregion(color(white))
// graph save "PT_GDP_Combined.gph", replace
// graph export "PT_GDP_Combined.png", replace width(1200) height(800)
//
// * Combined plot for Credit Ratings (both events)
// graph combine "PT_Ratings_1931.gph" "PT_Ratings_1934.gph", ///
//     title("Parallel Trends Tests: Credit Ratings") ///
//     subtitle("1931 Hoover Moratorium vs. 1934 Summer Defaults") ///
//     note("Red dashed line indicates zero effect. Pre-treatment period: t-5 to t-2") ///
//     graphregion(color(white)) plotregion(color(white))
// graph export "PT_Ratings_Combined.png", replace width(1200) height(600)
//
// * Combined plot for Debt Indicators (1934 event)
// graph combine "PT_DebtServ_1934_Small.gph" "PT_Debt_1934_Small.gph" ///
//               "PT_ExtDebt_1934.gph", ///
//     title("Parallel Trends Tests: Debt Indicators (1934 Default)") ///
//     subtitle("Debt Service, Debt/GDP, and External Debt") ///
//     note("Red dashed line indicates zero effect. Pre-treatment period: t-5 to t-2") ///
//     graphregion(color(white)) plotregion(color(white))
// graph export "PT_Debt_1934_Combined.png", replace width(1200) height(800)


	*******************************
	*** DIFFERENCE IN DIFFERENCE REGRESSIONS
	
// 	xtset codeid year
// 	xi i.year
	
		
	*********************************************************************
	******* 1934 DiD Analysis *******************************************
	
		***********************************
		*** GDP growth (real p.c.) 1934 ***
			
			* Main Regression (Table 4, Column 1)
			*=============================================================================
* ROBUSTNESS CHECKS TABLE - 1934 SUMMER DEFAULTS GDP GROWTH
*=============================================================================

* Run all robustness checks and store results
local robustness_checks ""

* 1. Main regression (baseline)
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store robust_baseline
local robustness_checks "`robustness_checks' robust_baseline"

* 2. No year fixed effects
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store robust_no_year_fe
local robustness_checks "`robustness_checks' robust_no_year_fe"

* 3. 3-year window
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_3year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store robust_3year
local robustness_checks "`robustness_checks' robust_3year"

* 4. 4-year window
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_4year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store robust_4year
local robustness_checks "`robustness_checks' robust_4year"

* 5. 6-year window
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_6year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store robust_6year
local robustness_checks "`robustness_checks' robust_6year"

* 6. Center around 1933 (placebo)
quietly xtreg growth_gdp_pc_real_Maddison_TED after1933 after_default33 _Iyear_* if DiD1933_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store robust_placebo_1933
local robustness_checks "`robustness_checks' robust_placebo_1933"

* 7. Exclude treatment year
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & y1934_index!=0, fe cluster(codeid)
estimates store robust_excl_treat_year
local robustness_checks "`robustness_checks' robust_excl_treat_year"

* 8. With inflation control
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default inflation_RR _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store robust_inflation
local robustness_checks "`robustness_checks' robust_inflation"

* 9. With banking and currency crises controls
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default bankingcrises currencycrises _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store robust_crises
local robustness_checks "`robustness_checks' robust_crises"

* 10. With war controls
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default Intrastateconflict InterstateConflict _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store robust_wars
local robustness_checks "`robustness_checks' robust_wars"

* 11. With political controls
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default domestic4 domestic6 domestic7 _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
estimates store robust_politics
local robustness_checks "`robustness_checks' robust_politics"

* 12. Drop Eastern Europe
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & EasternEurope!=1, fe cluster(codeid)
estimates store robust_no_east_europe
local robustness_checks "`robustness_checks' robust_no_east_europe"

* 13. Europe Only
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="New Zealand" & country!="Australia", fe cluster(codeid)
estimates store robust_europe_only
local robustness_checks "`robustness_checks' robust_europe_only"

* 14. Drop Germany
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="Germany", fe cluster(codeid)
estimates store robust_no_germany
local robustness_checks "`robustness_checks' robust_no_germany"

* 15. Drop Australia and New Zealand
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="Australia" & country!="New Zealand", fe cluster(codeid)
estimates store robust_no_aus_nz
local robustness_checks "`robustness_checks' robust_no_aus_nz"

* 16. Drop largest debt relief countries
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="France" & country!="Greece" & country!="Italy", fe cluster(codeid)
estimates store robust_no_large_relief
local robustness_checks "`robustness_checks' robust_no_large_relief"

* 17. Drop smallest debt relief countries
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="Austria" & country!="Belgium" & country!="Australia", fe cluster(codeid)
estimates store robust_no_small_relief
local robustness_checks "`robustness_checks' robust_no_small_relief"

* 18. Drop best GDP performers
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="Germany" & country!="Austria" & country!="New Zealand", fe cluster(codeid)
estimates store robust_no_best_gdp
local robustness_checks "`robustness_checks' robust_no_best_gdp"

* 19. Drop worst GDP performers
quietly xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="Greece" & country!="Portugal" & country!="Belgium", fe cluster(codeid)
estimates store robust_no_worst_gdp
local robustness_checks "`robustness_checks' robust_no_worst_gdp"

*=============================================================================
* GENERATE ROBUSTNESS TABLE USING ESTTAB
*=============================================================================

esttab `robustness_checks' ///
    using "Table_Robustness_1934_GDP.tex", ///
    replace ///
    title("Table A1: Robustness Checks - 1934 Summer Defaults Effect on GDP Growth") ///
    mtitles("Baseline" "No Year FE" "3-Year Window" "4-Year Window" "6-Year Window" ///
            "Placebo 1933" "Excl. Treat Year" "With Inflation" "With Crises" "With Wars" ///
            "With Politics" "No East Europe" "Europe Only" "No Germany" "No Aus/NZ" ///
            "No Large Relief" "No Small Relief" "No Best GDP" "No Worst GDP") ///
    keep(after_default) ///
    coeflabels(after_default "Treatment Effect") ///
    stats(N r2_a, ///
          labels("Observations" "Adjusted R²") ///
          fmt(%9.0f %9.3f)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    se ///
    b(%9.3f) ///
    se(%9.3f) ///
    brackets ///
    booktabs ///
    compress ///
    nogaps ///
    wide ///
    prehead("\begin{sidewaystable}[htbp]\centering" ///
            "\renewcommand{\arraystretch}{1.2}" ///
            "\caption{Table A1: Robustness Checks - 1934 Summer Defaults Effect on GDP Growth}" ///
            "\label{tab:robustness_1934}" ///
            "\begin{adjustbox}{width=\textwidth,center}" ///
            "\begin{tabular}{@{\extracolsep{5pt}}l*{19}{c}@{}}" ///
            "\toprule") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
             "\end{tabular}" ///
             "\end{adjustbox}" ///
             "\end{sidewaystable}") ///
    addnote("Notes: This table presents robustness checks for the main result on the effect" ///
            "of the 1934 summer defaults on real per capita GDP growth. The baseline specification" ///
            "includes country and year fixed effects with standard errors clustered at the country level." ///
            "Column (1) replicates the main result from Table 4. Columns (2)-(19) show results under" ///
            "various alternative specifications and sample restrictions. Treatment effect measures" ///
            "the impact of war debt default on GDP growth in the post-1934 period." ///
            "Significance levels: * p$<$0.10, ** p$<$0.05, *** p$<$0.01")
		
			xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
			estimates store growth1934_FE_nodef
			
			* Robsutness checks to main regression
		
				** No year fixed effects
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)

				** 3-year window
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_3year==1 & WarSmallSample==1, fe cluster(codeid)

				** 4-year window
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_4year==1 & WarSmallSample==1, fe cluster(codeid)
				
				** 6-year window
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_6year==1 & WarSmallSample==1, fe cluster(codeid)
				
				** Center around 1933
				xtreg growth_gdp_pc_real_Maddison_TED after1933 after_default33 _Iyear_* if DiD1933_5year==1 & WarSmallSample==1, fe cluster(codeid)
				
				** exclude treatment year
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & y1934_index!=0, fe cluster(codeid)

				** With inflation
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default inflation_RR _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)

				** With banking crises and currency crises
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default bankingcrises currencycrises _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)

				** With wars
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default Intrastateconflict InterstateConflict _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)

				** With politics
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default domestic4 domestic6 domestic7 _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)

				** Drop Eastern Europe 
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & EasternEurope!=1, fe cluster(codeid)
				
				** Europe Only
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="New Zealand" & country!="Australia", fe cluster(codeid)

				** Drop Germany
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="Germany", fe cluster(codeid)

				** Drop Australia and New Zealand
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="Australia" & country!="New Zealand", fe cluster(codeid)
		
				** Drop Countries with largest Debt Relief to GDP
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="France" & country!="Greece" & country!="Italy", fe cluster(codeid)
	
				** Drop Countries with smallest Debt Relief to GDP
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="Austria" & country!="Belgium" & country!="Australia", fe cluster(codeid)
	
					** GDP performance
					list country GDP1934_index if y1934_index==5 & WarDefaulters==1
	
				** Drop countries with BEST GDP perfomance in T+5 (Austria, Germany, New Zealand)
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="Germany" & country!="Austria" & country!="New Zealand", fe cluster(codeid)
		
				** Drop countries with WORST GDP perfomance in T+5 (Greece, Portugal, Belgium)
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1 & country!="Greece" & country!="Portugal" & country!="Belgium", fe cluster(codeid)

				**************************
				** Quartile regressions
				** Note: this requires downloading the Stata ado "DIFF". Type "ssc install diff" in Stata command line
					
				**Prepare for DIFF Stata module
				gen treat1934=WarDefaulters
				replace treat1934=0 if WarDefaulters==. & DiD1934_5year==1 &  WarAllSample==1
				gen interact_treat=treat1934*after1934
				tabulate country, generate(ctryd)
					
				** replicate XTREG results
				diff growth_gdp_pc_real_Maddison_TED if DiD1934_5year==1 & WarSmallSample==1, treated(treat1934) period(after1934) cluster(codeid) cov(_Iyear_* ctryd*) 
						
				* Median regressions
				diff growth_gdp_pc_real_Maddison_TED if DiD1934_5year==1 & WarSmallSample==1, treated(treat1934) period(after1934) qdid(0.50)  
				* With country fixed effects (IMPORTANT: standard errors likely to be biased)
				diff growth_gdp_pc_real_Maddison_TED if DiD1934_5year==1 & WarSmallSample==1, treated(treat1934) period(after1934) qdid(0.50) cov(ctryd*) 
					
					
			* Results with Large ("World") counterfactual (Table 4, Column 2)
			
			xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 &  WarAllSample==1, fe cluster(codeid)
			estimates store growth1934_FE_full
		
				*Results using other Counteractuals
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 &  WarLatAmSample==1, fe cluster(codeid)
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_default _Iyear_* if DiD1934_5year==1 &  WarNonLatAmSample==1, fe cluster(codeid)
				
				*Median regression with "World" counterfactual
				diff growth_gdp_pc_real_Maddison_TED if DiD1934_5year==1 & WarAllSample==1, treated(treat1934) period(after1934) qdid(0.50) 

						
			* Regressions using an alternative treatment variable: debt relief as % to GDP and as % of Debt Stocks
						
				** with Debt Relief/GDP
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_debtrelief if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)

				** with Debt Relief/Total Debt
				xtreg growth_gdp_pc_real_Maddison_TED after1934 after_stockrelief if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)

		*********************		
		*** Ratings 1934 ****	
		
			*** Ratings Main Regression (Table 4, Column 3)
			bysort codeid: gen interrating_growth=(d.moodys_interwar_num/moodys_interwar_num[_n-1])*100
		
			xtreg interrating_growth after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
			estimates store ratings1934_FE_nodef
				
				*No Year FE
				xtreg interrating_growth after1934 after_default if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
				estimates store ratings1934_nodef

				*Median regression small counterfactual
				diff interrating_growth after1934 if DiD1934_5year==1 & WarSmallSample==1, treated(treat1934) period(after1934) qdid(0.50) 
				*Median regression large counterfactual
				diff interrating_growth after1934 if DiD1934_5year==1 & WarAllSample==1, treated(treat1934) period(after1934) qdid(0.50) 

		*************************		
		*** Debt Service 1934 ***
						
			** Debt Service to Revenue -- Main Regression (Table 4, Column 4)
			xtreg debtservRevenue_interwar after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
			estimates store serviceRev1934_FE_nodef
				
				*No Year FE		
				xtreg debtservRevenue_interwar after1934 after_default if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
				estimates store serviceRev1934_nodef
				
			** Large Counterfactual - (Table 4, Column 5)	
			xtreg debtservRevenue_interwar after1934 after_default _Iyear_* if DiD1934_5year==1 & WarAllSample==1, fe cluster(codeid)
			estimates store serviceRev1934_FE_full
				
				*Median regression small counterfactual
				diff debtservRevenue_interwar if DiD1934_5year==1 & WarSmallSample==1, treated(treat1934) period(after1934) qdid(0.50) 

				*Median regression large counterfactual
				diff debtservRevenue_interwar if DiD1934_5year==1 & WarAllSample==1, treated(treat1934) period(after1934) qdid(0.50) 

				
			** Debt service to GDP 
			xtreg debtservGDP_interwar after1934 after_default if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
			estimates store serviceGDP1934_nodef

				*Year FE
				xtreg debtservGDP_interwar after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
				estimates store serviceGDP1934_FE_nodef
				
				*Full Counterfactual
				xtreg debtservGDP_interwar after1934 after_default _Iyear_* if DiD1934_5year==1 & WarAllSample==1, fe cluster(codeid)
				estimates store serviceGDP1934_FE_full
			
			
		*************************		
		*** Debt/GDP 1934 ***
	
		** Debt/GDP (Abbas et al. data) -- Main Regression (Table 4, Column 6)
		xtreg debt_gdpAbbas after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
		estimates store debtgdp1934_FE_nodef
			
			*No Year FE
			xtreg debt_gdpAbbas after1934 after_default if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
			estimates store debtgdp1934_nodef
				
		*Large counterfactual (Table 4, Column 7)
		xtreg debt_gdpAbbas after1934 after_default _Iyear_* if DiD1934_5year==1 & WarAllSample==1, fe cluster(codeid)
		estimates store debtgdp1934_FE_full
				
			*Median regression small counterfactual
			diff debt_gdpAbbas if DiD1934_5year==1 & WarSmallSample==1, treated(treat1934) period(after1934) qdid(0.50) 

			*Median regression large counterfactual
			diff debt_gdpAbbas if DiD1934_5year==1 & WarAllSample==1, treated(treat1934) period(after1934) qdid(0.50) 


		** External Debt/GDP (Reinhart/Rogoff data) (Table 4, Column 8) 
		xtreg ext_debt_gdp after1934 after_default _Iyear_* if DiD1934_5year==1 & WarSmallSample==1, fe cluster(codeid)
		estimates store extdebt1934_FE_nodef

			* --> No data for lare sample available 
				
						

	*********************************************************************
	******* 1931 Hoover DiD Analysis ************************************
		
		
		***********************************
		*** GDP growth (real p.c.) 1931 ***
			
		* Main Regression (Table 3, Column 1)
		xtreg growth_gdp_pc_real_Maddison_TED after1931 after_Hoover _Iyear_* if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
		estimates store growth1931_FE_nodef
			
			*no year fixed effects
			xtreg growth_gdp_pc_real_Maddison_TED after1931 after_Hoover if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
			estimates store growth1931_nodef
			
		*Large Counterfactual (Table 3, Column 2)
		xtreg growth_gdp_pc_real_Maddison_TED after1931 after_Hoover _Iyear_* if DiD1931_5year==1 &  WarAllSample==1, fe cluster(codeid)
		estimates store growth1931_FE_full
	
	
		*********************************
		*** Ratings 1931 ****************
		
		* Ratings 1931 (Table 3, Column 3)
		xtreg interrating_growth after1931 after_Hoover _Iyear_* if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
		estimates store ratings1931_FE_nodef
		
			*no year fixed effects
			xtreg interrating_growth after1931 after_Hoover if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
			estimates store ratings1931_nodef
			

		*********************************
		*** Debt Service 1931 ***********
				
		* Debt service to revenue (Table 3, Column 4)
		xtreg debtservRevenue_interwar after1931 after_Hoover _Iyear_* if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
		estimates store serviceRev1931_FE_nodef
				
				*No Year FE
				xtreg debtservRevenue_interwar after1931 after_Hoover if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
				estimates store serviceRev1931_nodef

		* Large counterfactual (Table 3, Column 5)		
		xtreg debtservRevenue_interwar after1931 after_Hoover _Iyear_* if DiD1931_5year==1 & WarAllSample==1, fe cluster(codeid)
		estimates store serviceRev1931_FE_full	
				
				** Debt service to GDP
				xtreg debtservGDP_interwar after1931 after_Hoover _Iyear_* if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
				estimates store serviceGDP1931_FE_nodef
		

		*********************************
		*** Debt/GDP 1931 ***************
		
		* Debt/GDP (Data from Abbas et al.) (Table 3, Column 6)
		xtreg debt_gdpAbbas after1931 after_Hoover _Iyear_* if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
		estimates store debtgdp1931_FE_nodef
		

		* Large Counterfactual (Table 3, Column 7)
		xtreg debt_gdpAbbas after1931 after_Hoover _Iyear_* if DiD1931_5year==1 & WarAllSample==1, fe cluster(codeid)
		estimates store debtgdp1931_FE_full

		
		** External Debt/GDP (Reinhart/Rogoff) (Table 3, Column 8) * --> No data for Large Counterfactual	
		xtreg ext_debt_gdp after1931 after_Hoover _Iyear_* if DiD1931_5year==1 & WarSmallSample==1, fe cluster(codeid)
		estimates store extdebt1931_FE_nodef
			
			
			
			
*********************************************************************************************************************************

		**** SAVE REGRESSION RESULTS
		** Note: xml_tab is a user written command. Install by typing "ssc install xml_tab" in Stata

		*** 1934 DiD Analysis
		xml_tab growth1934_FE_nodef growth1934_FE_full serviceRev1934_FE_nodef serviceRev1934_FE_full ratings1934_FE_nodef debtgdp1934_FE_nodef debtgdp1934_FE_full extdebt1934_FE_nodef, below stats(N, r2, r2_a) format(NTCR2) keep(after1934 after_default _cons)  save(DiD_1934_Results.xml) replace
		
		*** 1931 DiD Analysis
		xml_tab growth1931_FE_nodef  growth1931_FE_full  serviceRev1931_FE_nodef serviceRev1931_FE_full ratings1931_FE_nodef debtgdp1931_FE_nodef debtgdp1931_FE_full extdebt1931_FE_nodef , below stats(N, r2, r2_a) format(NTCR2) keep(after1931 after_Hoover _cons)  save(DiD_1931_Results.xml) replace

