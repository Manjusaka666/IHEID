********************************************************************************
*** Rerun modules that previously failed because of missing Stata commands.
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
log using "E:\IHEID Economics\IHEID\Advanced International Economics\presentation\replication_audit\rerun_after_packages.log", text replace

foreach module in ///
    GGPT_JIE_trade_now.do ///
    GGPT_JIE_trade_coldwar.do ///
    GGPT_JIE_product_level.do {
    display as text "AUDIT_BEGIN `module'"
    capture noisily do "$dir\do files\\`module'"
    display as result "AUDIT_RC `module' " _rc
}

log close
