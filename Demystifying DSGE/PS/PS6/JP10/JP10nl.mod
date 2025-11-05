

% File that replicates the log-linearised model in Justiniano and Preston,
% "Monetary Policy and Uncertainty in an Empirical Small Open-Economy 
% Model", JAE 2010.
% The calibration follows the posteriors for Australia from the paper.

close all;

//----------------------------------------
//		Variables, Parameters & Shocks
//----------------------------------------
    
// Endogenous variables
var 
C Y R Q S 
Psi Pie Ph Pf Ys 
Pis Rs A ACh DACh 
ACf DACf muh lam
dER
;

% Y = Y_h in the paper
% lop = psif
% ys, pis, rs = ystar, pistar, istar; 

// Exogenous variables
varexo 
epsa % Tech shock
epsr % MP shock
epsg % Pref shock
epsp % Risk-premium / UIP shock
% epsc % Cost-push shock
epys % Foreign output
epps % Foreign inflation 
eprs % Foreign interest rate
;

// Parameters
parameters 
alf bet delh delf teth tetf eta psi sig h chi
chih chif epsh epsf
psir psip psiy psid psie
rhoa rhog rhop rhoc roys rops rors
sgps sgys sgrs siga sigr sigg sigp sigc
YSS RSS YsSS RsSS PisSS
muf  % markup importer
;

// Calibrations (follows estimation results for Australia, Tab. I, p105)
alf  = 0.185; % calibrated, see footnote Table I
bet  = 0.99;  % calibrated, see footnote Table I
chi  = 0.01;  % calibrated, see footnote Table I
sig  = 1.31;
psi  = 1.12; % Inverse Frisch elasticity
teth = 0.79;
tetf = 0.55;
eta  = 0.58;
h    = 0.33;
delh = 0.05;
delf = 0.07;
psir = 0.84;
psip = 1.83;
psiy = 0.09;
psie = 0.01;
psid = 0.74;

rhoa = 0.69;
rhog = 0.93;
rhop = 0.94;
rhoc = 0.94;
sgps = 0.35;
sgys = 0.48;
sgrs = 0.12;
siga = 0.37;
sigr = 0.26;
sigg = 0.16;
sigp = 0.35;
sigc = 1.58;

roys = 0.8; % guessed (?)
rops = 0.5; % guessed (?)
rors = 0.8; % guessed (?)

% Parameters for the Rotemberg AC
epsh  = 11;
epsf  = 11;
chih  = teth*(epsh-1)/((1-teth)*(1-teth*bet));
chif  = tetf*(epsf-1)/((1-tetf)*(1-tetf*bet));
% chih = 2;
% chif = 2;

% Steady states
YSS   = (epsh/(epsh-1)*(1-h)^sig)^(-1/(sig+psi));
RSS   = 1/bet;
YsSS  = alf*YSS;      % only imports of foreign countries (H exports) here!
RsSS  = RSS;
PisSS = 1;

muf = epsf/(epsf-1);

//----------------------------------------
//		Model
//----------------------------------------

model;
    
// 1 Euler equation 
% c - h*c(-1) = (c(+1)-h*c) - (1-h)/sig*(r - pie(+1) - epsg + epsg(+1));
(C-h*C(-1))^(-sig)*exp(sigg*epsg)/exp(sigg*epsg(+1)) = bet*R/Pie(+1) * (C(+1)-h*C)^(-sig);

// 2 Lambda
lam = (C-h*C(-1))^(-sig) * exp(sigg*epsg);

// 3 Goods market clearing
% (1-alf)*c = y - alf*eta*(2-alf)*s - alf*eta*lop - alf*ys;
(1-ACh-ACf)*Y = Ph^(-eta) * ((1-alf)*C + Q^eta*Ys);

// 4 Terms of trade
% s - s(-1) = pif - pih;
S = Pf/Ph;

// 5 Real exchange rate -- now: Lop gap definition
% q = lop + (1-alf)*s;
Psi = Q / Pf;

// 6 Firm markup
muh = lam*Ph*exp((1+psi)*siga*epsa)/exp(sigg*epsg)*Y^(-psi);

// 7 Firm optimal prices
% pih - delh*pih(-1) = (1-teth)/teth*(1-bet*teth)*( psi*y - (1+psi)*epsa + alf*s + (1-h)/sig*(c-h*c(-1)) ) + bet*(pih(+1)-delh*pih);
DACh*Ph/Ph(-1)*Pie = epsh*(muh^(-1)+ACh) - (epsh-1) + bet*lam(+1)/lam*Y(+1)/Y*DACh(+1)*Ph(+1)/Ph*Pie(+1);

// 8 Firm price adjustment costs
ACh = chih/2*(Ph/Ph(-1)*Pie-1)^2;

// 9 Firm price adjustment costs (derivative)
DACh = chih*(Ph/Ph(-1)*Pie-1);

// 10 Importers' optimal prices
% pif - delf*pif(-1) = (1-tetf)/tetf*(1-bet*tetf)*lop + bet*(pif(+1)-delf*pif) + epsc;
DACf*Pf/Pf(-1)*Pie = epsf*(Q/Pf+ACf) - muf*(epsf-1) + bet*lam(+1)/lam*(Pf(+1)/Pf)^(-eta)*C(+1)/C*DACf(+1)*Pf(+1)/Pf*Pie(+1);

// 11 Importer price adjustment costs
ACf = chif/2*(Pf/Pf(-1)*Pie-1)^2;

// 12 Importer price adjustment costs (derivative)
DACf = chif*(Pf/Pf(-1)*Pie-1);

// 13 CPI identity (now w/o CPI!)
% pie = pih + alf*(s-s(-1));
1 = (1-alf)*Ph^(1-eta) + alf*S^(1-eta)*Ph^(1-eta);

// 14 Uncovered interest rate parity
% (r - pie(+1)) - (rs - pis(+1)) = (q(+1)-q) - chi*a - epsp;
R = Rs * Pie(+1) / Pis(+1) * Q(+1) / Q * exp(-chi*A)*exp(-chi*sigp*epsp); 

// 15 Flow budget constraint
% c + a = a(-1)/bet - alf*(s+lop) + y;
C + YSS*A = YSS*Q/Q(-1) *Rs(-1)/Pis *A(-1) * exp(-chi*A)*exp(-chi*sigp*epsp) + Ph*Y + alf*(Pf-Q)*Pf^(-eta)*C;

// 16 Taylor rule
% r = psir*r(-1) + psip*pie + psiy*y + psid*(y-y(-1)) + epsr;
R = R(-1)^psir * RSS^(1-psir) * Pie^psip * (Y/YSS)^psiy * dER^psie * exp(sigr*epsr);

// 17 AR(1) for ys
% ys = roys*ys(-1) + sgys*epys;
Ys = Ys(-1)^roys * YsSS^(1-roys) * exp(sgys*epys);

// 18 AR(1) for pis
% pis = rops*pis(-1) + sgps*epps;
Pis = Pis(-1)^rops * PisSS^(1-rops) * exp(sgps*epps);

// 19 AR(1) for rs
% rs = rors*rs(-1) + sgrs*eprs;
Rs = Rs(-1)^rors * RsSS^(1-rors) * exp(sgrs*eprs);

// 20 Change in exchange rate (to get IRF closer to JP10)
dER = Q/Q(-1)*Pie/Pis;

end;

initval;

ACh  = 0;
DACh = 0;
ACf  = 0;
DACf = 0;
Q   = 1;
S   = 1;
Pie = 1;
Pis = 1;
Ph  = 1;
Pf  = 1;
Psi = 1;
R   = 1/bet;
muh = epsh/(epsh-1);
Y   = YSS;
C   = YSS;
lam = ((1-h)*C)^(-sig);
Ys  = YsSS;
Rs  = RsSS;
A   = 0;

dER = 1;
end;

steady;
resid;
check;

//----------------------------------------
//		Shocks
//----------------------------------------

shocks;

var epsa = 1;
var epsr = 1;
var epsg = 1;
var epsp = 1;
var epys = 1;
var epps = 1;
var eprs = 1;

end;


//----------------------------------------
//		Computation
//----------------------------------------

options_.pruning      = 1;
options_.relative_irf = 1;
stoch_simul(order=1, irf=8) C Y Pie R S Psi Q Pf Ph;



