**********************************************************************
*** Do File 2 "EMEs" underlying the paper "Sovereign Debt Relief and its Aftermath" by Carmen M. Reinhart and Christoph Trebesch
*** This do file generates the descriptive figures and regressions results for the 1978-2010 sample and the Baker and Brady debt relief initiatives

	clear
	use EMEs_rep.dta
	
	**install ado files "diff" and "xml_tab"
	capture ssc install diff
	capture ssc install xml_tab

********************************
*** Define Sample of Defaulters and Restructuring Events (using Cruces/Trebesch 2013 data)
	
	gen EME_finalrestruct=.
	gen EME_default=.
	
	replace EME_finalrestruct=1 if country=="Algeria" & year==1996
	replace EME_default=1 if country=="Algeria" & year>1990 & year<1997
	
	replace EME_finalrestruct=1 if country=="Argentina" & year==1993
	replace EME_default=1 if country=="Argentina" & year>1982 & year<1994
	
	replace EME_finalrestruct=1 if country=="Argentina" & year==2005
	replace EME_default=1 if country=="Argentina" & year>2000 & year<2006
	
	replace EME_finalrestruct=1 if country=="Bosnia and Herzegovina" & year==1997
	replace EME_default=1 if country=="Bosnia and Herzegovina" & year>1991 & year<1998
	
	replace EME_finalrestruct=1 if country=="Brazil" & year==1994
	replace EME_default=1 if country=="Brazil" & year>1982 & year<1995
	
	replace EME_finalrestruct=1 if country=="Bulgaria" & year==1994
	replace EME_default=1 if country=="Bulgaria" & year>1989 & year<1995
	
	replace EME_finalrestruct=1 if country=="Chile" & year==1990
	replace EME_default=1 if country=="Chile" & year>1982 & year<1991
	
	replace EME_finalrestruct=1 if country=="Costa Rica" & year==1990
	replace EME_default=1 if country=="Costa Rica" & year>1982 & year<1991
	
	replace EME_finalrestruct=1 if country=="Croatia" & year==1996
	replace EME_default=1 if country=="Croatia" & year>1991 & year<1997
	
	replace EME_finalrestruct=1 if country=="Dominica" & year==2005
	replace EME_default=1 if country=="Dominica" & year>2002 & year<2006

	replace EME_finalrestruct=1 if country=="Dominican Republic" & year==1994
	replace EME_default=1 if country=="Dominican Republic" & year>1981 & year<1995
	
	replace EME_finalrestruct=1 if country=="Dominican Republic" & year==2005
	replace EME_default=1 if country=="Dominican Republic" & year>2004 & year<2006
	
	replace EME_finalrestruct=1 if country=="Ecuador" & year==1995
	replace EME_default=1 if country=="Ecuador" & year>1981 & year<1996
	
	replace EME_finalrestruct=1 if country=="Ecuador" & year==2000
	replace EME_default=1 if country=="Ecuador" & year>1998 & year<2001
	
	replace EME_finalrestruct=1 if country=="Ecuador" & year==2009
	replace EME_default=1 if country=="Ecuador" & year>2007 & year<2010
	
	replace EME_finalrestruct=1 if country=="Gabon" & year==1994
	replace EME_default=1 if country=="Gabon" & year>1985 & year<1995
	
	replace EME_finalrestruct=1 if country=="Grenada" & year==2005
	replace EME_default=1 if country=="Grenada" & year>2003 & year<2006
	
	replace EME_finalrestruct=1 if country=="Jamaica" & year==1993
	replace EME_default=1 if country=="Jamaica" & year>1977 & year<1994

	replace EME_finalrestruct=1 if country=="Jordan" & year==1993
	replace EME_default=1 if country=="Jordan" & year>1988 & year<1994
	
	replace EME_finalrestruct=1 if country=="Macedonia" & year==1997
	replace EME_default=1 if country=="Macedonia" & year>1991 & year<1998
	
	replace EME_finalrestruct=1 if country=="Mexico" & year==1990
	replace EME_default=1 if country=="Mexico" & year>1981 & year<1991
	
	replace EME_finalrestruct=1 if country=="Panama" & year==1996
	replace EME_default=1 if country=="Panama" & year>1982 & year<1997
	
	replace EME_finalrestruct=1 if country=="Peru" & year==1997
	replace EME_default=1 if country=="Peru" & year>1979 & year<1998

	replace EME_finalrestruct=1 if country=="Poland" & year==1994
	replace EME_default=1 if country=="Poland" & year>1980 & year<1995
	
	replace EME_finalrestruct=1 if country=="Romania" & year==1986
	replace EME_default=1 if country=="Romania" & year>1980 & year<1987
		
	replace EME_finalrestruct=1 if country=="Russia" & year==2000
	replace EME_default=1 if country=="Russia" & year>1990 & year<2001
	
	/*check*/
	replace EME_finalrestruct=1 if country=="Serbia and Montenegro" & year==2004
	replace EME_default=1 if country=="Serbia and Montenegro" & year>2002 & year<2005
	
	replace EME_finalrestruct=1 if country=="Seychelles" & year==2010
	replace EME_default=1 if country=="Seychelles" & year>2007 & year<2011
	
	replace EME_finalrestruct=1 if country=="Slovenia" & year==1996
	replace EME_default=1 if country=="Slovenia" & year>1991 & year<1997
		
	replace EME_finalrestruct=1 if country=="South Africa" & year==1993
	replace EME_default=1 if country=="South Africa" & year>1984 & year<1994
	
	replace EME_finalrestruct=1 if country=="Trinidad and Tobago" & year==1989
	replace EME_default=1 if country=="Trinidad and Tobago" & year>1987 & year<1990
	
	replace EME_finalrestruct=1 if country=="Turkey" & year==1982
	replace EME_default=1 if country=="Turkey" & year>1977 & year<1983

	replace EME_finalrestruct=1 if country=="Uruguay" & year==1991
	replace EME_default=1 if country=="Uruguay" & year>1982 & year<1992

	replace EME_finalrestruct=1 if country=="Uruguay" & year==2003
	replace EME_default=1 if country=="Uruguay" & year>2002 & year<2004
	
	replace EME_finalrestruct=1 if country=="Venezuela" & year==1990
	replace EME_default=1 if country=="Venezuela" & year>1982 & year<1991

	
	*** Gen Brady Deal Dummy (13 out of 18 in total)
	*** NOTE: Bolivia, Côte d’Ivoire, Nigeria, Philippines and Vietnam also had a Brady deal but are not included (no middle-high income countries)

	*Year of Brady deal (actual implementation)
	gen Brady_deal=.
	replace Brady_deal=1 if country=="Argentina" & year==1993
	replace Brady_deal=1 if country=="Brazil" & year==1994
	replace Brady_deal=1 if country=="Bulgaria" & year==1994
	replace Brady_deal=1 if country=="Costa Rica" & year==1990
	replace Brady_deal=1 if country=="Dominican Republic" & year==1994
	replace Brady_deal=1 if country=="Ecuador" & year==1995
	replace Brady_deal=1 if country=="Jordan"  & year==1993
	replace Brady_deal=1 if country=="Mexico" & year==1990
	replace Brady_deal=1 if country=="Panama" & year==1996
	replace Brady_deal=1 if country=="Peru" & year==1997
	replace Brady_deal=1 if country=="Poland" & year==1994
	replace Brady_deal=1 if country=="Uruguay" & year==1991
	replace Brady_deal=1 if country=="Venezuela" & year==1990
	
	*Year of Baker deal (actual implementation)
	gen Baker_deal=.
	replace Baker_deal=1 if country=="Argentina" & year==1987
	replace Baker_deal=1 if country=="Brazil" & year==1988
	replace Baker_deal=1 if country=="Chile" & year==1987
	replace Baker_deal=1 if country=="Costa Rica" & year==1985
	replace Baker_deal=1 if country=="Dominican Republic" & year==1986
	replace Baker_deal=1 if country=="Ecuador" & year==1985
	replace Baker_deal=1 if country=="Mexico" & year==1987
	replace Baker_deal=1 if country=="Panama" & year==1985
	replace Baker_deal=1 if country=="Poland" & year==1988
	replace Baker_deal=1 if country=="Uruguay" & year==1988
	replace Baker_deal=1 if country=="Venezuela" & year==1986
	
	*Debt relief to GDP (in %)
	gen Brady_relief=.
	replace Brady_relief=24.0 if country=="Argentina" & year==1993
	replace Brady_relief=14.3 if country=="Brazil" & year==1994
	replace Brady_relief=55.6 if country=="Bulgaria" & year==1994
	replace Brady_relief=43.4 if country=="Costa Rica" & year==1990
	replace Brady_relief=13.3 if country=="Dominican Republic" & year==1994
	replace Brady_relief=31.2 if country=="Ecuador" & year==1995
	replace Brady_relief=5.3 if country=="Jordan"  & year==1993
	replace Brady_relief=36.2 if country=="Mexico" & year==1990
	replace Brady_relief=22.9 if country=="Panama" & year==1996
	replace Brady_relief=13.8 if country=="Peru" & year==1997
	replace Brady_relief=15.1 if country=="Poland" & year==1994
	replace Brady_relief=34.3 if country=="Uruguay" & year==1991
	replace Brady_relief=41.6 if country=="Venezuela" & year==1990
	
	*Debt relief to External Public Debt (in %)
	gen Brady_stockrelief=.
	replace Brady_stockrelief=80.1 if country=="Argentina" & year==1993
	replace Brady_stockrelief=59.9 if country=="Brazil" & year==1994
	replace Brady_stockrelief=45.9 if country=="Bulgaria" & year==1994
	replace Brady_stockrelief=59.9 if country=="Costa Rica" & year==1990
	replace Brady_stockrelief=42.2 if country=="Dominican Republic" & year==1994
	replace Brady_stockrelief=83.1 if country=="Ecuador" & year==1995
	replace Brady_stockrelief=4.1 if country=="Jordan"  & year==1993
	replace Brady_stockrelief=105.1 if country=="Mexico" & year==1990
	replace Brady_stockrelief=52.3 if country=="Panama" & year==1996
	replace Brady_stockrelief=40.4 if country=="Peru" & year==1997
	replace Brady_stockrelief=. if country=="Poland" & year==1994
	replace Brady_stockrelief=. if country=="Uruguay" & year==1991
	replace Brady_stockrelief=105.9 if country=="Venezuela" & year==1990
	

	**********************************
	*** Generate Variables / Indices around main events
	
	**** Restructuring index EMEs (around actual debt exchanges)
	sort codeid year
	gen Deal_index=.
		bysort codeid: replace Deal_index=-5 if EME_finalrestruct[_n+5]==1
		bysort codeid: replace Deal_index=-4 if EME_finalrestruct[_n+4]==1
		bysort codeid: replace Deal_index=-3 if EME_finalrestruct[_n+3]==1
		bysort codeid: replace Deal_index=-2 if EME_finalrestruct[_n+2]==1
		bysort codeid: replace Deal_index=-1 if EME_finalrestruct[_n+1]==1
		bysort codeid: replace Deal_index=0 if EME_finalrestruct==1
		bysort codeid: replace Deal_index=1 if EME_finalrestruct[_n-1]==1
		bysort codeid: replace Deal_index=2 if EME_finalrestruct[_n-2]==1
		bysort codeid: replace Deal_index=3 if EME_finalrestruct[_n-3]==1
		bysort codeid: replace Deal_index=4 if EME_finalrestruct[_n-4]==1
		bysort codeid: replace Deal_index=5 if EME_finalrestruct[_n-5]==1
	
	**** EME Index around 1986 (Baker start)
	sort codeid year
	gen y1986_index=.
		bysort codeid: replace y1986_index=-5 if year[_n+5]==1986
		bysort codeid: replace y1986_index=-4 if year[_n+4]==1986
		bysort codeid: replace y1986_index=-3 if year[_n+3]==1986
		bysort codeid: replace y1986_index=-2 if year[_n+2]==1986
		bysort codeid: replace y1986_index=-1 if year[_n+1]==1986
		bysort codeid: replace y1986_index=0 if year==1986
		bysort codeid: replace y1986_index=1 if year[_n-1]==1986
		bysort codeid: replace y1986_index=2 if year[_n-2]==1986
		bysort codeid: replace y1986_index=3 if year[_n-3]==1986
		bysort codeid: replace y1986_index=4 if year[_n-4]==1986
		bysort codeid: replace y1986_index=5 if year[_n-5]==1986
		
	**** EME Index around 1990 (Brady start)
	sort codeid year
	gen y1990_index=.
		bysort codeid: replace y1990_index=-5 if year[_n+5]==1990
		bysort codeid: replace y1990_index=-4 if year[_n+4]==1990
		bysort codeid: replace y1990_index=-3 if year[_n+3]==1990
		bysort codeid: replace y1990_index=-2 if year[_n+2]==1990
		bysort codeid: replace y1990_index=-1 if year[_n+1]==1990
		bysort codeid: replace y1990_index=0 if year==1990
		bysort codeid: replace y1990_index=1 if year[_n-1]==1990
		bysort codeid: replace y1990_index=2 if year[_n-2]==1990
		bysort codeid: replace y1990_index=3 if year[_n-3]==1990
		bysort codeid: replace y1990_index=4 if year[_n-4]==1990
		bysort codeid: replace y1990_index=5 if year[_n-5]==1990

		
	*** GDP indexed to 1 in year of EME restructurings
	sort codeid year
	gen EMEGDP_index=.
		bysort codeid: replace EMEGDP_index=EME_real_pc/EME_real_pc[_n+5] if Deal_index==-5
		bysort codeid: replace EMEGDP_index=EME_real_pc/EME_real_pc[_n+4] if Deal_index==-4
		bysort codeid: replace EMEGDP_index=EME_real_pc/EME_real_pc[_n+3] if Deal_index==-3
		bysort codeid: replace EMEGDP_index=EME_real_pc/EME_real_pc[_n+2] if Deal_index==-2
		bysort codeid: replace EMEGDP_index=EME_real_pc/EME_real_pc[_n+1] if Deal_index==-1
		bysort codeid: replace EMEGDP_index=EME_real_pc/EME_real_pc if Deal_index==0
		bysort codeid: replace EMEGDP_index=EME_real_pc/EME_real_pc[_n-1] if Deal_index==1
		bysort codeid: replace EMEGDP_index=EME_real_pc/EME_real_pc[_n-2] if Deal_index==2
		bysort codeid: replace EMEGDP_index=EME_real_pc/EME_real_pc[_n-3] if Deal_index==3
		bysort codeid: replace EMEGDP_index=EME_real_pc/EME_real_pc[_n-4] if Deal_index==4
		bysort codeid: replace EMEGDP_index=EME_real_pc/EME_real_pc[_n-5] if Deal_index==5
		
	**** GDP indexed to 1 around 1986
	sort codeid year
	gen EMEGDP_1986index=.
		bysort codeid: replace EMEGDP_1986index=EME_real_pc/EME_real_pc[_n+5] if y1986_index==-5
		bysort codeid: replace EMEGDP_1986index=EME_real_pc/EME_real_pc[_n+4] if y1986_index==-4
		bysort codeid: replace EMEGDP_1986index=EME_real_pc/EME_real_pc[_n+3] if y1986_index==-3
		bysort codeid: replace EMEGDP_1986index=EME_real_pc/EME_real_pc[_n+2] if y1986_index==-2
		bysort codeid: replace EMEGDP_1986index=EME_real_pc/EME_real_pc[_n+1] if y1986_index==-1
		bysort codeid: replace EMEGDP_1986index=EME_real_pc/EME_real_pc if y1986_index==0
		bysort codeid: replace EMEGDP_1986index=EME_real_pc/EME_real_pc[_n-1] if y1986_index==1
		bysort codeid: replace EMEGDP_1986index=EME_real_pc/EME_real_pc[_n-2] if y1986_index==2
		bysort codeid: replace EMEGDP_1986index=EME_real_pc/EME_real_pc[_n-3] if y1986_index==3
		bysort codeid: replace EMEGDP_1986index=EME_real_pc/EME_real_pc[_n-4] if y1986_index==4
		bysort codeid: replace EMEGDP_1986index=EME_real_pc/EME_real_pc[_n-5] if y1986_index==5
	
	**** GDP indexed to 1 around 1990
	sort codeid year
	gen EMEGDP_1990index=.
		bysort codeid: replace EMEGDP_1990index=EME_real_pc/EME_real_pc[_n+5] if y1990_index==-5
		bysort codeid: replace EMEGDP_1990index=EME_real_pc/EME_real_pc[_n+4] if y1990_index==-4
		bysort codeid: replace EMEGDP_1990index=EME_real_pc/EME_real_pc[_n+3] if y1990_index==-3
		bysort codeid: replace EMEGDP_1990index=EME_real_pc/EME_real_pc[_n+2] if y1990_index==-2
		bysort codeid: replace EMEGDP_1990index=EME_real_pc/EME_real_pc[_n+1] if y1990_index==-1
		bysort codeid: replace EMEGDP_1990index=EME_real_pc/EME_real_pc if y1990_index==0
		bysort codeid: replace EMEGDP_1990index=EME_real_pc/EME_real_pc[_n-1] if y1990_index==1
		bysort codeid: replace EMEGDP_1990index=EME_real_pc/EME_real_pc[_n-2] if y1990_index==2
		bysort codeid: replace EMEGDP_1990index=EME_real_pc/EME_real_pc[_n-3] if y1990_index==3
		bysort codeid: replace EMEGDP_1990index=EME_real_pc/EME_real_pc[_n-4] if y1990_index==4
		bysort codeid: replace EMEGDP_1990index=EME_real_pc/EME_real_pc[_n-5] if y1990_index==5
		
	*** Rating indexed to 1 in year of EME restructurings
	sort codeid year
	gen EMErating_index=.
		bysort codeid: replace EMErating_index=iir_yearly/iir_yearly[_n+5] if Deal_index==-5
		bysort codeid: replace EMErating_index=iir_yearly/iir_yearly[_n+4] if Deal_index==-4
		bysort codeid: replace EMErating_index=iir_yearly/iir_yearly[_n+3] if Deal_index==-3
		bysort codeid: replace EMErating_index=iir_yearly/iir_yearly[_n+2] if Deal_index==-2
		bysort codeid: replace EMErating_index=iir_yearly/iir_yearly[_n+1] if Deal_index==-1
		bysort codeid: replace EMErating_index=iir_yearly/iir_yearly if Deal_index==0
		bysort codeid: replace EMErating_index=iir_yearly/iir_yearly[_n-1] if Deal_index==1
		bysort codeid: replace EMErating_index=iir_yearly/iir_yearly[_n-2] if Deal_index==2
		bysort codeid: replace EMErating_index=iir_yearly/iir_yearly[_n-3] if Deal_index==3
		bysort codeid: replace EMErating_index=iir_yearly/iir_yearly[_n-4] if Deal_index==4
		bysort codeid: replace EMErating_index=iir_yearly/iir_yearly[_n-5] if Deal_index==5
	
	**** Rating indexed to 1 around 1986 (start of Baker initiative)
		sort codeid year
		gen EMErating_1986index=.
		bysort codeid: replace EMErating_1986index=iir_yearly/iir_yearly[_n+5] if y1986_index==-5
		bysort codeid: replace EMErating_1986index=iir_yearly/iir_yearly[_n+4] if y1986_index==-4
		bysort codeid: replace EMErating_1986index=iir_yearly/iir_yearly[_n+3] if y1986_index==-3
		bysort codeid: replace EMErating_1986index=iir_yearly/iir_yearly[_n+2] if y1986_index==-2
		bysort codeid: replace EMErating_1986index=iir_yearly/iir_yearly[_n+1] if y1986_index==-1
		bysort codeid: replace EMErating_1986index=iir_yearly/iir_yearly if y1986_index==0
		bysort codeid: replace EMErating_1986index=iir_yearly/iir_yearly[_n-1] if y1986_index==1
		bysort codeid: replace EMErating_1986index=iir_yearly/iir_yearly[_n-2] if y1986_index==2
		bysort codeid: replace EMErating_1986index=iir_yearly/iir_yearly[_n-3] if y1986_index==3
		bysort codeid: replace EMErating_1986index=iir_yearly/iir_yearly[_n-4] if y1986_index==4
		bysort codeid: replace EMErating_1986index=iir_yearly/iir_yearly[_n-5] if y1986_index==5
		
	**** Rating indexed to 1 around 1990 (start of Brady initiative)
	sort codeid year
	gen EMErating_1990index=.
		bysort codeid: replace EMErating_1990index=iir_yearly/iir_yearly[_n+5] if y1990_index==-5
		bysort codeid: replace EMErating_1990index=iir_yearly/iir_yearly[_n+4] if y1990_index==-4
		bysort codeid: replace EMErating_1990index=iir_yearly/iir_yearly[_n+3] if y1990_index==-3
		bysort codeid: replace EMErating_1990index=iir_yearly/iir_yearly[_n+2] if y1990_index==-2
		bysort codeid: replace EMErating_1990index=iir_yearly/iir_yearly[_n+1] if y1990_index==-1
		bysort codeid: replace EMErating_1990index=iir_yearly/iir_yearly if y1990_index==0
		bysort codeid: replace EMErating_1990index=iir_yearly/iir_yearly[_n-1] if y1990_index==1
		bysort codeid: replace EMErating_1990index=iir_yearly/iir_yearly[_n-2] if y1990_index==2
		bysort codeid: replace EMErating_1990index=iir_yearly/iir_yearly[_n-3] if y1990_index==3
		bysort codeid: replace EMErating_1990index=iir_yearly/iir_yearly[_n-4] if y1990_index==4
		bysort codeid: replace EMErating_1990index=iir_yearly/iir_yearly[_n-5] if y1990_index==5

	save EMEs_rep.dta, replace	
	*************************************
	**** GENERATE TREATMENT AND CONTROL GROUPS
	
	use EMEs_rep.dta, clear
	* TREATMENT GROUP
	
	bysort codeid: egen Brady_group=max(Brady_deal)
	
	gen Baker_group=Brady_group
	replace Baker_group=1 if country=="Chile" /*Chile was targeted by Baker but not by Brady initiative*/

	* COUNTERFACTUAL
	
	* Baker: all middle-income EMEs without Baker deal who were NOT in default during the 1990s
	gen Baker_counterfactual=0 if Baker_group==1
	replace Baker_counterfactual=1 if country=="Thailand" | country=="Malaysia" | country=="South Korea" | country=="Israel" | country=="India" | country=="Mauritius" | country=="Colombia" | country=="Singapore" | country=="Egypt" | country=="Czech Republic" | country=="Hungary" | country=="Turkey" | country=="China" | country=="Taiwan"

	* Brady: all middle-income EMEs without Brady deal who were NOT in default during the 1990s
	gen Brady_counterfactual=0 if Brady_group==1
	replace Brady_counterfactual=1 if country=="Thailand" | country=="Malaysia" | country=="South Korea" | country=="Israel" | country=="India" | country=="Mauritius" | country=="Colombia" | country=="Singapore" | country=="Egypt" | country=="Czech Republic" | country=="Hungary" | country=="Turkey" | country=="China" | country=="Taiwan"

		* Robustness Check: Counterfactual in Henry/Arslanalp Paper (including Chile)
		gen Henry_counterfactual=0 if Brady_group==1
		replace Henry_counterfactual=1 if country=="Chile" | country=="China" | country=="Colombia" | country=="Czech Republic" | country=="Greece" | country=="Hungary" | country=="India" | country=="Indonesia" | country=="South Korea" | country=="Malaysia" | country=="Pakistan" | country=="South Africa" | country=="Sri Lanka" | country=="Thailand" | country=="Turkey" | country=="Zimbabwe"
	
	* FINAL TREATMENT DUMMIES
	
		gen Baker_treat=0 if Baker_counterfactual==1
		replace Baker_treat=1 if Baker_counterfactual==0

		gen Brady_treat=0 if Brady_counterfactual==1
		replace Brady_treat=1 if Brady_counterfactual==0
		
		gen Henry_treat=0 if Henry_counterfactual==1
		replace Henry_treat=1 if Henry_counterfactual==0
		
	
	* Regional Dummies (for Robustness Checks)
	
		** Latin Dummy
		gen LatAm=.
		replace LatAm=1 if country=="Guatemala" |country=="Belize" | country=="Haiti" | country=="Honduras" | country=="El Salvador" | country=="Argentina" | country=="Brazil" & year==1992 | country=="Costa Rica" & year==1989 | country=="Dominican Republic" | country=="Ecuador" | country=="Peru" | country=="Mexico" | country=="Panama" | country=="Uruguay" | country=="Venezuela" | country=="Colombia" | country=="Chile" | country=="Bolivia" | country=="Paraguay"
		
		gen LatAm_treat=1 if Brady_group==1 | country=="Bolivia" //had a Brady deal too (previously excluded since no middle-income country)
		replace LatAm_treat=0 if LatAm_treat!=1 & LatAm==1

		** Eastern Europe Dummy
		gen EastEurope_EME=.
		replace EastEurope_EME=1 if country=="Bulgaria" | country=="Poland" | country=="Hungary" | country=="Czech Republic" 
		
		** East Asia Dummy
		gen EastAsia_EME=.
		replace EastAsia_EME=1 if country=="Thailand" | country=="Malaysia" | country=="South Korea" | country=="China" | country=="Taiwan" | country=="Singapore" 
				
	***** DEFINE SAMPLES
	
	*** EME_period
	gen EME_period=0
	replace EME_period=1 if year>1979 & year<2013
		
	*** Gen Defaulter Group and Non-Defaulters
	gen EME_alldefaulter=.
	bysort codeid: egen EME_defaulter=max(EME_default)
	replace EME_alldefaulter=1 if EME_defaulter==1
	drop EME_defaulter	
	
	*** Counterfactual (non-defaulters)
	gen EME_counterfactual=Baker_counterfactual	
	
		*** 28 countries as defaulters
		tab country if EME_alldefaulter==1
		*** 12 Countries as counterfactual
		tab country if EME_counterfactual==1
		
	**exclude Ex-Yugoslavia 
	gen ExYugo=0
	replace ExYugo=1 if country=="Bosnia and Herzegovina" | country=="Slovenia" | country=="Croatia" | country=="Macedonia"  | country=="Serbia and Montenegro"
	
	*** Final Sample
	gen EME_sample=.
	replace EME_sample=1 if EME_alldefaulter==1
	replace EME_sample=1 if EME_counterfactual==1
	replace EME_sample=. if year<1979 | year>2013
	replace EME_sample=. if ExYugo==1
	
	
	***********************
	** Prepare Graphs
	** REGRESS Growth residuals
	
			xtset codeid year
			xi i.code
			
			xtreg  EME_real_pc_growth  _Icode_* if EME_alldefaulter==1 & EME_period==1, robust
			predict residgrowth_EMEdef, ue
			label var residgrowth_EMEdef residgrowth_EMEdef
						
			xtreg  EME_real_pc_growth  _Icode_* if Brady_treat==1 & EME_period==1, robust
			predict residgrowth_brady, ue
			label var residgrowth_brady residgrowth_brady
			
			xtreg  EME_real_pc_growth  _Icode_* if Baker_treat==1 & EME_period==1, robust
			predict residgrowth_baker, ue
			label var residgrowth_baker residgrowth_baker
			
			xtreg  EME_real_pc_growth  _Icode_* if EME_counterfactual==1 & EME_period==1, cluster(codeid)
			predict residgrowth_countEME, ue
			label var residgrowth_countEME residgrowth_countEME
	
	
	*******************************
	******* REPLICATE GRAPHS
	
		*****************************************
		** INDICATORS AROUND FINAL RESTRUCTURINGS
		
		*** Replicate Figures 3, 4, 5 and 6 (Stylized Facts in Section 3), and the 25%, 50% and 75% percentiles, respectively (Figure C.1 in the Appendix)
	
		*GDP (real, p.c., indexed at 1) around final restructuring  (Figure 3)
  		tabstat EMEGDP_index if ExYugo==0, by(Deal_index) stat(mean sd count median p75 p25) 
		
			*Real p.c. growth around final restructuring 
			tabstat EME_real_pc_growth if ExYugo==0, by(Deal_index) stat(mean sd count) 
			*Residual growth around restructuring years 
			tabstat residgrowth_EMEdef if ExYugo==0, by(Deal_index) stat(mean sd count) 

		*Rating indexed at 1 around final restructuring (Figure 4)
		tabstat EMErating_index if ExYugo==0, by(Deal_index) stat(mean sd count median p75 p25)  
		
		*Debt Service around final restructuring (Figure 5)
		tabstat DebtServTotal_GDP if ExYugo==0, by(Deal_index) stat(mean sd count median p75 p25)  

		*Debt/GDP around final restructuring (Figure 6)
		tabstat debt_gdpAbbas if ExYugo==0, by(Deal_index) stat(mean sd count median p75 p25)  
			
	
		**************
		*** Dispersion Stats (Table C.2 in the Appendix)
	
			*** GDP
			tabstat EMEGDP_index if ExYugo==0, by(Deal_index) stat(mean max min p25 median p75 sd)

			*** Ratings
			tabstat EMErating_index if ExYugo==0, by(Deal_index) stat(mean max min p25 median p75 sd)

			
	*******************************
	*** BRADY INITIATIVE - Treatment vs Control Group
	*** Replicate Figure 9 and Figure C.8 in the Appendix
	
		*GDP (normalized to 1 in 1990) --- Right Panel of Figure 9
			*Treatment Group (Brady countries):
			tabstat EMEGDP_1990index if Brady_treat==1, by(y1990_index) stat(mean sd count median) 
			*Control Group (non-defaulter EMEs)
			tabstat EMEGDP_1990index if EME_counterfactual==1, by(y1990_index) stat(mean sd count median) 
		
		*Residual Growth
			*Treatment Group (Brady countries):
			tabstat residgrowth_brady if Brady_treat==1, by(y1990_index) stat(mean sd count) 
			*Control Group (non-defaulter EMEs)
			tabstat residgrowth_countEME if EME_counterfactual==1, by(y1990_index) stat(mean sd count) 

		*Ratings, IIR (normalized to 1 in 1990) 
			*Treatment Group (Brady countries):
			tabstat EMErating_1990index if Brady_treat==1, by(y1990_index) stat(mean sd count) 
			*Control Group (non-defaulter EMEs)
			tabstat EMErating_1990index if EME_counterfactual==1, by(y1990_index) stat(mean sd count) 
		
		*Debt Service to Exports (World Bank data)
			*Treatment Group (Brady countries):
			tabstat DebtService_Exports if Brady_treat==1, by(y1990_index) stat(mean sd count) 
			*Control Group (non-defaulter EMEs)
			tabstat DebtService_Exports if EME_counterfactual==1, by(y1990_index) stat(mean sd count) 
	
		*Debt/GDP
			*Treatment Group (Brady countries):
			tabstat debt_gdpAbbas if Brady_treat==1, by(y1990_index) stat(mean sd count) 
			*Control Group (non-defaulter EMEs)
			tabstat debt_gdpAbbas if EME_counterfactual==1, by(y1990_index) stat(mean sd count) 


	*******************************
	*** BAKER INITIATIVE - Treatment vs Control Group
	*** Replicate Figure 9 and Figure C.7 in the Appendix
	
		*GDP (normalized to 1 in 1986) --- Left Panel of Figure 9
			*Treatment Group (Baker countries):
			tabstat EMEGDP_1986index if Baker_treat==1, by(y1986_index) stat(mean sd count) 
			*Control Group (non-defaulter EMEs)
			tabstat EMEGDP_1986index if EME_counterfactual==1, by(y1986_index) stat(mean sd count) 
	
		*Residual Growth
			*Treatment Group (Baker countries):
			tabstat residgrowth_baker if Baker_treat==1, by(y1986_index) stat(mean sd count) 
			*Control Group (non-defaulter EMEs)
			tabstat residgrowth_countEME if EME_counterfactual==1, by(y1986_index) stat(mean sd count) 
		
		*Ratings, IIR (normalized to 1 in 1986) 
			*Treatment Group (Baker countries):
			tabstat EMErating_1986index if Baker_treat==1, by(y1986_index) stat(mean sd count) 
			*Control Group (non-defaulter EMEs)
			tabstat EMErating_1986index if EME_counterfactual==1, by(y1986_index) stat(mean sd count) 

		*Debt Service to Exports (World Bank data)
			*Treatment Group (Baker countries):
			tabstat DebtService_Exports if Baker_treat==1, by(y1986_index) stat(mean sd count) 
			*Control Group (non-defaulter EMEs)
			tabstat DebtService_Exports if EME_counterfactual==1, by(y1986_index) stat(mean sd count) 
								
		**Debt/GDP, data from Abbas et al. 2011 (Figure C.6)		
			*Treatment Group (Baker countries):
			tabstat debt_gdpAbbas if Baker_treat==1, by(y1986_index) stat(mean sd count) 
			*Control Group (non-defaulter EMEs)
			tabstat debt_gdpAbbas if EME_counterfactual==1, by(y1986_index) stat(mean sd count) 

			
			
*****************************************
******** Prepare Regressions
	

	**** 5-year window around restructuring events and Baker and Brady initiatives
	
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
	
	xtset codeid year
	xi i.year
		
************************************************************************************************************
************************************************************************************************************
	************ BRADY *****************************************************
************************************************************************************************************	
************************************************************************************************************

		******************************************
		*** GDP growth (real p.c.) around 1990 ***
			
		* Main Regression (Table 6, Column 1)
			
		xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1, fe cluster(codeid)
		estimates store growthBradyFE
		
				* Robsutness checks to main regression
				
				*no time fixed effects
				xtreg EME_real_pc_growth after1990 post_Brady if DiD1990_5year==1, fe cluster(codeid)
				
				*drop intervention year
				xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1 & year!=1990, fe cluster(codeid)
				
				*shorter window: 3 year
				xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* if DiD1990_3year==1 , fe cluster(codeid)
								
				*shorter window: 4 year
				xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* if DiD1990_4year==1 , fe cluster(codeid)
								
				*longer window: 6 year
				xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* if DiD1990_6year==1 , fe cluster(codeid)

				*Placebo: center around 1988 (no effects)
				xtreg EME_real_pc_growth after1988 post_1988 _Iyear_* if DiD1988_5year==1 , fe cluster(codeid)

				*without Mexico and Uruguay, Venezuela and Costa Rica (first Brady countries)
				xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1  & country!="Uruguay" & country!="Costa Rica" & country!="Venezuela" & country!="Mexico", fe cluster(codeid)
				
				*without Eastern Europe
				xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1  & EastEurope_EME!=1, fe cluster(codeid)
				
				*without East Asia
				xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1  & EastAsia_EME!=1, fe cluster(codeid)

				*only Latin America
				xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1  & LatAm==1, fe cluster(codeid)
				
				*full sample Latin America
				xtreg EME_real_pc_growth after1990 post_BradLatAm _Iyear_* if DiD1990_5year==1  & LatAm==1, fe cluster(codeid)
				
				*Drop countries with highest debt relief
				xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1  & country!="Bulgaria" & country!="Venezuela" & country!="Costa Rica", fe cluster(codeid)

				*Drop countries with lowest debt relief
				xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1  & country!="Brazil" & country!="Jordan" & country!="Peru", fe cluster(codeid)
				
					list country EMEGDP_1990index if y1990_index==5 & Brady_group==1
				
				*Drop countries with BEST growth performance
				xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1  & country!="Peru" & country!="Argentina" & country!="Panama", fe cluster(codeid)

				*Drop countries with WORST growth performance
				xtreg EME_real_pc_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1  & country!="Bulgaria" & country!="Mexico" & country!="Brazil", fe cluster(codeid)
				
				*with banking and currency crises
				xtreg EME_real_pc_growth after1990 post_Brady bankingcrises currencycrises _Iyear_* if DiD1990_5year==1 , fe cluster(codeid)
	
				*with inflation
				xtreg EME_real_pc_growth after1990 post_Brady inflation_RR _Iyear_* if DiD1990_5year==1 , fe cluster(codeid)

				*with wars
				xtreg EME_real_pc_growth after1990 post_Brady Intrastateconflict InterstateConflict _Iyear_* if DiD1990_5year==1 , fe cluster(codeid)
				
				*with political events
				xtreg EME_real_pc_growth after1990 post_Brady domestic4 domestic6 domestic7 _Iyear_* if DiD1990_5year==1 , fe cluster(codeid)

				**************************
				** Quartile regressions
				** Note: this requires downloading the Stata ado "DIFF". Type "ssc install diff" in Stata command line
					
					*prepare
					tabulate country, generate(ctryd)

				** replicate XTREG results
				diff EME_real_pc_growth if DiD1990_5year==1 , treated(Brady_treat) period(after1990) cluster(codeid) cov(_Iyear_* ctryd*) 
					*same but no fixed effects
					diff EME_real_pc_growth if DiD1990_5year==1 , treated(Brady_treat) period(after1990) cluster(codeid) 

				** Median regressions
				diff EME_real_pc_growth if DiD1990_5year==1, treated(Brady_treat) period(after1990) qdid(0.5) 
				
				
		****************************	
		*** Ratings around 1990 ****	
		
		*generate dependent variable (rating changes)
		bysort codeid: gen ratings_growth=(d.iir_yearly/iir_yearly[_n-1])*100
		
					
		* Main Regression (Table 6, Column 2)
		xtreg ratings_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1 , fe cluster(codeid)
		estimates store ratingsBradyFE
		
				* Robsutness checks to main regression
				
				*no time fixed effects
				xtreg ratings_growth after1990 post_Brady if DiD1990_5year==1 , fe cluster(codeid)
				
				*drop intervention year
				xtreg ratings_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1  & year!=1990, fe cluster(codeid)
				
				*shorter window: 3 year
				xtreg ratings_growth after1990 post_Brady _Iyear_* if DiD1990_3year==1 , fe cluster(codeid)
								
				*shorter window: 4 year
				xtreg ratings_growth after1990 post_Brady _Iyear_* if DiD1990_4year==1 , fe cluster(codeid)
								
				*longer window: 6 year
				xtreg ratings_growth after1990 post_Brady _Iyear_* if DiD1990_6year==1 , fe cluster(codeid)

				*Placebo: center around 1988 (no effects)
				xtreg ratings_growth after1988 post_1988 _Iyear_* if DiD1988_5year==1 , fe cluster(codeid)

				*without Mexico and Uruguay, Venezuela and Costa Rica (first Brady countries)
				xtreg ratings_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1  & country!="Uruguay" & country!="Costa Rica" & country!="Venezuela" & country!="Mexico", fe cluster(codeid)
				
				*full sample Latin America
				xtreg ratings_growth after1990 post_BradLatAm _Iyear_* if DiD1990_5year==1  & LatAm==1, fe cluster(codeid)
				
				*without Eastern Europe
				xtreg ratings_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1  & EastEurope_EME!=1, fe cluster(codeid)
				
				*without East Asia
				xtreg ratings_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1  & EastAsia_EME!=1, fe cluster(codeid)

				*Drop countries with highest debt relief
				xtreg ratings_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1  & country!="Bulgaria" & country!="Venezuela" & country!="Costa Rica", fe cluster(codeid)

				*Drop countries with lowest debt relief
				xtreg ratings_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1  & country!="Brazil" & country!="Jordan" & country!="Peru", fe cluster(codeid)
				
					list country EMErating_1990index if y1990_index==5 & Brady_group==1
				
				*Drop countries with BEST rating performance
				xtreg ratings_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1  & country!="Peru" & country!="Argentina" & country!="Poland", fe cluster(codeid)

				*Drop countries with WORST rating performance
				xtreg ratings_growth after1990 post_Brady _Iyear_* if DiD1990_5year==1  & country!="Bulgaria" & country!="Jordan" & country!="Venezuela", fe cluster(codeid)
				
				*with banking and currency crises
				xtreg ratings_growth after1990 post_Brady bankingcrises currencycrises _Iyear_* if DiD1990_5year==1 , fe cluster(codeid)
	
				*with inflation
				xtreg ratings_growth after1990 post_Brady inflation_RR _Iyear_* if DiD1990_5year==1 , fe cluster(codeid)

				*with wars
				xtreg ratings_growth after1990 post_Brady Intrastateconflict InterstateConflict  _Iyear_* if DiD1990_5year==1 , fe cluster(codeid)
				
				*with political events
				xtreg ratings_growth after1990 post_Brady domestic4 domestic6 domestic7 _Iyear_* if DiD1990_5year==1 , fe cluster(codeid)
	
				*median regression
				diff ratings_growth if DiD1990_5year==1 , treated(Brady_treat) period(after1990) qdid(0.5)  

		*********************************	
		*** Debt Service around 1990 ****	
		
		*** Debt Service to Exports (World Bank data) - (Table 6, Column 3)
		xtreg DebtService_Exports after1990 post_Brady _Iyear_* if DiD1990_5year==1 , fe cluster(codeid)
		estimates store debtservBradyFE
			
			*Median regression
			diff DebtService_Exports if DiD1990_5year==1 , treated(Brady_treat) period(after1990) qdid(0.5)  

		
		*********************************	
		*** Debt/GDP around 1990 ****	
		
		*** Debt/GDP, data from Abbas et al. 2011 - (Table 6, Column 4)
		xtreg debt_gdpAbbas after1990 post_Brady _Iyear_* if DiD1990_5year==1 , fe cluster(codeid)
		estimates store debtBradyFE
		
			*Median regression
			diff debt_gdpAbbas if DiD1990_5year==1 , treated(Brady_treat) period(after1990) qdid(0.5)  

		*** External Debt/GNI, data from World Bank - (Table 6, Column 5)
		xtreg DebtExt_GNI after1990 post_Brady _Iyear_* if DiD1990_5year==1 , fe cluster(codeid)
		estimates store extdebtBradyFE
		
			*Median regression
			diff DebtExt_GNI if DiD1990_5year==1 , treated(Brady_treat) period(after1990) qdid(0.5)  

		
		*************************************
		*** Regression using continuous treatment variables:
			
			*Treatment: Debt relief/GDP
			xtreg EME_real_pc_growth after1990 after_Bradyrelief _Iyear_* if DiD1990_5year==1 , fe cluster(codeid)
			xtreg ratings_growth after1990 after_Bradyrelief _Iyear_* if DiD1990_5year==1 , fe cluster(codeid)
		
			*Treatment: Debt relief/debt stock
			xtreg EME_real_pc_growth after1990 after_Bradystockrelief _Iyear_* if DiD1990_5year==1 , fe cluster(codeid)
			xtreg ratings_growth after1990 after_Bradystockrelief _Iyear_* if DiD1990_5year==1 , fe cluster(codeid)
		

************************************************************************************************************
************************************************************************************************************
	************ BAKER *****************************************************
************************************************************************************************************	
************************************************************************************************************

		******************************************
		*** GDP growth (real p.c.) around 1986 ***
		
		*** Main Regression (Table 5, Column 1)
			
		xtreg EME_real_pc_growth after1986 post_Baker _Iyear_* if DiD1986_5year==1 , fe cluster(codeid)
		estimates store growthBakerFE
	
		****************************	
		*** Ratings around 1986 ****	
	
		*** Main Regression (Table 5, Column 2)
		
		xtreg ratings_growth after1986 post_Baker _Iyear_* if DiD1986_5year==1 , fe cluster(codeid)
		estimates store ratingsBakerFE
		

		*********************************	
		*** Debt Service around 1986 ****	
		
		*** Debt Service to Exports (Table 5, Column 3)
		
		xtreg DebtService_Exports after1986 post_Baker _Iyear_* if DiD1986_5year==1 , fe cluster(codeid)
		estimates store debtservBakerFE
		

		*****************************	
		*** Debt/GDP around 1986 ****	
		
		*** Debt/GDP, data from Abbas et al. 2011 - (Table 5, Column 4)
		
		xtreg debt_gdpAbbas after1986 post_Baker _Iyear_* if DiD1986_5year==1 , fe cluster(codeid)
		estimates store debtBakerFE
		
		*** External Debt/GNI, data from World Bank - (Table 5, Column 5)

		xtreg DebtExt_GNI after1986 post_Baker _Iyear_* if DiD1986_5year==1 , fe cluster(codeid)
		estimates store extdebtBakerFE
		
					
			
*********************************************************************************************************************************

		**** SAVE REGRESSION RESULTS
		** Note: xml_tab is a user written command. Install by typing "ssc install xml_tab" in Stata
		
		** Brady & Baker DiD analysis
		xml_tab growthBradyFE ratingsBradyFE debtservBradyFE debtBradyFE extdebtBradyFE growthBakerFE ratingsBakerFE debtservBakerFE debtBakerFE extdebtBakerFE, below stats(N, r2, r2_a) format(NTCR2) keep(after1990 post_Brady after1986 post_Baker _cons)  save(DiD_Baker_Brady_Results.xml) replace
			
		