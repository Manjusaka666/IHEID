% 1. Initial guess for start values to calculate the SS values later
% Calculate analytically the SS values of the two sector model 
% without financial frictions and without adjustment costs 
% These are used as initial guess for numerical calculation of 
% baseline model's SS values.
iX1aux = (1-alfai)^(alfai-1)*alfai^-alfai*(1-alfac)^(1-alfai)*alfac^(alfac*(1-alfai)/(1-alfac));
% steady state rental rate
icrk = (( exp((1/(1-alfai))*gv)/cbeta - (1-cdeltai) )*iX1aux*(1/clandap)^((alfac-alfai)/(1-alfac)) )^((1-alfac)/(1-alfai)); 
% steady state relative price of investment
icpi = iX1aux* icrk^((alfai-alfac)/(1-alfac))*(1/clandap)^((alfac-alfai)/(1-alfac));
% steady state wage
icw = ( (1/clandap)*(1-alfac)^(1-alfac)*alfac^alfac*icrk^-alfac )^(1/(1-alfac));
% steady state capital labour ratio in consumption sector
iKcLc = icw/icrk*(alfac/(1-alfac)); 
% steady state capital labour ratio in investment sector
iKiLi = icw/icrk*(alfai/(1-alfai)); 
% Labour
iLc = Lss*( 1+ nvalueic*(iKcLc^alfac)/(iKiLi^alfai)*icpi^-1 )^-1;
iLi = Lss - iLc;
% steady state capital in consumption sector
iKc = iKcLc*iLc;
% steady state capital in investment sector
iKi = iKiLi*iLi;
% steady state investment sector output
iiss = (1/clandap)*iKiLi^alfai*iLi;                                         
% steady state investement in I sector:
iiiss = iKi*(exp(1/(1-alfai)*gv) - (1-cdeltai));
% steady state consumption in I sector:
iicss = iKc*(exp(1/(1-alfai)*gv) - (1-cdeltac));
 x0 = [iKi; iKc; iiiss; iicss; icrk; icrk; iLi; iLc; icw; icpi;]; 
 x = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0;]; 
 options = optimset('Display','off','TolFun',1e-12,'TolX',1e-12);
 x = fsolve(@GTroot,x0,options);
X1aux = (1-alfai)^(alfai-1)*alfai^-alfai*(1-alfac)^(1-alfai)*alfac^(alfac*(1-alfai)/(1-alfac));
crki = x(5);
crkc = x(6);
cpi = x(10);
cw = x(9);
KcLc = x(2)/x(8);
KiLi = x(1)/x(7);
Lc = x(8);
Li = x(7);
css = (1/clandap)*KcLc^alfac*Lc;
Kc = x(2);
Ki = x(1);
K = x(2) + x(1);
iiss = x(3);
icss = x(4);

steady_state_model;
%% 2. Compute steady states of variables needed below
%%
Lss = 1;
cbeta = 1/(1+constebeta/100);
ga = cga/100 ;                                                              %#ok<NASGU>
gv = cgv/100 ;
clandap = 1 + clandapaux;
clandaw = 1 + clandawaux;                                                   %#ok<NASGU>
crho1 = 1/(cminrho - 1);
ga = cga/100;
% Values of steady state parameters needed for financial intermediaries:
sdfbss = 1;
rss = 1/cbeta * exp(ga+(alfac)/(1-alfai)*gv) * (constepinfc/100 + 1);
lriss = (1-psiiss)*lridata;
lrcss = (1-psicss)*lrcdata;
varomegai = (1-cthetabss*(0.005*lriss+(rss))*exp(-ga-alfac/(1-alfai)*gv))*((1-psiiss)*lridata)^(-1);
varomegac = varomegai; 
rbiss = ((1-varomegai*(1-psiiss)*lridata)*1/(cthetabss*exp(-ga-alfac/(1-alfai)*gv)) - rss)*1/lriss + rss;
rbcss = ((1-varomegac*(1-psicss)*lrcdata)*1/(cthetabss*exp(-ga-alfac/(1-alfai)*gv)) - rss)*1/lrcss + rss;

%% 3. Calculate values of "steady state parameters" for baseline model
%%
% Steady state equations for two sector model with adjustment costs a la 
% Huffman and Wynne and financial intermediaries
% Relabeling the variables:
% ki = x(1), kc = x(2), ii = x(3), ic = x(4) rik = x(5) rck = x(6) 
% Li = x(7) Lc = x(8) w = x(9)  pi = x(10)
Kibar = Ki*exp((1/(1-alfai))*gv);
Kcbar = Kc*exp((1/(1-alfai))*gv);
iss = (1/clandap)*KiLi^alfai*Li; 
% Solving for the bank's steady state parameters
nucss =((1-cthetabss)*sdfbss*exp(-ga-alfac/(1-alfai)*gv)*(rbiss-rss))/ (1 - cthetabss*cbeta*  ( (rbiss-rss)*  lrcss   + rss ) );
nuiss = nucss;
etaiss = lriss* (clamb - nuiss);
etacss = etaiss;                                                           
% Steady state of price of capital in I sector
qiss = (iiss^(-crho1) + icss^(-crho1))^(-1/crho1-1) * iiss^(-crho1-1) * cpi;
% Steady state of price of capital in C sector
qcss = (iiss^(-crho1) + icss^(-crho1))^(-1/crho1-1) * icss^(-crho1-1) * cpi;
% Quantity of financial claims held by bank in both sectors
siss = Kibar;
scss = Kcbar;
% Steady state output
yss = (css+cpi*iss) + ctau*psicss*qcss*scss + ctau*psiiss*qiss*siss;
% Steady state of z2 for Bank in both sectors
z2iss =  (rbiss-rss)*  lriss + rss;
z2css =  (rbcss-rss)*  lrcss + rss;
% Steady state of z1 for Bank in both sectors
z1css = z2css;
z1iss = z2iss;
% Steady state of shock to capital quality in both sectors
sncss = 1;
sniss = 1;
%% 4. Assign SS variables for Dynare solver
%%
labis = 0;
labcs = 0;
labs =0;
kcs = 0;
kis = 0;
kpis = 0;
kpcs = 0;
mccs = 0;
mcis = 0;
zcapis = 0;
zcapcs = 0;
rkis = 0;
rkcs = 0;
pis = 0;
cs = 0;
lams = 0;
phifis = 0;
phifcs = 0;
inveis = 0;
invecs = 0;
inves = 0;
ysss = 0;
pinfcs = 0;
pinfis = 0;
ws =0;
rs = 0;
zs = 0; 
vs = 0; 
z_ls = 0;
v_ls = 0;
bs = 0;
gs = 0;
qss = 0;
mss = 0; 
sws = 0;
ewmas = 0;  % Observables...
dys = 0 + 0 + alfac/(1-alfai)*0 + (cga + alfac/(1-alfai)*cgv)*0;  
dcs = 0-0 + 0 + alfac/(1-alfai)*0 + (cga + alfac/(1-alfai)*cgv)*0;
dinves = 0-0 + 1/(1-alfai)*0 + ( 1/(1-alfai)*cgv)*0;
dpis = 0 + 0 + (alfac-1)/(1-alfai)*0 + (cga+ (alfac-1)/(1-alfai)*cgv)*0;
dws = 0 + 0 + alfac/(1-alfai)*0 + (cga + alfac/(1-alfai)*cgv)*0;
labobss = 0;
robss = 0 + (log(constepinfc/100 + 1) - log(cbeta) + (cga + alfac/(1-alfai)*cgv))*0;
pinfobscs = 1*(0) + constepinfc*0;
pinfobsis = 1*(0) + constepinfi*0 ;
spreadobscs = 0 + (log(rbcss) - robss)*0;
spreadobsis = 0 + (log(rbiss) - robss)*0;
dequitys = exp(ga + alfac/(1-alfai)*gv)*(cga + alfac/(1-alfai)*cgv)*0;
rrates = 0;     % ... end observables.
epinfmacs = 0;    
epinfmais = 0;
spinfcs = 0;
spinfis = 0;
spis = 0;
spkcs = 0;
spkis = 0;
zcapifs = zcapis;    % flexible economy variables.
zcapcfs = zcapcs;
rkcfs = rkcs;
rkifs = rkis;
kpifs = kpis;
kpcfs = kpcs;
kifs = kis;
kcfs = kcs;
lamfs = lams;
phififs = phifis;
phifcfs = phifcs;
cfs = cs;
invefs = inves;
inveifs = inveis;
invecfs = invecs;
yfs = ysss;
labfs = labs;
labifs = labis;
labcfs = labcs;
pifs = pis;
wfs = ws;
sdfbfs = 0;     % beginning of variables specific for banking sector...
nucfs = 0;      % (flexible price economy)
nuifs = 0;
rbcfs = 0;
rbifs = 0;
z1cfs = 0;
z1ifs = 0;
etaifs = 0;
etacfs = 0;
z2cfs = 0;
z2ifs = 0;
lrcfs = 0;
lrifs = 0;
ncfs = 0;
nifs = 0;
qcfs = 0;
qifs = 0;
scfs = 0;
sifs = 0;   % ...end of variables specific for banking sector
sdfbs = 0;  % beginning of variables specific for banking sector...
rbcs = 0;   % (sticky price economy)
rbis = 0;
z1cs = 0;
z1is = 0;
z2cs = 0;
z2is = 0;
nucs = 0;
nuis = 0;
etacs = 0;
etais = 0;
lrcs = 0;
lris = 0;
qcs = 0;
qis = 0;
scs = 0;
sis = 0;
ncs = 0;
nis = 0;
rpcs = 0;
rpis = 0;   
sncs = 0;
snis = 0;
psics = 0;
psiis = 0; % ...end of variables specific for banking sector
epkc1aux = 0;
epkc2aux = 0;
epkc3aux = 0;
epkc4aux = 0;
epkc8aux = 0;
epki1aux = 0;
epki2aux = 0;
epki3aux = 0;
epki4aux = 0;
epki8aux = 0;
ez1aux = 0;
ez4aux = 0;
ez8aux = 0;
ev1aux = 0;
ev4aux = 0;
ev8aux = 0;
cthetabs = 0;
end;
% End of section dealing with steady-state
%********************************************************************