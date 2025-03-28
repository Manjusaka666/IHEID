clear
cd "E:\\IHEID国际经济学硕士\\IHEID\\Econometrics II\\Problem Sets\\PS3"

use GMdata.dta, clear

* Declare the panel structure: firm identifier is index and time variable is yr
xtset index yr

* Estimate the model with firm (unit) fixed effects and time dummies
xtreg ldsal lemp ldnpt ldrnd i.yr, fe robust
eststo fe_model

esttab fe_model using a.tex, replace label booktabs title(" Fixed Eﬀects Model") ///
    cells(b(star fmt(3)) se(fmt(3) par)) star(* 0.10 ** 0.05 *** 0.01) mtitles("FE") keep(lemp ldnpt ldrnd)
***(b)
egen tag = tag(index)
count if tag == 1
// local total_firms = r(N)
// display "Total number of firms in the unbalanced panel: " `total_firms'

bysort index: egen n_obs = count(yr)

// list index n_obs if n_obs < 4, sepby(index)

keep if n_obs == 4

// egen tag_bal = tag(index)
// count if tag_bal == 1
// // local balanced_firms = r(N)
// // display "Number of firms in the balanced panel: " `balanced_firms'
//
// local lost_firms = `total_firms' - `balanced_firms'
// display "Number of firms dropped when creating a balanced panel: " `lost_firms'

save "GMdata_balanced.dta", replace

use "GMdata_balanced.dta", clear
sort index yr

by index: gen D_ldsal = ldsal - ldsal[_n-1]
by index: gen D_lemp = lemp - lemp[_n-1]
by index: gen D_ldnpt = ldnpt - ldnpt[_n-1]
by index: gen D_ldrnd = ldrnd - ldrnd[_n-1]

by index: drop if _n==1

* Optionally, if you want to see the transformation, list some observations
list D_ldsal D_lemp D_ldnpt D_ldrnd in 1/10


***(c)
use "GMdata_balanced.dta", clear
* Create the industry dummy (assuming 'sic3' contains the 3-digit SIC code)
gen d357 = (sic3 == 357)

* Estimate the FE model including the dummy
xtreg ldsal lemp ldnpt ldrnd d357 i.yr, fe robust


* Include interaction terms to allow for time-varying effects
xtreg ldsal lemp ldnpt ldrnd i.yr##i.d357, fe robust



***(d)
* Declare the panel structure (if not already declared)
use "GMdata_balanced.dta", clear
xtset index yr
gen d357 = (sic3 == 357)

* FE (Within) Estimator with robust standard errors:
xtreg ldsal lemp ldnpt ldrnd i.yr##i.d357, fe
eststo fe_w
esttab fe_w using d1.tex, ///
	replace booktabs label ///
    title("Fixed Effects Model") ///
    cells(b(star fmt(3)) se(fmt(3) par)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
	keep(lemp ldnpt ldrnd)
	
* RE Estimator with robust standard errors:
xtreg ldsal lemp ldnpt ldrnd i.yr##i.d357, re
eststo RE
esttab RE using d2.tex, ///
	replace booktabs label ///
    title("Random Effects Model") ///
    cells(b(star fmt(3)) se(fmt(3) par)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
	keep(lemp ldnpt ldrnd)

***(e)
* After storing the FE and RE estimates as above:
hausman fe_w RE, sigmamore


***(f)
* Estimate the FE model (if not already done)
xtreg ldsal lemp ldnpt ldrnd, fe robust

* Test the null hypothesis that the sum of coefficients on lemp and ldnpt equals 1
test lemp + ldnpt = 1
