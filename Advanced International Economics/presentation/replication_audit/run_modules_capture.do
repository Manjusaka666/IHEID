********************************************************************************
*** Module-by-module audit runner. Continues after failures and prints return codes.
********************************************************************************

clear all
set more off, perm

global dir "E:\IHEID Economics\IHEID\Advanced International Economics\presentation\Data for Changing Global Linkages A New Cold War\PPGT_JIE_replication"
global working "$dir\working"
global input "$dir\data"
global charts "$dir\charts"
global tables "$dir\tables"

cd "$working"

capture log close _all
log using "E:\IHEID Economics\IHEID\Advanced International Economics\presentation\replication_audit\run_modules_capture.log", text replace

capture noisily do "$dir\do files\GGPT_JIE_packages.do"
display as result "AUDIT_RC packages " _rc

foreach module in ///
    GGPT_JIE_F1 ///
    GGPT_JIE_import_lilien.do ///
    GGPT_JIE_FDI_lilien.do ///
    GGPT_JIE_F3.do ///
    GGPT_JIE_F4.do ///
    GGPT_JIE_trade_now.do ///
    GGPT_JIE_fdi_now.do ///
    GGPT_JIE_portfolio_now.do ///
    GGPT_JIE_trade_coldwar.do ///
    GGPT_JIE_FS1.1.do ///
    GGPT_JIE_FS1.2.do ///
    GGPT_JIE_FS1.3.do ///
    GGPT_JIE_product_level.do ///
    GGPT_JIE_data_check.do {
    display as text "AUDIT_BEGIN `module'"
    capture noisily do "$dir\do files\\`module'"
    display as result "AUDIT_RC `module' " _rc
}

log close
