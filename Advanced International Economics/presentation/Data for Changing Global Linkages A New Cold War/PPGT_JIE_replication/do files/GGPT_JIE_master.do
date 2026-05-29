********************************************************************************
***      Authors: Gita Gopinath, Pierre-Olivier Gourinchas,                  ***
***               Andrea Presbitero, and Petia Topalova (IMF)                ***
********************************************************************************

********************************************************************************
****    This version:  Dec 10, 2024   ****
********************************************************************************

clear all 
set more off, perm 

*Authors' working directories
global dir "Z:\wp_trade_fdi\PPGT_JIE_replication"  

** SELECT WORKING DIRECTORIES **
*global dir  "" // enter your working directory here

do "$dir\do files\GGPT_JIE_packages.do"

global working "$dir\working"
global input "$dir\data"
global charts "$dir\charts"
global tables "$dir\tables"

cd "$working"


** Figure 1 **
do "$dir\do files\GGPT_JIE_F1"

** Figure 2 (panel A) and Table S2.1 (panel A) **
do "$dir\do files\GGPT_JIE_import_lilien.do"

** Figure 2 (panel B) and Table S2.1 (panel B) **
do "$dir\do files\GGPT_JIE_FDI_lilien.do"

** Figure 3 **
do "$dir\do files\GGPT_JIE_F3.do"

** Figure 4, Figure S1.4, Figure S1.5 **
do "$dir\do files\GGPT_JIE_F4.do"

** Table 1, Table S2.2 and Table S2.3 **
	** Columns 1-2 **
	do "$dir\do files\GGPT_JIE_trade_now.do"
	** Columns 3-4 and Table S2.3 **
	do "$dir\do files\GGPT_JIE_fdi_now.do"
	** Columns 5-6 **
	do "$dir\do files\GGPT_JIE_portfolio_now.do"
	** Columns 7-8 **
	do "$dir\do files\GGPT_JIE_trade_coldwar.do"

** Figure S1.1 **
do "$dir\do files\GGPT_JIE_FS1.1.do"

** Figure S1.2 **
do "$dir\do files\GGPT_JIE_FS1.2.do"

** Figure S1.3 **
do "$dir\do files\GGPT_JIE_FS1.3.do"

** Figure S1.6, Figure S1.7, Table S2.4 **
do "$dir\do files\GGPT_JIE_product_level.do"

** Annex S3 **
do "$dir\do files\GGPT_JIE_data_check.do"








