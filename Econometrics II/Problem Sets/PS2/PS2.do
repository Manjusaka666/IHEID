clear
cd "E:\\IHEID国际经济学硕士\\IHEID\\Econometrics II\\Problem Sets\\PS2"

use GMdata.dta, clear

// Compute summary statistics by year for ldsal, lemp, and ldnpt
tabstat ldsal lemp ldnpt, statistics(mean median sd min max p5 p95) by(yr)

// Box plot for ldsal (log of deflated sales)
graph box ldsal, over(yr) title("Boxplot of ldsal by Year")
graph export "boxplot_ldsal.png", replace

// Box plot for lemp (log of employment)
graph box lemp, over(yr) title("Boxplot of lemp by Year")
graph export "boxplot_lemp.png", replace

// Box plot for ldnpt (log of deflated capital)
graph box ldnpt, over(yr) title("Boxplot of ldnpt by Year")
graph export "boxplot_ldnpt.png", replace



//(b)
// Step 1: Count the total number of unique firms in the unbalanced panel.
egen tag = tag(index)
count if tag == 1
local total_firms = r(N)
display "Total number of firms in the unbalanced panel: " `total_firms'

// Step 2: For each firm, count the number of observations (years) available.
bysort index: egen n_obs = count(yr)

// Optional: List firms with fewer than 4 observations
list index n_obs if n_obs < 4, sepby(index)

// Step 3: Create a balanced panel by keeping only firms with observations in all four years.
keep if n_obs == 4

// Step 4: Count the number of unique firms in the balanced panel.
egen tag_bal = tag(index)
count if tag_bal == 1
local balanced_firms = r(N)
display "Number of firms in the balanced panel: " `balanced_firms'

// Step 5: Calculate and display the number of firms dropped.
local lost_firms = `total_firms' - `balanced_firms'
display "Number of firms dropped when creating a balanced panel: " `lost_firms'

save "GMdata_balanced.dta", replace



* (c) 随机效应 (RE) 估计器（平衡面板 GMdata_balanced.dta）
***************************************
use "GMdata_balanced.dta", clear
xtset index yr

* 随机效应估计（基本与 robust 两种）
xtreg ldsal lemp ldnpt, re
eststo re_est
xtreg ldsal lemp ldnpt, re vce(robust)
eststo re_robust

* 输出三线表到 question_c.tex
esttab re_est re_robust using question_c.tex, replace label booktabs title("Question (c): Random Effects Estimator") ///
    cells("b(fmt(3)) se(fmt(3))") mtitles("RE" "RE Robust") keep(lemp ldnpt)
	
	

***************************************
* (d) 固定效应 (FE) 内生估计器（平衡面板 GMdata_balanced.dta）
***************************************
use "GMdata_balanced.dta", clear
xtset index yr

* 固定效应估计（基本与 robust 两种）
xtreg ldsal lemp ldnpt, fe
eststo fe_est
xtreg ldsal lemp ldnpt, fe vce(robust)
eststo fe_robust

* 输出三线表到 question_d.tex
esttab fe_est fe_robust using question_d.tex, replace label booktabs title("Question (d): Fixed Effects (Within) Estimator") ///
    cells("b(fmt(3)) se(fmt(3))") mtitles("FE" "FE Robust") keep(lemp ldnpt)

	
	
***************************************
* (e) 固定效应 (FE) 内生估计器（平衡面板 GMdata_balanced.dta）
***************************************
* 同(d)

use "GMdata_balanced.dta", clear
sort index yr

by index: gen D_ldsal = ldsal - ldsal[_n-1]
by index: gen D_lemp = lemp - lemp[_n-1]
by index: gen D_ldnpt = ldnpt - ldnpt[_n-1]

by index: drop if _n==1

* 4. 用回归分析差分后的数据，计算 FE-FD 估计
reg D_ldsal D_lemp D_ldnpt, robust
eststo fd_robust

* 如果需要考虑企业内相关性，使用聚类稳健标准误：
reg D_ldsal D_lemp D_ldnpt, vce(cluster index)
eststo fd_robust_cluster

esttab fd_robust fd_robust_cluster using question_e.tex, replace label booktabs title("Question (e): Fixed Effects (FD) Estimator") ///
    cells("b(fmt(3)) se(fmt(3))") keep(D_lemp D_ldnpt)


	
***************************************
* (g) FE 回归（robust 标准误，平衡面板）
***************************************
use "GMdata_balanced.dta", clear
xtset index yr
xtreg ldsal lemp ldnpt, fe robust
eststo fe_robust_only

* 输出到 question_g.tex
esttab fe_robust_only using question_g.tex, replace label booktabs title("Question (g): FE Regression with Robust SE") ///
    cells("b(fmt(3)) se(fmt(3))") keep(lemp ldnpt)

	
	
***************************************
* (h) 手工 FE 估计 + 聚类 Bootstrap 标准误（平衡面板，不用 xtreg）
***************************************
use "GMdata_balanced.dta", clear
* 注意：此处不调用 xtset，防止 Bootstrap 重抽样时重复时间值错误

program define fe_est, rclass
    preserve
    bysort index: egen ymean = mean(ldsal)
    bysort index: egen x1mean = mean(lemp)
    bysort index: egen x2mean = mean(ldnpt)
    gen yd = ldsal - ymean
    gen x1d = lemp - x1mean
    gen x2d = ldnpt - x2mean
    quietly regress yd x1d x2d, noconstant
    return scalar b1 = _b[x1d]
    return scalar b2 = _b[x2d]
    restore
end

* 聚类 bootstrap（以 firm 为单位）重复 1000 次
bootstrap r(b1) r(b2), reps(1000) cluster(index) seed(2025) nodots: fe_est
eststo fe_bootstrap

* 输出结果到 question_h.tex，显示 lemp 和 ldnpt 的系数及 bootstrap 标准误
esttab fe_bootstrap using question_h.tex, replace label booktabs title("Question (h): FE Bootstrap Estimates (Manual)") ///
    cells("b(fmt(3)) se(fmt(3))") mtitles("" "") ///
    varlabels(r(b1) "lemp" r(b2) "ldnpt")

	
	
***************************************
* (i) 固定效应估计器（全样本，不平衡面板 GMdata.dta）
***************************************
use "GMdata.dta", clear
xtset index yr
xtreg ldsal lemp ldnpt, fe
eststo fe_unbalanced
xtreg ldsal lemp ldnpt, fe vce(robust)
eststo fe_unbalanced_robust

* 输出到 question_i.tex
esttab fe_unbalanced fe_unbalanced_robust using question_i.tex, replace label booktabs title("Question (i): FE Estimator on Unbalanced Panel") ///
    cells("b(fmt(3)) se(fmt(3))") mtitles("FE" "FE Robust") keep(lemp ldnpt)

	
	
***************************************
* (j) 手工 FE 估计 + 聚类 Bootstrap（全样本，不平衡面板，不用 xtreg）
***************************************
use "GMdata.dta", clear
program define fe_est2, rclass
    preserve
    bysort index: egen ymean2 = mean(ldsal)
    bysort index: egen x1mean2 = mean(lemp)
    bysort index: egen x2mean2 = mean(ldnpt)
    gen yd2 = ldsal - ymean2
    gen x1d2 = lemp - x1mean2
    gen x2d2 = ldnpt - x2mean2
    quietly regress yd2 x1d2 x2d2, noconstant
    return scalar b1 = _b[x1d2]
    return scalar b2 = _b[x2d2]
    restore
end

bootstrap r(b1) r(b2), reps(1000) cluster(index) seed(2025) nodots: fe_est2
eststo fe_bootstrap_unbalanced

* 输出结果到 question_j.tex
esttab fe_bootstrap_unbalanced using question_j.tex, replace label booktabs title("Question (j): FE Bootstrap on Unbalanced Panel (Manual)") ///
    cells("b(fmt(3)) se(fmt(3))") mtitles("" "") ///
    varlabels(r(b1) "lemp" r(b2) "ldnpt")