capture log close _all
log using "E:\IHEID Economics\IHEID\Advanced International Economics\presentation\replication_audit\install_missing_packages.log", text replace

foreach pkg in unique ppmlhdfe {
    capture which `pkg'
    if _rc {
        display as text "Installing `pkg'"
        ssc install `pkg', replace
    }
}

log close
