% SWFFplus Model 
% Based on Cai et al (2019) "DSGE Forecasts of the Lost Recovery"
var  
    c           ${c}$           (long_name='Consumption')
    inve        ${i}$           (long_name='Investment')
    y           ${y}$           (long_name='Output')
    lab         ${l}$           (long_name='hours worked')
    pinf        ${\pi}$         (long_name='Inflation')
    w           ${w}$           (long_name='real wage')
    r           ${r}$           (long_name='nominal interest rate')
    rk          ${r^{k}}$       (long_name='rental rate of capital')
    k           ${k^{s}}$       (long_name='Capital services')
    mc          ${\mu_p}$       (long_name='gross price markup') 
    spinf       ${\varepsilon^p}$       (long_name='Price markup shock process') 
    sw          ${\varepsilon^w}$       (long_name='Wage markup shock process')  
    g           ${\varepsilon^g}$       (long_name='Exogenous spending')
    b           ${c_2*\varepsilon_t^b}$ (long_name='Scaled risk premium shock')            
    rkf         ${r^{k,flex}}$  (long_name='rental rate of capital flex price economy') 
    kf          ${k^{s,flex}}$  (long_name='Capital services flex price economy') 
    cf          ${c^{flex}}$    (long_name='Consumption flex price economy') 
    invef       ${i^{flex}}$    (long_name='Investment flex price economy') 
    yf          ${y^{flex}}$    (long_name='Output flex price economy') 
    labf        ${l^{flex}}$    (long_name='hours worked flex price economy') 
    wf          ${w^{flex}}$    (long_name='real wage flex price economy')  
	sobs 	${Spread}$      (long_name='BBB-AAA Rate Spread') % Cai et al use (BBB-10yrTreasury)
	labobs      ${lHOURS}$      (long_name='log hours worked') 
    robs        ${FEDFUNDS}$    (long_name='Federal funds rate') 
    pinfobs     ${dlP}$         (long_name='Inflation') 
    dy          ${dlGDP}$       (long_name='Output growth rate') 
    dc          ${dlCONS}$      (long_name='Consumption growth rate') 
    dinve       ${dlINV}$       (long_name='Investment growth rate') 
    dw          ${dlWAG}$       (long_name='Wage growth rate')
% New variables in Cai    
	wh          ${w^{h}}$    (long_name='Marginal rate of substitution') 
	rktil 	${r^{ktil}}$       (long_name='Return to capital')
	ztil 	${z^{til}}$       (long_name='Stationary Technology shock')
	sigw 	${\sigma_w}$  (long_name='Financial shock')
	pist 		${\pi_*}$  (long_name='Inflation Target')
	og 	 	${OG}$          (long_name='OutputGap')
	zp 		${z_p}$           (long_name='Permanent Technology shock')
	n           ${n}$           (long_name='Entreprenurial Net Worth')
	z           ${w}$           (long_name='Trend growth rate') 
% Compared with SW: u=zcap mu=qs rm=ms kbar=kp qk=pk rf=rrf
    u        ${u}$           (long_name='Capital utilization rate') 
    mu          ${\varepsilon^i}$       (long_name='Investment-specific technology')
    rm          ${\varepsilon^r}$       (long_name='Monetary policy shock process')
    kbar          ${k}$           (long_name='Capital stock')
    qk          ${q}$           (long_name='real value of existing capital stock')  
    rf         ${r^{flex}}$    (long_name='real interest rate flex price economy')
    kbarf         ${k^{flex}}$            (long_name='Capital stock flex price economy')
    uf       ${z^{flex}}$    (long_name='Capital utilization rate flex price economy')
    qkf         ${q^{flex}}$    (long_name='real value of existing capital stock flex price economy')   
;
varexo 
	ea       ${\eta^a}$      (long_name='TFP shock')
    eb          ${\eta^b}$      (long_name='Risk Premium shock')
    eg          ${\eta^g}$      (long_name='Spending shock')
    eqs         ${\eta^i}$      (long_name='Investment-specific technology shock')
    em          ${\eta^m}$      (long_name='Monetary policy shock')
    epinf       ${\eta^{p}}$    (long_name='Price markup shock')  
    ew          ${\eta^{w}}$    (long_name='Wage markup shock') 
    esigw          ${\eta^{\sigma_w}}$    (long_name='Financial shock')
    epist          ${\eta^{\pi_*}}$    (long_name='Inflation Target shock')
    ezp          ${\eta^{z_p}}$    (long_name='Permanent technology shock') 
;
parameters 
	cbeta		${\beta}$          (long_name='discount rate') 
	cepsp ${\varepsilon_w}$  (long_name='Curvature Kimball aggregator wages')
    cepsw       ${\varepsilon_p}$   (long_name='Curvature Kimball aggregator prices')  
    calfa       ${\alpha}$          (long_name='capital share')  
    czcap       ${\psi}$            (long_name='capacity utilization cost')  
    csadjcost   ${\varphi}$         (long_name='investment adjustment cost')  
    ctou        ${\delta}$          (long_name='depreciation rate')  
    csigma      ${\sigma_c}$        (long_name='risk aversion')  
    chabb       ${\lambda}$         (long_name='external habit degree')  
%    ccs         ${d_4}$             (long_name='Unused parameter')  
%    cinvs       ${d_3}$             (long_name='Unused parameter')  
    cfc         ${\Phi}$          (long_name='fixed cost share')  
    cindw       ${\iota_w}$         (long_name='Indexation to past wages')  
    cprobw      ${\xi_w}$           (long_name='Calvo parameter wages')   
    cindp       ${\iota_p}$         (long_name='Indexation to past prices')  
    cprobp      ${\xi_p}$           (long_name='Calvo parameter prices')   
    csigl       ${\sigma_l}$        (long_name='Frisch elasticity')     
%    crdpi       ${r_{\Delta \pi}}$  (long_name='Unused parameter')  
    crpi        ${r_{\pi}}$         (long_name='Taylor rule inflation feedback') 
    crdy        ${r_{\Delta y}}$    (long_name='Taylor rule output growth feedback') 
    cry         ${r_{y}}$           (long_name='Taylor rule output level feedback') 
    crr         ${\rho}$            (long_name='interest rate persistence')  
% Financial frictions 
    czeta_spb ${\zeta_{sp}}$       (long_name='Spread elasticity') 
	cgammstar ${\gamma^*}$         (long_name='Wealth parameter')  
	cvstar ${v^*}$  	(long_name='Wealth parameter')
	cnstar ${n_*}$           (long_name='SS Entrepreneurial wealth')
	czeta_nRk ${\zeta_{nRk}}$	(long_name='Net Worth parameter')
	czeta_nR ${\zeta_{nR}}$	(long_name='Net Worth parameter')
	czeta_nsigw 	${\zeta_{n\sigma_{w}}}$	(long_name='Net Worth parameter')
	czeta_spsigw	${\zeta_{sp\sigma_{w}}}$	(long_name='Net Worth parameter')
    czeta_nqk ${\zeta_{nqk}}$	(long_name='Net Worth parameter')
	czeta_nn ${\zeta_{nn}}$	(long_name='Net Worth parameter')
% Shock persistence
    cgy         ${\rho_{ga}}$       (long_name='Feedback technology on exogenous spending') 
    cmaw        ${\mu_w}$           (long_name='coefficient on MA term wage markup')  
    cmap        ${\mu_p}$           (long_name='coefficient on MA term price markup')  
	crhosigw ${\rho_{\sigma_w}}$    (long_name='persistence Financial shock')
	crhopist ${\rho_{\pi_*}}$    (long_name='persistence Inflation Target shock')
	crhozp 	${\rho_{zp}}$    (long_name='persistence permanent technology shock')
	csigma_spinf 	${\sigma_{map}}$    (long_name='price markup MA scaling')
	csigma_sw 	${\sigma_{maw}}$    (long_name='wage markup MA scaling')
    crhoa       ${\rho_a}$          (long_name='persistence productivity shock')  
 %   crhoas      ${d_2}$             (long_name='Unused parameter')  
    crhob       ${\rho_b}$          (long_name='persistence risk premium shock')  
    crhog       ${\rho_g}$          (long_name='persistence spending shock')  
%    crhols      ${d_1}$             (long_name='Unused parameter')  
    crhoqs      ${\rho_i}$          (long_name='persistence risk premium shock')  
    crhoms      ${\rho_r}$          (long_name='persistence monetary policy shock')  
    crhopinf    ${\rho_p}$          (long_name='persistence price markup shock')  
    crhow       ${\rho_w}$          (long_name='persistence wage markup shock')  
% Steady state values
    cgamma  ${\gamma}$       (long_name='Adjusted trend')
	crkstar ${\bar {rk}}$           (long_name='SS return on capital')
	ckstar  ${k^*}$           (long_name='Capital-Output ratio')
	ckbarstar ${\bar k^*}$     (long_name='SS Capital-Output ratio')
	cinvestar   ${\frac{\bar i}{\bar y}}$         (long_name='Private investment share in aggregate output')
	cystar   ${\frac{\bar {yp}}{\bar y}}$      (long_name='Private output share in aggregate output')
	ccstar    ${\frac{\bar c}{\bar y}}$       (long_name='Private consumption share in aggregate output')
	cwl_c 	${wl_c}$           (long_name='Consumption wage parameter')
% Measurement equation parameters  
	conster 	${\bar r}$          (long_name='steady state interest rate') 
    constelab   ${\bar l}$          (long_name='steady state hours')  
    constepinf  ${\bar \pi}$        (long_name='steady state inflation rate')
    ctrend      ${\bar \gamma}$     (long_name='net growth rate in percent')  
    cg          ${\frac{\bar g}{\bar y}}$     (long_name='steady state exogenous spending share') 
;
% Parameter values
calfa = 0.1787;          
cprobp = 0.8680;        % Cai zeta_p (SW2007: cprobp = Calvo probability)
cindp = 0.2259;         % Cai iota_p (SW2007: cindp = indexation)
ctou = 0.025;            
cfc = 1.5262;           % Cai Bigphi
csadjcost = 3.0437;           % second derivative of the adjustment cost function
chabb = 0.2440;         % Cai h
czcap = 0.1884;         % Cai ppsi
csigl = 2.6732;         % Cai nu_l
cprobw = 0.8875;        % Cai zeta_w (SW2007: cprobw = Calvo probability wages)
cindw = 0.4187;         % Cai iota_w (SW2007: cindw = wage indexation)
cbeta = 0.9987;          
crpi = 1.3737;           
cry = 0.0180;            
crdy = 0.2398;           
csigma = 1.3159;         
crr = 0.6750;            
cepsp = 10;              
cepsw = 10;              
% Financial frictions parameters
czeta_spb = 0.0443;
cgammstar = 0.9900;
cvstar = 2.4708;
cnstar = 2.4492;
czeta_nRk = 1.6938;
czeta_nR = 0.6930;
czeta_nsigw = 0.0043;
czeta_spsigw = 0.0276;
czeta_nqk = 0.0021;
czeta_nn = 0.9987;
% Exogenous processes
cg = 0.1800;             
crhoa = 0.9564;         % technology shock persistence (Cai rho_z)
crhob = 0.9440;         % risk premium persistence
crhog = 0.9793;         % government spending persistence
crhoqs = 0.6435;        % investment shock persistence (Cai rho_mu)
crhoms = 0.0673;        % monetary policy shock persistence
crhopinf = 0.7939;     % price markup persistence (Cai rho_laf)
crhow = 0.6609;        % wage markup persistence (Cai rho_law)
crhosigw = 0.9899;      % financial shock persistence
crhopist = 0.9900;      % inflation target persistence
crhozp = 0.95;          % permanent technology shock persistence
cgy = 0.8737;       % government spending spillover from technology
cmap = 0.7143;    % price markup MA coefficient (Cai eta_laf)
cmaw = 0.5720;       % wage markup MA coefficient (Cai eta_law)
csigma_spinf = 1;       % price markup MA scaling
csigma_sw = 1;          % wage markup MA scaling
% Steady state values
cgamma = 0.0040; 
crkstar = 0.0364;
ckstar = 4.1487;
ckbarstar = 4.1654;
cinvestar = 0.1204;
cystar = 0.8449;
ccstar = 0.5725;
cwl_c = 0.8081;
% Measurement equation constants
constelab=0;
constepinf = 0.7;
conster = 0.7;
ctrend = 0.40;          % = cgamma

model(linear);
% Deal with parameter dependencies (SW2007 compound coefficient style)
#cbetabar = cbeta*exp((1-csigma)*cgamma);
#cpie = 1 + constepinf/100;
#crss = cpie/cbetabar;
#clandap = cfc;
% Consumption Euler equation coefficients
#c1 = (chabb*exp(-cgamma))/(1+chabb*exp(-cgamma));
#c2 = (1-chabb*exp(-cgamma))/(csigma*(1+chabb*exp(-cgamma)));
#c3 = (1/(1+chabb*exp(-cgamma)));
#c4 = (1/(1-calfa))*(crhoa-1);  
#c5 = (csigma-1)*cwl_c/(csigma*(1+chabb*exp(-cgamma)));
% Investment Euler equation coefficients 
#i1 = (1/(1+cbetabar));
#i2 = (cbetabar/(1+cbetabar));
#i3 = csadjcost*exp(2*cgamma)*(1+cbetabar);
% Capital evolution coefficients
#k1 = (1-cinvestar/ckbarstar);
#k2 = (cinvestar/ckbarstar);
#k3 = (cinvestar*csadjcost*exp(2*cgamma)*(1+cbetabar)/ckbarstar);
% Utilization coefficient
#u1 = ((1-czcap)/czcap);
% Phillips curve coefficients 
#pi1 = ((1-cprobp*cbetabar)*(1-cprobp))/(cprobp*((cfc-1)*cepsp+1));
#pi2 = (1/(1+cindp*cbetabar));
#pi3 = (cindp/(1+cindp*cbetabar));
#pi4 = (cbetabar/(1+cindp*cbetabar));
% Wage equation coefficients 
#w1 = ((1-cprobw*cbetabar)*(1-cprobw)/(cprobw*((1.5-1)*cepsw+1)));
#w2 = (1/(1+cbetabar));
#w3 = (1+cindw*cbetabar)/(1+cbetabar);
#w4 = (cbetabar/(1+cbetabar));
% Resource constraint coefficients
#y1 = (ccstar/cystar);
#y2 = (cinvestar/cystar);
#y3 = crkstar*(ckstar/cystar);
% Financial frictions coefficients
#ff1 = (crkstar/(crkstar+1-ctou));
#ff2 = ((1-ctou)/(crkstar+1-ctou));
#ff3 = (csigma*(1+chabb*exp(-cgamma)))/(1-chabb*exp(-cgamma));
#ff4 = (cgammstar*cvstar/cnstar);
% Marginal rate of substitution coefficient
#mrs1 = (1/(1-chabb*exp(-cgamma)));
% CORE MODEL EQUATIONS
[name='Consumption Euler equation'] % Cai A-3
% Note: in the term c3*(c(+1) + z(+1)), here (and in later equations) it is necessary for technical reasons to replace z(+1) by E(z(+1))=c4*ztil
c = -c2*(r-pinf(+1)) + b + c1*(c(-1)-z) + c3*(c(+1)+c4*ztil) + c5*(lab-lab(+1));
[name='Investment Euler equation'] % Cai A-4
qk = i3*(inve - i1*(inve(-1)-z) - i2*inve(+1) - i2*c4*ztil - mu);
[name='Capital evolution'] % Cai A-5
kbar = k1*(kbar(-1)-z) + k2*inve + k3*mu;
[name='Capital utilization'] % Cai A-7
k = u - z + kbar(-1);
[name='Rate of utilization'] % Cai A-8
u = u1*rk;
[name='Price markup'] % Cai A-10
mc = w + calfa*lab - calfa*k;
[name='Rental rate of capital'] % Cai A-9
k = w - rk + lab;
[name='Aggregate production function'] % Cai A-11
y = cfc*calfa*k + cfc*(1-calfa)*lab + ((cfc-1)/(1-calfa))*ztil;
[name='Resource constraint'] % Cai A-12
y = cg*g + y1*c + y2*inve + y3*u - cg*c4*ztil;
[name='Phillips curve'] % Cai A-14
pinf = pi1*pi2*mc + pi3*pinf(-1) + pi4*pinf(+1) + spinf;
[name='Wage evolution'] % Cai A-15
w = w1*w2*(wh-w) - w3*pinf + w2*(w(-1)-z + cindw*pinf(-1)) + w4*(w(+1)+c4*ztil+pinf(+1)) + sw;
[name='Marginal rate of substitution'] % Cai A-16
wh = mrs1*(c - chabb*exp(-cgamma)*c(-1) + chabb*exp(-cgamma)*z) + csigl*lab;
[name='Taylor rule'] % Cai A-19
r = crr*r(-1) + (1-crr)*crpi*(pinf-pist) + (1-crr)*cry*(y-yf) + crdy*((y-yf)-(y(-1)-yf(-1))) + rm;
% FINANCIAL FRICTIONS BLOCK
[name='Return to capital'] % Cai A-25
rktil = ff1*rk + ff2*qk - qk(-1) + pinf;
[name='Spreads equation'] % Cai A-24
rktil(+1) = r - ff3*b + czeta_spb*(qk + kbar - n) + sigw;
[name='Evolution of net worth'] % Cai A-26
n = czeta_nRk*(rktil - pinf) - czeta_nR*(r(-1) - pinf) +
    czeta_nqk*(qk(-1) + kbar(-1)) + czeta_nn*n(-1)
    - (czeta_nsigw/czeta_spsigw)*sigw(-1) - ff4*z;
% FLEXIBLE PRICE ECONOMY
[name='Flexible consumption Euler']
cf = -c2*rf + b + c1*(cf(-1)-z) + c3*(cf(+1)+c4*ztil) + c5*(labf-labf(+1));
[name='Flexible investment Euler']
qkf = i3*(invef - i1*(invef(-1)-z) - i2*invef(+1) - i2*c4*ztil - mu);
[name='Flexible capital evolution']
kbarf = k1*(kbarf(-1)-z) + k2*invef + k3*mu;
[name='Flexible capital utilization']
kf = uf - z + kbarf(-1);
[name='Flexible rate of utilization']
uf = u1*rkf;
[name='Flexible price markup']
wf = -calfa*labf + calfa*kf;
[name='Flexible rental rate of capital']
kf = wf - rkf + labf;
[name='Flexible production function']
yf = cfc*calfa*kf + cfc*(1-calfa)*labf + ((cfc-1)/(1-calfa))*ztil;
[name='Flexible resource constraint']
yf = cg*g + y1*cf + y2*invef + y3*uf - cg*c4*ztil;
[name='Flexible marginal rate of substitution']
wf = mrs1*(cf - chabb*exp(-cgamma)*cf(-1) + chabb*exp(-cgamma)*z) + csigl*labf;
[name='Flexible arbitrage condition']
qkf = ff1*rkf(+1) + ff2*qkf(+1) - rf + ff3*b;
[name='Output gap definition']
og = y - yf;
% EXOGENOUS PROCESSES 
[name='Technology shock level'] % Cai A-28 [replaces A-2 in SWFF+]
z = c4*ztil(-1) + (1/(1-calfa))*ea + zp;
[name='Technology shock stationary'] % Cai A-1
ztil = crhoa*ztil(-1) + ea;  
[name='Government spending shock']
g = crhog*g(-1) + eg + cgy*ea; % Cai A-13
[name='Risk premium shock']
b = crhob*b(-1) + eb;
[name='Investment shock'] 
mu = crhoqs*mu(-1) + eqs;  
[name='Price markup shock'] % Cai A-17
spinf = crhopinf*spinf(-1) + epinf - cmap*csigma_spinf*epinf(-1);
[name='Wage markup shock'] % Cai A-18
sw = crhow*sw(-1) + ew - cmaw*csigma_sw*ew(-1);
[name='Monetary policy shock']
rm = crhoms*rm(-1) + em;
[name='Financial shock']
sigw = crhosigw*sigw(-1) + esigw;
[name='Inflation target shock'] % Cai A-22
pist = crhopist*pist(-1) + epist;
[name='Permanent technology shock'] % Cai A-29
zp = crhozp*zp(-1) + ezp;
% MEASUREMENT EQUATIONS
[name='Output growth']
dy = y - y(-1) + ctrend + z;
[name='Consumption growth']
dc = c - c(-1) + ctrend + z;
[name='Investment growth']
dinve = inve - inve(-1) + ctrend + z;
[name='Wage growth']
dw = w - w(-1) + ctrend + z;
[name='Hours worked']
labobs = lab + constelab;
[name='Interest rate']
robs = r + conster;
[name='Inflation']
pinfobs = pinf + constepinf;
[name='Spread']
sobs = 100*(rktil - r) + 0.02;
end;

resid;
steady;
check;

shocks;
var ea; stderr 0.4961;
var eb; stderr 0.0384;
var eg; stderr 2.908;
var eqs; stderr 0.5033;
var em; stderr 0.2919;
var epinf; stderr 0.1535;
var ew; stderr 0.2568;
var esigw; stderr 0.0575;
var epist; stderr 0.030;
var ezp; stderr 0.1;
end;

estimated_params;
% Below are Cai et al priors
% Structural
calfa,0.24,0.01,1.0,NORMAL_PDF,0.3,0.05;
czcap,0.2648,0.01,1,BETA_PDF,0.5,0.15;
cfc,1.4672,1.0,3,NORMAL_PDF,1.25,0.125;
cindw,0.4425,0.01,0.99,BETA_PDF,0.5,0.15;
cprobw,0.7937,0.3,0.95,BETA_PDF,0.5,0.1;
cindp,0.3291,0.01,0.99,BETA_PDF,0.5,0.15;
cprobp,0.7813,0.5,0.95,BETA_PDF,0.5,0.10;
csigma,1.2312,0.25,3,NORMAL_PDF,1.50,0.375;
csigl,,-10.0,10.0,NORMAL_PDF,2,0.75;
chabb,0.7205,0.001,0.99,BETA_PDF,0.7,0.1;
csadjcost,,-10.0,10.0,NORMAL_PDF,4,1.5;
% MonPol
crpi,1.7985,1.0,3,NORMAL_PDF,1.5,0.25;
cry,0.0893,0.001,0.5,NORMAL_PDF,0.125,0.05;
crdy,0.2239,0.001,0.5,NORMAL_PDF,0.125,0.05;
crr,0.8258,0.5,0.975,BETA_PDF,0.75,0.10;
% new parameters from Cai
cnstar,1.2918,-10.0,10.0,NORMAL_PDF,0.0,2.0;
cgamma,,-10.0,10.0,NORMAL_PDF,0.4,0.1;
czeta_spb, 0.0443, 0.01, 0.9999, BETA_PDF, 0.05, 0.005;
% Trends
constepinf,0.7,0.1,2.0,GAMMA_PDF,0.625,0.2;%20;
cgy,,.01,.9999,BETA_PDF,0.5,0.20;
% Persistence
crhoa,,.01,.9999,BETA_PDF,0.5,0.20;
crhob,.2703,.01,.9999,BETA_PDF,0.5,0.20;
crhog,.9930,.01,.9999,BETA_PDF,0.5,0.20;
crhoqs,,.01,.9999,BETA_PDF,0.5,0.20;
crhoms,,.01,.9999,BETA_PDF,0.5,0.20;
crhopinf,,.01,.9999,BETA_PDF,0.5,0.20;
crhow,,.01,.9999,BETA_PDF,0.5,0.20;
crhosigw,,.01,.9999,BETA_PDF,0.75,0.15;
crhopist,,.01,.9999,BETA_PDF,0.75,0.15;
cmap,,.01,.9999,BETA_PDF,0.5,0.20;
cmaw,,.01,.9999,BETA_PDF,0.5,0.20;

% Variance
stderr ea,0.4618,0.01,3,INV_GAMMA_PDF,0.1,2; 
stderr eb,0.1818513,0.025,5,INV_GAMMA_PDF,0.1,2;
stderr eg,0.6090,0.01,5,INV_GAMMA_PDF,0.1,2;
stderr eqs,0.46017,0.01,3,INV_GAMMA_PDF,0.1,2;
stderr em,0.2397,0.01,3,INV_GAMMA_PDF,0.1,2;
stderr epinf,0.1455,0.01,3,INV_GAMMA_PDF,0.1,2;
stderr ew,0.2089,0.01,3,INV_GAMMA_PDF,0.1,2;
stderr esigw,0.0575,0.01,3,INV_GAMMA_PDF,0.1,2;
stderr epist,0.03,0.01,3,INV_GAMMA_PDF,0.1,2;
end;

varobs dy dc dinve labobs pinfobs dw robs sobs;
%data period 1965Q1-2025Q1
estimation(Tex, optim=('MaxIter',20000), 
            datafile='SW_Data4HW2025.xlsx', 
            xls_sheet=NewSobs, 
            mode_compute=1, first_obs=1, nobs=241, 
            presample=4, lik_init=2, prefilter=0, mh_replic=0, 
            mh_nblocks=2,mh_jscale=0.2, irf=24);

stoch_simul(Tex, irf=40) y c inve pinf r w k lab qk n rktil og;

%----------------------------------------------------------------
% generate LaTeX output
%----------------------------------------------------------------
%write_latex_dynamic_model;
write_latex_original_model;
write_latex_parameter_table;
write_latex_definitions;
write_latex_prior_table;
collect_latex_files;
if system(['pdflatex -halt-on-error -interaction=batchmode ' M_.fname '_TeX_binder.tex'])
    error('TeX-File did not compile.')
end

