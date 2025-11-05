

% File that replicates the log-linearised model in Justiniano and Preston,
% "Monetary Policy and Uncertainty in an Empirical Small Open-Economy 
% Model", JAE 2010.
% The calibration follows the posteriors for Canada from the paper.

close all;

//----------------------------------------
//		Variables, Parameters & Shocks
//----------------------------------------
    
// Endogenous variables
var c y r q s pie pih pif lop a ys pis rs er; % er
% r = i
% lop = psif
% ys, pis, rs = ystar, pistar, istar; 

// Exogenous variables
varexo 
epsa % Tech shock
epsm % MP shock
epsg % Pref shock
epsp % Risk-premium / UIP shock
epsc % Cost-push shock
epys % Foreign output
epps % Foreign inflation 
eprs % Foreign interest rate
;

// Parameters
parameters alf bet delh delf teth tetf eta psi sig h chi
psir psip psiy psid psie
rhoa rhog rhop rhoc roys rops rors
sgps sgys sgrs siga sigr sigg sigp sigc
;

// Calibrations
alf  = 0.28; % calibrated, see Table I, JP10
bet  = 0.99; % calibrated, see Table I, JP10
chi  = 0.01; % calibrated, see Table I, JP10
sig  = 0.88;
psi  = 1.26; % Inverse Frisch elasticity
teth = 0.68;
tetf = 0.41;
eta  = 0.80;
h    = 0.30;
delh = 0.06;
delf = 0.10;
psir = 0.74;
psip = 2.01;
psiy = 0.08;
psid = 0.67;
//psiy = 0;
//psid = 0;

psie = 0.29;
rhoa = 0.90;
rhog = 0.95;
rhop = 0.95;
rhoc = 0.97;
sgps = 0.36;
sgys = 0.52;
sgrs = 0.15;
siga = 0.42;
sigr = 0.29;
sigg = 0.17;
sigp = 0.20;
sigc = 2.01;

roys = 0.8;
rops = 0.5;
rors = 0.8;

//----------------------------------------
//		Model
//----------------------------------------

model(linear);
    
   
// 14 Euler equation 
c - h*c(-1) = (c(+1)-h*c) - (1-h)/sig*(r - pie(+1) - epsg + epsg(+1));

// 15 Goods market clearing
(1-alf)*c = y - alf*eta*(2-alf)*s - alf*eta*lop - alf*ys;

// 16 Terms of trade
s - s(-1) = pif - pih;

// 17 Real exchange rate
q = lop + (1-alf)*s;

// 18 Firms' optimal prices
pih - delh*pih(-1) = (1-teth)/teth*(1-bet*teth)*( psi*y - (1+psi)*epsa + alf*s + (1-h)/sig*(c-h*c(-1)) ) + bet*(pih(+1)-delh*pih);

// 19 Retailers' optimal prices
pif - delf*pif(-1) = (1-tetf)/tetf*(1-bet*tetf)*lop + bet*(pif(+1)-delf*pif) + epsc;

// 20 CPI identity
pie = pih + alf*(s-s(-1));

// 21 Uncovered interest rate parity
(r - pie(+1)) - (rs - pis(+1)) = (q(+1)-q) - chi*a - epsp;

// 22 Flow budget constraint
c + a = a(-1)/bet - alf*(s+lop) + y;

// 23 Taylor rule
r = psir*r(-1) + psip*pie + psiy*y + psid*(y-y(-1)) + epsm;

// 24 AR(1) for ys
ys = roys*ys(-1) + sgys*epys;

// 25 AR(1) for pis
pis = rops*pis(-1) + sgps*epps;

// 26 AR(1) for rs
rs = rors*rs(-1) + sgrs*eprs;

// 27 Nominal exchange rate (identity!)
er = er(-1) - (q-q(-1)) + pis - pie;
end;

steady;
check;

//----------------------------------------
//		Shocks
//----------------------------------------

shocks;

var epsa = 1;
var epsm = 1;
var epsg = 1;
var epsp = 1;
var epsc = 1;
var epys = 1;
var epps = 1;
var eprs = 1;

end;


//----------------------------------------
//		Computation
//----------------------------------------

stoch_simul(irf=25) c y r s pie lop a pif er;



