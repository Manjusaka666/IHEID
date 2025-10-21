5% SW2007 Shocks and Frictions in US Business Cycles - Bayesian Approach
var 
	labobs      ${lHOURS}$      (long_name='log hours worked') 
    robs        ${FEDFUNDS}$    (long_name='Federal funds rate') 
    pinfobs     ${dlP}$         (long_name='Inflation') 
    dy          ${dlGDP}$       (long_name='Output growth rate') 
    dc          ${dlCONS}$      (long_name='Consumption growth rate') 
    dinve       ${dlINV}$       (long_name='Investment growth rate') 
    dw          ${dlWAG}$       (long_name='Wage growth rate') 
    ewma        ${\eta^{w,aux}}$ (long_name='Auxiliary wage markup moving average variable')  
    epinfma     ${\eta^{p,aux}}$ (long_name='Auxiliary price markup moving average variable')  
    zcapf       ${z^{flex}}$    (long_name='Capital utilization rate flex price economy') 
    rkf         ${r^{k,flex}}$  (long_name='rental rate of capital flex price economy') 
    kf          ${k^{s,flex}}$  (long_name='Capital services flex price economy') 
    pkf         ${q^{flex}}$    (long_name='real value of existing capital stock flex price economy')  
    cf          ${c^{flex}}$    (long_name='Consumption flex price economy') 
    invef       ${i^{flex}}$    (long_name='Investment flex price economy') 
    yf          ${y^{flex}}$    (long_name='Output flex price economy') 
    labf        ${l^{flex}}$    (long_name='hours worked flex price economy') 
    wf          ${w^{flex}}$    (long_name='real wage flex price economy') 
    rrf         ${r^{flex}}$    (long_name='real interest rate flex price economy')
    mc          ${\mu_p}$       (long_name='gross price markup') 
    zcap        ${z}$           (long_name='Capital utilization rate') 
    rk          ${r^{k}}$       (long_name='rental rate of capital') 
    k           ${k^{s}}$       (long_name='Capital services') 
    pk          ${q}$           (long_name='real value of existing capital stock') 
    c           ${c}$           (long_name='Consumption')
    inve        ${i}$           (long_name='Investment')
    y           ${y}$           (long_name='Output')
    lab         ${l}$           (long_name='hours worked')
    pinf        ${\pi}$         (long_name='Inflation')
    w           ${w}$           (long_name='real wage')
    r           ${r}$           (long_name='nominal interest rate')
    a           ${\varepsilon_a}$       (long_name='productivity process')
    b           ${c_2*\varepsilon_t^b}$ (long_name='Scaled risk premium shock')
    g           ${\varepsilon^g}$       (long_name='Exogenous spending')
    qs          ${\varepsilon^i}$       (long_name='Investment-specific technology')
    ms          ${\varepsilon^r}$       (long_name='Monetary policy shock process') 
    spinf       ${\varepsilon^p}$       (long_name='Price markup shock process')
    sw          ${\varepsilon^w}$       (long_name='Wage markup shock process')
    kpf         ${k^{flex}}$            (long_name='Capital stock flex price economy') 
    kp          ${k}$           (long_name='Capital stock') 
    muw         ${\mu_w}$            (long_name='wage markup')
    ;    
varexo 
	ea       ${\eta^a}$      (long_name='productivity shock')
    eb          ${\eta^b}$      (long_name='Investment-specific technology shock')
    eg          ${\eta^g}$      (long_name='Spending shock')
    eqs         ${\eta^i}$      (long_name='Investment-specific technology shock')
    em          ${\eta^m}$      (long_name='Monetary policy shock')
    epinf       ${\eta^{p}}$    (long_name='Price markup shock')  
    ew          ${\eta^{w}}$    (long_name='Wage markup shock')  
        ;  
parameters 
	curvw ${\varepsilon_w}$  (long_name='Curvature Kimball aggregator wages')  
    cgy         ${\rho_{ga}}$       (long_name='Feedback technology on exogenous spending')  
    curvp       ${\varepsilon_p}$   (long_name='Curvature Kimball aggregator prices')  
    constelab   ${\bar l}$          (long_name='steady state hours')  
    constepinf  ${\bar \pi}$        (long_name='steady state inflation rate')  
    constebeta  ${100(\beta^{-1}-1)}$ (long_name='time preference rate in percent')  
    cmaw        ${\mu_w}$           (long_name='coefficient on MA term wage markup')  
    cmap        ${\mu_p}$           (long_name='coefficient on MA term price markup')  
    calfa       ${\alpha}$          (long_name='capital share')  
    czcap       ${\psi}$            (long_name='capacity utilization cost')  
    csadjcost   ${\varphi}$         (long_name='investment adjustment cost')  
    ctou        ${\delta}$          (long_name='depreciation rate')  
    csigma      ${\sigma_c}$        (long_name='risk aversion')  
    chabb       ${\lambda}$         (long_name='external habit degree')  
%    ccs         ${d_4}$             (long_name='Unused parameter')  
 %   cinvs       ${d_3}$             (long_name='Unused parameter')  
    cfc         ${\Phi}$          (long_name='fixed cost share')  
    cindw       ${\iota_w}$         (long_name='Indexation to past wages')  
    cprobw      ${\xi_w}$           (long_name='Calvo parameter wages')   
    cindp       ${\iota_p}$         (long_name='Indexation to past prices')  
    cprobp      ${\xi_p}$           (long_name='Calvo parameter prices')   
    csigl       ${\sigma_l}$        (long_name='Frisch elasticity')   
    clandaw     ${\phi_w}$          (long_name='Gross markup wages')   
%    crdpi       ${r_{\Delta \pi}}$  (long_name='Unused parameter')  
    crpi        ${r_{\pi}}$         (long_name='Taylor rule inflation feedback') 
    crdy        ${r_{\Delta y}}$    (long_name='Taylor rule output growth feedback') 
    cry         ${r_{y}}$           (long_name='Taylor rule output level feedback') 
    crr         ${\rho}$            (long_name='interest rate persistence')  
    crhoa       ${\rho_a}$          (long_name='persistence productivity shock')  
    crhoas      ${d_2}$             (long_name='Unused parameter')  
    crhob       ${\rho_b}$          (long_name='persistence risk premium shock')  
    crhog       ${\rho_g}$          (long_name='persistence spending shock')  
    crhols      ${d_1}$             (long_name='Unused parameter')  
    crhoqs      ${\rho_i}$          (long_name='persistence risk premium shock')  
    crhoms      ${\rho_r}$          (long_name='persistence monetary policy shock')  
    crhopinf    ${\rho_p}$          (long_name='persistence price markup shock')  
    crhow       ${\rho_w}$          (long_name='persistence wage markup shock')  
    ctrend      ${\bar \gamma}$     (long_name='net growth rate in percent')  
    cg          ${\frac{\bar g}{\bar y}}$     (long_name='steady state exogenous spending share')  
    ;
% fixed parameters
ctou=.025;
clandaw=1.5;
cg=0.18;
curvp=10;
curvw=10;
% estimated parameters initialisation
calfa=.24;
%cbeta=.9995;
csigma=1.5;
cfc=1.5;
cgy=0.51;
csadjcost= 6.0144;
chabb=    0.6361;    
cprobw=   0.8087;
csigl=    1.9423;
cprobp=   0.6;
cindw=    0.3243;
cindp=    0.47;
czcap=    0.2696;
crpi=     1.488;
crr=      0.8762;
cry=      0.0593;
crdy=     0.2347;
crhoa=    0.9977;
crhob=    0.5799;
crhog=    0.9957;
crhols=   0.9928;
crhoqs=   0.7165;
crhoas=1; 
crhoms=0;
crhopinf=0;
crhow=0;
cmap = 0;
cmaw  = 0;
ccs=0;
cinvs=0;
crdpi=0;	  
% Added by JP to provide full calibration of model before estimation
constelab=0;
constepinf=0.7;
constebeta=0.7420;
ctrend=0.3982;

model(linear); 
%deal with parameter dependencies; taken from SW2007 usmodel_stst.mod 
#cpie=1+constepinf/100;         %gross inflation rate
#cgamma=1+ctrend/100 ;          %gross growth rate
%#cgamma=exp(ctrend/100) ;          %gross growth rate for DS model NB: here we adjust to get gamma_tilde
#cbeta=1/(1+constebeta/100);    %discount factor
#clandap=cfc;                   %fixed cost share/gross price markup
#cbetabar=cbeta*cgamma^(-csigma);   %growth-adjusted discount factor in Euler equation
#cr=cpie/(cbeta*cgamma^(-csigma));  %steady state net real interest rate
#crk=(cbeta^(-1))*(cgamma^csigma) - (1-ctou); %steady state rental rate
#cw = (calfa^calfa*(1-calfa)^(1-calfa)/(clandap*crk^calfa))^(1/(1-calfa));      %steady state real wage
#cikbar=(1-(1-ctou)/cgamma);        %(1-k1) in equation LOM capital, equation (8)
#cik=(1-(1-ctou)/cgamma)*cgamma;    %i_k: investment-capital ratio
#clk=((1-calfa)/calfa)*(crk/cw);    %labour to capital ratio
#cky=cfc*(clk)^(calfa-1);           %k_y: steady state output ratio
#ciy=cik*cky;                       %consumption-investment ratio
#ccy=1-cg-cik*cky;                  %consumption-output ratio
#crkky=crk*cky;                     
#cwhlc=(1/clandaw)*(1-calfa)/calfa*crk*cky/ccy; 
#cwly=1-crk*cky;                    %unused parameter
#conster=(cr-1)*100;                %steady state federal funds rate 
% coefficients for AERtype equations
#c1 = (chabb/cgamma)/(1+chabb/cgamma);
#c2 = (csigma-1)*cwhlc/(csigma*(1+chabb/cgamma));
#c3 = (1-chabb/cgamma)/(csigma*(1+chabb/cgamma));
#i1 = (1/(1+cbetabar*cgamma));
#i2 = (1/(1+cbetabar*cgamma))*(1/(cgamma^2*csadjcost));
#q1 = ((1-ctou)/(crk+(1-ctou)));
#q2 = (1/((1-chabb/cgamma)/(csigma*(1+chabb/cgamma))));  
#k1 = (1-cikbar);
#k2 = cikbar*cgamma^2*csadjcost;
#pi1 = (1/(1+cbetabar*cgamma*cindp))*cindp;
#pi2 = (1/(1+cbetabar*cgamma*cindp))*cbetabar*cgamma;
#pi3 = (1/(1+cbetabar*cgamma*cindp))*((1-cprobp)*(1-cbetabar*cgamma*cprobp)/cprobp)/((cfc-1)*curvp+1); 
#w1 = (1/(1+cbetabar*cgamma));
#w2 = (1+cbetabar*cgamma*cindw)/(1+cbetabar*cgamma);
#w3 = (cindw/(1+cbetabar*cgamma));
#w4 = (1-cprobw)*(1-cbetabar*cgamma*cprobw)/((1+cbetabar*cgamma)*cprobw)*(1/((clandaw-1)*curvw+1));
#w5 = (1/(1-chabb/cgamma));
#w6 = (chabb/cgamma)/(1-chabb/cgamma);
% flexible economy
          [name='FOC labour with mpl expressed as function of rk and w, flex price economy']
	      0*(1-calfa)*a + 1*a =  calfa*rkf+(1-calfa)*(wf)  ;
	      [name='FOC capacity utilization, flex price economy']
	      zcapf =  (1/(czcap/(1-czcap)))* rkf  ;
          [name='Firm FOC capital, flex price economy']
	      rkf =  (wf)+labf-kf ;
          [name='Definition capital services, flex price economy']
	      kf =  kpf(-1)+zcapf ;
          [name='Investment Euler Equation, flex price economy']
		  invef = i1*invef(-1) + (1 - i1)*invef(+1) + i2*pkf + qs; 
          [name='Arbitrage equation value of capital, flex price economy']
		  pkf = q1*pkf(+1) + (1 - q1)*rkf(+1) + q2*b - (rrf + 0*b);
	      [name='Consumption Euler Equation, flex price economy']
		  cf = c1*cf(-1) + (1 - c1)*cf(+1) + c2*(labf -labf(+1)) - c3*(rrf+0*b) + 1*b;
	      [name='Aggregate Resource Constraint, flex price economy']
	      yf = ccy*cf+ciy*invef+g  +  crkky*zcapf ;
	      [name='Aggregate Production Function, flex price economy']
          yf = cfc*( calfa*kf+(1-calfa)*labf +a );
          [name='Wage equation, flex price economy']
	      wf = csigl*labf + w5*cf - w6*cf(-1) ;
          [name='Law of motion for capital, flex price economy (see header notes)']              
		  kpf = k1*kpf(-1) + (1 - k1)*invef + k2*qs;
% sticky price - wage economy
          [name='FOC labour with mpl expressed as function of rk and w, SW Equation (9)']
	      mc =  calfa*rk+(1-calfa)*(w) - 1*a - 0*(1-calfa)*a ;
	      [name='FOC capacity utilization, SW Equation (7)']
          zcap =  (1/(czcap/(1-czcap)))* rk ;
          [name='Firm FOC capital, SW Equation (11)']
	      rk =  w+lab-k ;
          [name='Definition capital services, SW Equation (6)']
	      k =  kp(-1)+zcap ;
          [name='Law of motion for capital, SW Equation (8) ']
		  kp = k1*kp(-1) + (1 - k1)*inve + k2*qs;  
          [name='Investment Euler Equation, SW Equation (3)']
		  inve = i1*inve(-1) + (1 - i1)*inve(+1) + i2*pk + qs; 
          [name='Arbitrage equation value of capital, SW Equation (4)']
		  pk = q1*pk(+1) + (1 - q1)*rk(+1) + q2*b - (r - pinf(+1) + 0*b); 
	      [name='Consumption Euler Equation, SW Equation (2)']
		  c = c1*c(-1) + (1 - c1)*c(+1) + c2*(lab -lab(+1)) - c3*(r - pinf(+1) + 0*b) + b;  
	      [name='Aggregate Resource Constraint, SW Equation (1)']
          y = ccy*c+ciy*inve+g  +  1*crkky*zcap ;
          [name='Aggregate Production Function, SW Equation (5)']
	      y = cfc*( calfa*k+(1-calfa)*lab +a );
          [name='New Keynesian Phillips Curve, SW Equation (10)']
		  pinf = pi1*pinf(-1) + pi2*pinf(+1) + pi3*mc + spinf;   
	      [name='Wage Phillips Curve, SW Equation (13), with (12) for mu_w']
		  w = w1*w(-1) + (1 - w1)*(w(+1) + pinf(+1)) - w2*pinf + w3*pinf(-1) - w4*muw + sw;    
		  muw = w - (csigl*lab + (1/(1-chabb/cgamma))*(c - (chabb/cgamma)*c(-1)));
          [name='Taylor rule, SW Equation (14)']
	      r =  crpi*(1-crr)*pinf +cry*(1-crr)*(y-yf) +crdy*(y-yf-y(-1)+yf(-1)) +crr*r(-1) +ms  ;
          [name='Law of motion for productivity']              
	      a = crhoa*a(-1)  + ea;
          [name='Law of motion for risk premium']              
	      b = crhob*b(-1) + eb;
          [name='Law of motion for spending process']              
	      g = crhog*(g(-1)) + eg + cgy*ea;
	      [name='Law of motion for investment specific technology shock process']              
          qs = crhoqs*qs(-1) + eqs;
          [name='Law of motion for monetary policy shock process']              
	      ms = crhoms*ms(-1) + em;
          [name='Law of motion for price markup shock process']              
	      spinf = crhopinf*spinf(-1) + epinfma - cmap*epinfma(-1);
	          epinfma=epinf;
          [name='Law of motion for wage markup shock process']              
	      sw = crhow*sw(-1) + ewma - cmaw*ewma(-1) ;
	          ewma=ew; 
% measurement equations
[name='Observation equation output']              
dy=y-y(-1)+ctrend;
[name='Observation equation consumption']              
dc=c-c(-1)+ctrend;
[name='Observation equation investment']              
dinve=inve-inve(-1)+ctrend;
[name='Observation equation real wage']              
dw=w-w(-1)+ctrend;
[name='Observation equation inflation']              
pinfobs = 1*(pinf) + constepinf;
[name='Observation equation interest rate']              
robs =    1*(r) + conster;
[name='Observation equation hours worked']              
labobs = lab + constelab;
end;

resid;
steady;
check;

shocks;
var ea; stderr 0.4618;
var eb;  stderr 0.18513;
var eg; stderr 0.6090;
var eqs;  stderr 0.6017;
var em; stderr 0.2397;
var epinf; stderr 0.1455;
var ew; stderr 0.2089;
end;

estimated_params;
% PARAM NAME, INITVAL, LB, UB, PRIOR_SHAPE, PRIOR_P1, PRIOR_P2, PRIOR_P3, PRIOR_P4, JSCALE
% Structural
calfa,0.24,0.01,1.0,NORMAL_PDF,0.3,0.05; % alpha
czcap,0.2648,0.01,1,BETA_PDF,0.5,0.15; % psi
cfc,1.4672,1.0,3,NORMAL_PDF,1.25,0.125; % phi_p
cindw,0.4425,0.01,0.99,BETA_PDF,0.5,0.15; % iota_w
cprobw,0.7937,0.3,0.95,BETA_PDF,0.5,0.1; % xi_w
cindp,0.3291,0.01,0.99,BETA_PDF,0.5,0.15; % iota_p
cprobp,0.7813,0.5,0.95,BETA_PDF,0.5,0.10; % xi_p
csigma,1.2312,0.25,3,NORMAL_PDF,1.50,0.375; % sigma_c
csigl,2.8401,0.25,10,NORMAL_PDF,2,0.75; % sigma_l
chabb,0.7205,0.001,0.99,BETA_PDF,0.7,0.1; % lambda
csadjcost,6.3325,2,15,NORMAL_PDF,4,1.5; % phi
cmaw,.8936,0.01,.9999,BETA_PDF,0.5,0.2; % mu_w
cmap,.7652,0.01,.9999,BETA_PDF,0.5,0.2; % mu_p
% Trends
ctrend,0.3982,0.1,0.8,NORMAL_PDF,0.4,0.10; % gamma_bar
constebeta,0.7420,0.01,2.0,GAMMA_PDF,0.25,0.1;%0.20; % beta_const
constepinf,0.7,0.1,2.0,GAMMA_PDF,0.625,0.1;%20; % pi_bar
constelab,1.2918,-10.0,10.0,NORMAL_PDF,0.0,2.0; % l_bar
% MonPol
crpi,1.7985,1.0,3,NORMAL_PDF,1.5,0.25; % r_pi
crdy,0.2239,0.001,0.5,NORMAL_PDF,0.125,0.05; % r_dy
cry,0.0893,0.001,0.5,NORMAL_PDF,0.125,0.05; % r_y
crr,0.8258,0.5,0.975,BETA_PDF,0.75,0.10; % rho
% Persistence
crhoa,.9676 ,.01,.9999,BETA_PDF,0.5,0.20; % rho_a
cgy,0.05,0.01,2.0,NORMAL_PDF,0.5,0.25; % rho_ga
crhob,.2703,.01,.9999,BETA_PDF,0.5,0.20; % rho_b
crhog,.9930,.01,.9999,BETA_PDF,0.5,0.20; % rho_g
crhoqs,.5724,.01,.9999,BETA_PDF,0.5,0.20; % rho_i
crhoms,.3,.01,.9999,BETA_PDF,0.5,0.20; %rho_r
crhopinf,.8692,.01,.9999,BETA_PDF,0.5,0.20; % rho_p
crhow,.9546,.001,.9999,BETA_PDF,0.5,0.20; %rho_w
% Variance
stderr ea,0.4618,0.01,3,INV_GAMMA_PDF,0.1,2; % eta_a
stderr eb,0.1818513,0.025,5,INV_GAMMA_PDF,0.1,2; % eta_b
stderr eg,0.6090,0.01,3,INV_GAMMA_PDF,0.1,2; % eta_g
stderr eqs,0.46017,0.01,3,INV_GAMMA_PDF,0.1,2; % eta_i
stderr em,0.2397,0.01,3,INV_GAMMA_PDF,0.1,2; % eta_r
stderr epinf,0.1455,0.01,3,INV_GAMMA_PDF,0.1,2; % eta_p
stderr ew,0.2089,0.01,3,INV_GAMMA_PDF,0.1,2; % eta_w
end;

varobs dy dc dinve labobs pinfobs dw robs;
estimation(optim=('MaxIter',200),datafile='SW_Data4HW_Wei.xlsx',xls_sheet='Obs',mode_compute=1,first_obs=49,nobs=100, presample=4,lik_init=2,prefilter=0,mh_replic=0,mh_nblocks=2,mh_jscale=0.20,mh_drop=0.2,Tex) y c inve pinf r w k lab;
stoch_simul(Tex,irf = 40) y c inve pinf r w k lab;
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