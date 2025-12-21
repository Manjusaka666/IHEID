# International Trade II

## Problem Set

```
Gravity Equation: Empirics
```
# The effect of currency unions on trade

The objective of this problem set is to study the effects of currency unions on trade.
The data folder contains five files: DOTS19602005.dta, pwt.dta, RTA.dta, CU.dta, and
distcepii.dta. The first contains bilateral trade values by origin and destination coun-
tries, every 5 years over the period 1960-2005. The second contains country level data
such as population and GDP. The third and fourth files contain information on regional
trade agreements and currency unions, i.e. whether the two countries are engaged in a
trade agreement and in a currency union in yeart. The last file contains information
on time-invariant variables which might affect trade costs between countries. More in-
formation on data sources, as well as two papers related to the effect of currency unions
on trade and to gravity equations, can be found in the documentation folder.
Rose summarizes the findings of his 2000 paper (attached) as: “the surprising and
interesting finding was that currency union seemed to have a strong and robust effect on
trade. Even using the standard linear gravity model that accounts for most variation in
trade patterns, my point estimate was that the coefficient for a currency union dummy
variable (which is unity when a pair of countries share a common currency and zero
otherwise) has a point estimate of around 1.21. This implies that members of currency
unions traded over three times as much as otherwise similar pairs of countries ceteris
paribus, since exp(1.21)>3.” Rose (2004).

```
a. Comment on the above Rose’s (2004) quotation. (0.25 point)
b. What are the mechanisms through which a currency union may affect trade? What
are the reasons to expect a large / small effect? (0.5 point)
```

```
c. Using the data provided, construct the gravity dataset. It should include: the
exporter and importer countries identifiers, the year, the value of bilateral trade,
exporters’ and importers’ size, time-invariant trade costs proxies (such as distance,
common language, etc.), RTA and CU dummies. Summarize the data. Count the
number of countries and the number of years. (0.25 point)
```
d. How has the share of countries and trade belonging to RTAs and CUs evolved over
the period? (0.5 point)
e. Estimate the currency union effect: (in all estimations, include year dummies and
cluster the standard errors by country-pair) (0.5 points)
(a) Using a traditional gravity equation with only GDPs and distance. If the
gravity equation is derived from a Krugman (1980) model, what coefficient do we
expect on GDPs?
(b) Adding the CU and RTA variables.
(c) Adding the other proxies for trade costs
(e) Using importer and exporter fixed effects.
f. Comment the different results obtained in question 5 and and compare them with
the effect found by Rose. What is the “gold medal mistake”? (explain carefully)
Are country fixed effects a good remedy? What are the main advantages and
drawbacks of country fixed effects? (0.5 point)
g. Read Baldwin and Taglioni’s paper. Identify and explain the silver and bronze
medal mistakes of Rose’s estimation strategy. (0.5 point)

h. Run different regressions for each years of the sample using country fixed effects.
Is the use of country fixed effects more appropriate in this context? Compare your
results with the previous question and comment briefly. (0.5 point)
i. Baldwin (2006): “The size of this common-currency effect was just far too large
to be believed and the profession’s assault on this claim began even before he


```
presented it at the October 1999 Economic Policy Panel (...).” There were three
main themes in these critiques: (0.5 point)
```
- Reverse causality (countries naturally trading a lot with each other enter
currency unions)
- Omitted variables (omitting variables that are pro-trade and correlated with
the CU dummy biases the estimate upwards)
- Model misspecification.
(1) Which of these problems can be (at least partly) solved through the use of
country-pair fixed effects? Try with this database, and comment on the strengths
/ weaknesses of this strategy in this particular case.
(2) Which potential omitted variables can bias the results? Do you think that
endogenous sample selection can bias the coefficient on currency unions?
j. Use the commands reg2hdfe and reg3hdfe to run regressions controlling for (esti-
mations might take some time to run): (0.5 point)
(1) Importer×year and exporter×year fixed effects.
(2) Importer×year, exporter×year fixed effects and dyadic (country-pair)
fixed effects.
Don’t forget to include only the variables for which we can actually identify the
coefficients (the one which are not perfectly collinear with the fixed effects). Com-
ment on the rationale for using these specifications and on the results.

k. Do small countries’ trade benefit more or less from being part of a currency unions?
(0.25 points)
l. List and explain two problems associated with the use of a log-linearized gravity
equation. Use a Poisson estimator to estimate the gravity equation (focus on the
version with country-pair fixed effects and year dummies). (0.5 point)


m. Quantifying the effect of currency unions on trade was considered important in
late 90s / early 2000s because it was informative of the potential effects of the
Euro on trade. Investigate the effect of the Euro on trade using this dataset. Use
the econometric specification(s) that you find the most convincing. (0.75 point)