close all;

var 
cons // consumption
idom // domestic interest rate
ydom // domestic output
ystar // foreign output
exch  // nominal exchange rate
stot // terms of trade
qror // real exchange rate
pih // domestic producer inflation
pif // retailer inflation
mcdom // domestic marginal cost
istar // foreign interest rate
pistar // foreign inflation
pidom  // domestic inflation
adom // real net foreign asset position as a fraction of steady-state output
phirp // risk preimum - ar(1)
atech // technology - ar(1)
cpush // cost push - ar(1)
;
 
varexo epsa epscp epsphi epsmon epsystar epspistar epsistar;

parameters hab sig etah alp delh delf bet phi chi rhoi phipi thetah thetaf phiy phidely phiex rhoa rhocp rhophi rhoyp rhoyi rhoyy rhopy rhopp rhopi rhoiy rhoip rhoii;

hab = 0.3;
sig = 0.88;
etah = 0.8;
alp = 0.28;
delh = 0.06;
delf = 0.1;
bet = 0.99;
phi = 1.26;
chi = 0.01;
rhoi = 0.74;
phipi = 2.01;
thetah = 0.68;
thetaf = 0.41;
phiy = 0.08;
phidely = 0.67;
phiex = 0.29;
rhoa = 0.9;
rhocp = 0.97;
rhophi = 0.95;
rhoyp = -0.001;
rhoyi = -0.005;
rhoyy = 0.778;
rhopy = 0.362;
rhopp = 0.308;
rhopi = -0.056;
rhoiy = -0.062;
rhoip = 0.055;
rhoii = 0.978;

shocks;
var epsa; stderr 0.42;
var epscp; stderr 2.01;
var epsphi; stderr 0.2;
var epsmon; stderr 0.29;
var epsystar; stderr 0.52;
var epspistar; stderr 0.36;
var epsistar; stderr 0.15;
end;

model(linear);
// Euler Equation
cons - hab*cons(-1) = cons(+1) - hab*cons - (1-hab)/sig*(idom - pidom(+1));

// Market Clearing
ydom = (1-alp)*cons + alp*ystar + alp*etah*(stot + qror);

// Domestic Producer Inflation
mcdom = phi*ydom - (1+phi)*atech + sig/(1-hab)*(cons - hab*cons(-1)) + alp*stot;
pih - delh*pih(-1) = (1-thetah)*(1-thetah*bet)/thetah * mcdom + bet*(pih(+1) - delh*pih);

// Retailer Inflation
pif - delf*pif(-1) = (1-thetaf)*(1-thetaf*bet)/thetaf * (qror - (1-alp)*stot) + bet*(pif(+1) - delf*pif) + cpush;

// Uncovered Interest Rate Parity
idom - istar = exch(+1) - exch - chi*adom - phirp;

// Flow Budget Constraint
cons + adom = adom(-1)/bet - alp*(alp*stot + qror) + ydom;

// Terms of Trade
stot - stot(-1) = pif - pih; 

// Nominal Exchange Rate and Real Exchange Rate
exch - exch(-1) = qror - qror(-1) - pistar + pidom;

// CPI Inflation
pidom = (1-alp)*pih + alp*pif;

// Monetary Policy
idom = rhoi*idom(-1) + (1-rhoi)*(phipi * pidom + phiy * ydom + phidely * (ydom - ydom(-1)) + phiex * (exch - exch(-1))) + epsmon;


// Exogenous processes for technology, cost push (import price), and risk premium
atech = rhoa*atech(-1) + epsa;
cpush = rhocp*cpush(-1) + epscp;
phirp = rhophi*phirp(-1)+ epsphi;


// Foreign block VAR (1)
ystar = rhoyy*ystar(-1) + rhopy*pistar(-1) + rhoiy*istar(-1)+ epsystar;
pistar = rhoyp*ystar(-1) + rhopp*pistar(-1) + rhoip*istar(-1) + epspistar;
istar = rhoyi*ystar(-1) + rhopi*pistar(-1) + rhoii*istar(-1) + epsistar;
end;

steady;
resid;
check;

varobs idom pidom ydom ystar istar pistar phirp;

estimated_params;
hab, beta_pdf, 0.5, 0.25; 
sig, gamma_pdf, 1.2, 0.4; 
etah, gamma_pdf, 1.5, 0.75; 
delh, beta_pdf, 0.5, 0.25; 
delf, beta_pdf, 0.5, 0.25;
phi, gamma_pdf, 1.5, 0.75; 
chi, beta_pdf, 0.01, 0.005; 
rhoi, beta_pdf, 0.5, 0.25;
phipi, gamma_pdf, 1.5, 0.3; 
thetah, beta_pdf, 0.5, 0.1;
thetaf, beta_pdf, 0.5, 0.1; 
phiy, beta_pdf, 0.25, 0.13; 
phidely, beta_pdf, 0.25, 0.13; 
phiex, beta_pdf, 0.25, 0.13; 
rhoa, beta_pdf, 0.8, 0.1; 
rhocp, beta_pdf, 0.5, 0.25; 
rhophi, beta_pdf, 0.8, 0.1; 
stderr epsa, inv_gamma_pdf, 0.05, inf;
stderr epscp, inv_gamma_pdf, 0.05, inf;
stderr epsphi, inv_gamma_pdf, 0.05, inf;
stderr epsmon, inv_gamma_pdf, 0.05, inf;
stderr epsystar, inv_gamma_pdf, 0.005, inf;
stderr epspistar, inv_gamma_pdf, 0.005, inf;
stderr epsistar, inv_gamma_pdf, 0.005, inf;
end;

estimated_params_init;
hab, 0.33;
sig, 1.31;
etah, 0.58;
delh, 0.05;
delf, 0.07;
phi, 1.12;
chi, 0.01;
rhoi, 0.84;
phipi, 1.95;
thetah, 0.7;
thetaf, 0.55;
phiy, 0.08;
phidely, 0.67;
phiex, 0.14;
rhoa, 0.69;
rhocp, 0.94;
rhophi, 0.94;
end;

estimation(order=1, plot_priors = 0, mode_compute = 3, datafile=kordat, nobs=76);

