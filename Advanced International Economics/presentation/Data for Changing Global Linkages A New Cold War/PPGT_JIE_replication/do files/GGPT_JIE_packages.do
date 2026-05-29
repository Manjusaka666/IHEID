    * *** Add required packages from SSC to this list ***
    local ssc_packages unique estout reghdfe ftools binscatter outreg winsor2
    * *** Add required packages from SSC to this list ***

    if !missing("`ssc_packages'") {
        foreach pkg in "`ssc_packages'" {
        * install using ssc, but avoid re-installing if already present
            capture which `pkg'
            if _rc == 111 {                 
               dis "Installing `pkg'"
               quietly ssc install `pkg', replace
               }
        }
    }
