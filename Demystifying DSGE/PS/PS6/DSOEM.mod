// Rational Expectations SOE model as in Justiniano and Preston (2010)
// Estimation for Australia

var 
c       // (1) consumption
y       // (2) output
r       // (3) interest rate 
q       // (4) RER
tot     // (5) Terms of trade
cpi     // (6) CPI
pih     // (7) domestic inflation
pif     // (8) foreign inflation
lop     // (9) law of one price
a       // (10) net foreign asset position
dtot    // (11) TOT growth
dQ      // (12) RER growth
mc      // (13) real marginal cost

pi_st   // (1) foreing inflation
y_st    // (2) foreign output
r_st    // (3) foreign interest rate

z      // (1) TFP shock
g      // (2) Preference shock
rp     // (3) Risk-premium shock
cps    // (4) Cost push shock

%Measurement EQ
PI_US   // (1)
YGR_US  // (2)
R_US    // (3)
PI_AUS  // (4)
dRER    // (5)
R_AUS   // (6)
YGR_AUS // (7)
dTOT    // (8)
;

// Exogenous variables
varexo 
eps_pst % foreign inflation shock
eps_yst % foreign output shock
eps_rst % foreign interest shock

eps_z   % technology shock
eps_g   % preference shock
eps_rp  % risk premium shock
eps_cp  % cost-push shock
eps_r   % monetary policy shock

; 

// Parameters
parameters 
hh          % (1)  Habit
sigmaa      % (2)  Inverse intertemporal elasticity of substitution
etaa        % (3)  Elasticity between Home and Foreign Goods
delta_h     % (4)  Indexation rule for domestic firms
theta_h     % (5)  Calvo parameter for domestic firms
phii        % (6)  Inverse Frisch
delta_f     % (7)  Indexation for Retail firms
theta_f     % (8) Calvo parameter for retail firms
rho_int     % (9) Int rate smoothing
mp_pi       % (10) Response of policy rate to CPI inflation 
mp_y        % (11) Response of policy rate to output
mp_dy       % (12) Response of policy rate to output growth
mp_de       % (13) Response of policy rate to exchange rate depreciation
rho_g       % (14) Persistence of preference shock
rho_z       % (15) Persistence of technology shock
rho_rp      % (16) Persistence of risk-premium shock
rho_cp      % (17) Persistence of cost-push shock
betaa       % (18)  Time discount factor (calibrated)
alphaa      % (19)  Openness (calibrated)
chii        % (20)

// Foreign Block : VAR (2) Coefficients

// VAR parameters
rhops rho2ps rhopsys rho2psys rhopsis rho2psis 
rhoys rho2ys rhoysps rho2ysps rhoysis rho2ysis 
rhois rho2is rhoisys rho2isys rhoisps rho2isps
;

// Calibration
betaa  = 0.99 ;   % #1
chii   = 0.01 ;   % #2
alphaa = 0.185;   % #3 

% To estimate

hh       = 0.6;   % (1)  Habit
sigmaa   = 1.5;   % (2)
etaa     = 1.1;   % (3)  Elasticity between Home and Foreign Goods
delta_h  = 0.0;   % (4)  Indexation rule for domestic firms
theta_h  = 0.75;  % (5)  Calvo parameter for domestic firms
phii     = 1.0;   % (6)  Inverse Frisch
delta_f  = 0.0;   % (7)  Indexation for Retail firms
theta_f  = 0.75;  % (8) Calvo parameter for retail firms
rho_int  = 0.8;   % (9) Int rate smoothing
mp_pi    = 1.75;  % (10) Response of policy rate to CPI inflation 
mp_y     = 0.05;  % (11) Response of policy rate to output
mp_dy    = 0.25;  % (12) Response of policy rate to output growth
mp_de    = 0.25;  % (13) Response of policy rate to exchange rate depreciation
rho_g    = 0.9;   % (14) Persistence of preference shock
rho_z    = 0.9;   % (15) Persistence of technology shock
rho_rp   = 0.9;   % (16) Persistence of risk-premium shock
rho_cp   = 0.9;   % (17) Persistence of monetary policy shock

rhops   = 0.95; rho2ps = 0; rhopsys = 0; rho2psys = 0; rhopsis = 0; rho2psis = 0;
rhoys   = 0.95; rho2ys = 0; rhoysps = 0; rho2ysps = 0; rhoysis = 0; rho2ysis = 0;
rhois   = 0.95; rho2is = 0; rhoisys = 0; rho2isys = 0; rhoisps = 0; rho2isps = 0;

model(linear);

// VAR equations
pi_st = rhops*pi_st(-1) + rho2ps*pi_st(-2) + rhopsys*y_st(-1) + rho2psys*y_st(-2) + rhopsis*r_st(-1) + rho2psis*r_st(-2) + eps_pst;
y_st = rhoys*y_st(-1) + rho2ys*y_st(-2) + rhoysps*pi_st(-1) + rho2ysps*pi_st(-2) + rhoysis*r_st(-1) + rho2ysis*r_st(-2) + eps_yst;
r_st = rhois*r_st(-1) + rho2is*r_st(-2) + rhoisys*y_st(-1) + rho2isys*y_st(-2) + rhoisps*pi_st(-1) + rho2isps*pi_st(-2) + eps_rst;

// (1) Preference shock
g   = rho_g*g(-1) + eps_g ; 

// (2) Risk premium shock
rp  = rho_rp*rp(-1) + eps_rp; 

// (3) Cost-push shock
cps = rho_cp*cps(-1) + eps_cp;

// (4) Technology shock
z   = rho_z*z(-1) + eps_z ;

// (1) IS-equation 
(1+hh)*c = c(+1) + hh*c(-1) - ((1-hh)/sigmaa)*(r - cpi(+1)) + ((1-hh)/sigmaa)*(g-g(+1));

// (2) Aggregate demand
y = (1-alphaa)*c + alphaa*etaa*(2-alphaa)*tot + alphaa*etaa*lop + alphaa*y_st;

// (3) TOT
tot   =  pif - pih + tot(-1); 

// (4) TOT growth 
dtot = tot - tot(-1);

// (5) Law of One Price Gap
lop = q - (1-alphaa)*tot; 

// (6) Domestic producer's PC
(1 + betaa*delta_h)*pih  =  betaa*pih(+1) + delta_h*pih(-1) + ((theta_h)^(-1)*(1-theta_h)*(1-betaa*theta_h))*mc ; 

// (7) Real marginal cost
mc = phii*y - (1+phii)*z + alphaa*tot + (sigmaa/(1-hh))*(c - hh*c(-1)); 

// (8) Retailer's PC
(1 + betaa*delta_f)*pif  =  betaa*pif(+1) + delta_f*pif(-1) + ((theta_f)^(-1)*(1-theta_f)*(1-betaa*theta_f))*lop+ cps; 

// (9) CPI inflation
%cpi = (1-alphaa)*pih + alphaa*pif;
cpi = pih + alphaa*dtot;

// (10) UIP
(r - cpi(+1)) - (r_st - pi_st(+1))  = dQ(+1) - chii*a - rp;  

//(11) RER growth
dQ = q - q(-1);

// (12) Foreign asset position
a - (1/betaa)*a(-1) =  y - c - alphaa*(tot+lop);

// (13) Monetary policy rule
r = rho_int*r(-1) + (1-rho_int)*(mp_pi*cpi + mp_y*y + mp_dy*(y - y(-1)) + mp_de*(dQ + cpi - pi_st)) + eps_r ;
%r = rho_int*r(-1) + mp_pi*cpi + mp_y*y + mp_dy*(y-y(-1)) + mp_de*(dQ + cpi - pi_st)+ eps_r ;

// Measurement equations (14) - (21) 
PI_US  = 4*pi_st; 
YGR_US = y_st;
R_US   = 4*r_st;

PI_AUS  = 4*cpi;
dRER   =  dQ;
R_AUS   = 4*r;
YGR_AUS = y;
dTOT    = dtot;

end;

steady;

estimated_params;
//                 STARTING VALUES &          PRIORS
    sigmaa,   1.2, 1E-5,   10,        GAMMA_PDF,  1.2,    0.30 ;
    phii,     1.5, 1E-5,   10,        GAMMA_PDF,  1.5,    0.75 ;
    theta_h,  0.6, 1E-5,   0.999,     BETA_PDF,   0.5,    0.10 ;
    theta_f,  0.6, 1E-5,   0.999,     BETA_PDF,   0.5,    0.10 ;
    etaa,     1.5, 1E-5,   10   ,     GAMMA_PDF,  1.5,    0.75 ;
    hh,       0.5, 1E-5,   0.999,     BETA_PDF,   0.5,    0.25 ;
    delta_h,  0.1, 1E-5,   0.999,     BETA_PDF,   0.5,    0.25 ;
    delta_f,  0.1, 1E-5,   0.999,     BETA_PDF,   0.5,    0.25 ;
    rho_int,  0.5, 1E-5,   10,        BETA_PDF,   0.5,    0.25 ;
    mp_pi,    1.5, 1,   10,           GAMMA_PDF,  1.5,    0.30 ;
    mp_y,     0.2, 1E-5,   10,        GAMMA_PDF,  0.25,   0.13 ;
    mp_dy,    0.2, 1E-5,   10,        GAMMA_PDF,  0.25,   0.13 ;
    mp_de,    0.2, 1E-5,   10,        GAMMA_PDF,  0.25,   0.13 ;   
    rho_cp,   0.8, 0.001,  0.999,     BETA_PDF,   0.5,    0.25;
    rho_rp,   0.8, 0.001,  0.999,     BETA_PDF,   0.8,    0.1;
    rho_z,    0.8, 0.001,  0.999,     BETA_PDF,   0.8,    0.1;
    rho_g,    0.8, 0.001,  0.999,     BETA_PDF,   0.8,    0.1; 
   
    rhops,      normal_pdf, 0.59, 0.2; 
    rho2ps,     normal_pdf, 0, 0.25; 
    rhopsys,    normal_pdf, 0, 0.3; 
    rho2psys,   normal_pdf, 0, 0.15; 
    rhopsis,    normal_pdf, 0, 0.3; 
    rho2psis,   normal_pdf, 0, 0.15; 
    rhoys,      normal_pdf, 0.8, 0.2; 
    rho2ys,     normal_pdf, 0, 0.25; 
    rhoysps,    normal_pdf, 0, 0.3; 
    rho2ysps,   normal_pdf, 0, 0.15; 
    rhoysis,    normal_pdf, 0, 0.3; 
    rho2ysis,   normal_pdf, 0, 0.15; 
    rhois,      normal_pdf, 0.8, 0.2; 
    rho2is,     normal_pdf, 0, 0.25; 
    rhoisys,    normal_pdf, 0, 0.3; 
    rho2isys,   normal_pdf, 0, 0.15; 
    rhoisps,    normal_pdf, 0, 0.3; 
    rho2isps,   normal_pdf, 0, 0.15; 

//  Shocks
    stderr eps_pst,  INV_GAMMA1_PDF, 0.5, inf;
    stderr eps_rst,  INV_GAMMA1_PDF, 0.5, inf;
    stderr eps_yst,  INV_GAMMA1_PDF, 0.5, inf;
    
    stderr eps_rp,   INV_GAMMA1_PDF, 0.5, inf;
    stderr eps_r,    INV_GAMMA1_PDF, 0.5, inf;
    stderr eps_cp,   INV_GAMMA1_PDF, 0.5, inf;
    stderr eps_z,    INV_GAMMA1_PDF, 0.5, inf;
    stderr eps_g,    INV_GAMMA1_PDF, 0.5, inf;
end;

varobs PI_US YGR_US R_US PI_AUS dRER R_AUS YGR_AUS dTOT; %


% model_diagnostics;
% estimation(datafile=Australian_Data,
% diffuse_filter,
% mode_compute=4,
% plot_priors=0,nograph,
% % prefilter=1,
% prefilter=0,
% first_obs=5,presample =4 ,
% mh_nblocks=1,mh_replic=0,mh_jscale=0.4);
estimation(Tex,datafile=Australian_Data,
first_obs=5,prefilter=1,presample=4,
mode_compute=4,mh_replic=0) YGR_AUS R_AUS PI_AUS dRER;


//estimation(datafile=data_neer_jp,plot_priors=0,nograph,mode_compute=0,mode_check,prefilter=1,first_obs=1,nobs=30,mh_nblocks=1,diffuse_filter,mh_replic=50000,mh_jscale=0.3);


