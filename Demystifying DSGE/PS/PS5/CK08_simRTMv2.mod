% From Christoffel and Kuester (2008) "Resuscitating the wage channel in models with unemployment fluctuations", JME 55, p. 865� 887
% Note: the original model runs on a MONTHLY frequency 
% Last edited: 2011/05/10 by K. Kuester
% This is the "RTM" version of the model
% In this version the value of gamma is 0.8 ==> contract duration = 5 months

var      
	y      ${y}$       (long_name='output')
	c      ${c}$       (long_name='consumption')
	Pi 		${\pi}$       (long_name='inflation rate')
	R 		${R}$       (long_name='interest rate')
	lambda      ${\lambda}$       (long_name='marginal utility')
	w      ${w}$       (long_name='aggregate wage rate')
	wstar      ${w^*}$       (long_name='newly optimized wage rate')
	Jstar      ${J^*}$       (long_name='market value of labour firm')
	deltaW      ${\delta_W}$       (long_name='family surplus from employed worker')
	deltaF      ${\delta_F}$       (long_name='firm surplus from employed worker')
	Deltastar      ${\Delta^*}$       (long_name='optimised wage wedge')
	h      ${h}$       (long_name='hours worked - based on measure 1')
	mc      ${mc}$       (long_name='marginal cost')
	m      ${m}$       (long_name='matches')
	n      ${n}$       (long_name='employment - based on measure 1')
	u      ${u}$       (long_name='unemployment - based on measure 1')
	v      ${v}$       (long_name='vacancies - based on measure 1')
	s      ${s}$       (long_name='job-finding probability')
	q      ${q}$       (long_name='vacancy-filling probability')
	xL      ${xL}$       (long_name='real competitive price for labour good')
	Piw 		${\pi_w}$       (long_name='wage inflation rate')
	PsiL      ${\Psi^L}$       (long_name='labour profits')
	// shocks
	z      ${z}$       (long_name='TFP shock process')	
	g      ${g}$       (long_name='govt spending shock process')
	eb      ${e_b}$       (long_name='preference shock process')
	emoney      ${e_m}$       (long_name='MonPol shock process') 
	;
varexo  
	inno_eb     ${\varepsilon_{b}}$       (long_name='preference shock')
	inno_z     ${\varepsilon_{z}}$       (long_name='TFP shock')
	interest_     ${\varepsilon_{r}}$       (long_name='MonPol shock')
	g_     ${\varepsilon_{g}}$       (long_name='govt spending shock')
;
parameters 
    bet      ${\beta}$       (long_name='lifetime discount factor')
	epsilon      ${\epsilon}$       (long_name='own price elasticity of demand for differentiated good')
	habit      ${\varrho}$       (long_name='habit persistence')
	sig      ${\sigma}$       (long_name='CRRA')
	vphi      ${\varphi}$       (long_name='inverse of Frisch elasticity')
	omega    	  ${\omega}$     (long_name='Calvo price stickiness')
	price_index    	  ${\zeta_p}$     (long_name='degree of price indexation')	
	xi      ${\xi}$       (long_name='weight on unemployment in matching function')
	eta      ${\eta}$       (long_name='worker weight in Nash bargain')
	gamma    	  ${\gamma}$     (long_name='Calvo wage stickiness')
	wage_index    	  ${\zeta_w}$     (long_name='degree of wage indexation')
	vtheta    	  ${\vartheta}$     (long_name='separation rate (quarterly)')
	alp      ${\alpha}$       (long_name='labour elasticity of production')
	gamma_R    	  ${\gamma_R}$     (long_name='interest rate smoothing')
	gamma_Pi    	  ${\gamma_{\pi}}$     (long_name='Taylor Rule weight on inflation')
	gamma_y    	  ${\gamma_y}$     (long_name='Taylor Rule weight on output')
	rho_z    	  ${\rho_{z}}$     (long_name='persistence of TFP shock process')
	rho_eb    	  ${\rho_{eb}}$     (long_name='persistence of preference shock process')
	rho_g    	  ${\rho_{g}}$     (long_name='persistence of govt spending shock process')
	rho_emoney    	  ${\rho_{m}}$     (long_name='persistence of MonPol shock process')
	sig_innoz    	  ${\sigma_{z}}$     (long_name='std dev of TFP shock process')
	sig_innoeb    	  ${\sigma_{eb}}$     (long_name='std dev of preference shock process')
	sig_innog    	  ${\sigma_{g}}$     (long_name='std dev of govt spending shock process')
	sig_monpol    	  ${\sigma_{m}}$     (long_name='std dev of MonPol shock process')
	ybar       ${y_{ss}}$        (long_name='output steady-state')
	hbar       ${h_{ss}}$        (long_name='hours worked steady-state')
	ubar       ${u_{ss}}$        (long_name='unemployment steady-state')
	qbar       ${q_{ss}}$        (long_name='job-finding probability steady-state')
	gbar       ${g_{ss}}$        (long_name='govt-output ratio steady-state')
	Pibar       ${\pi_{ss}}$        (long_name='inflation rate steady-state')
	b_wh       ${b_{ss}}$        (long_name='replacement rate steady-state')
	Phi_y       ${\phi_{ss}}$        (long_name='fixed-cost loss-output ratio steady-state')		   
;

// ***** parameter values
bet     = 0.998; // time-discount factor
epsilon = 11;                // own price elasticity of demand for differentiated good
habit   = 0.7;               // habit persistence
sig     = 1.5;               // CRRA
vphi    = 2;                 // inverse of Frisch elasticity
omega       = 0.8;  // Calvo price stickiness
price_index = 0;    // degree of price indexation
xi          = 0.5;  // weight on unemployment in matching function
eta         = 0.5;  // bargaining power of workers
gamma       = 0.5;  // Calvo wage stickiness  ===> contract duration = 5 months
wage_index  = 0;    // wage indexation
vtheta      = 0.03; // rate of separation
alp         = 0.99; // labour elasticity of production
gamma_R     = 0.85^(1/3);	 // interest rate smoothing
gamma_Pi    = 1.5;   // weight on inflation 
gamma_y     = 0.5;   // weight on output
rho_eb      = 0.95;   // persistence of preference shock
rho_emoney  = 0;     // persistence of mon pol shock
rho_g       = 0.89; // persistence of govt spending shock
rho_z       = 0.82; // persistence of productivity shock 
sig_innoeb =   0.102;   // std dev of preference shock
sig_monpol =   0.043;    // std dev of monpol shock
sig_innog  =   0.674;    // std dev of govt spending shockata]
sig_innoz  =   0.571;    // std dev of productivity shock

// ********* calibration targets 
ybar    = 1;                    // steady state output
hbar    = 0.9562;                  // steady state hours worked
Phi_y   = 0.00863;              // fraction of output lost due to fixed costs.
ubar    = 0.0588;                  // steady state unemployment rate  
qbar    = 0.3306;                  // probability of finding a worker in a given month
gbar    = 0.347026648444032;    // share of government spending in GDP (y=c+g)
b_wh    = 0.4;                  // unemployment insurance replacement rate
Pibar   = 1;                    // zero inflation steady state

model_local_variable	
	nbar      ${n_{ss}}$
	mbar      ${m_{ss}}$
	vbar      ${v_{ss}}$
	sbar      ${s_{ss}}$
	sigmam      ${\sigma_{m}}$
	thetabar    	  ${\theta_{ss}}$
	mcbar      ${mc_{ss}}$
	xLbar      ${xL_{ss}}$
	Rbar      ${R_{ss}}$
	zbar      ${n_{ss}}$
	wbar      ${w_{ss}}$
	Phi      ${\Phi}$
	PsiLbar      ${\Psi^L_{ss}}$
	PsiCbar      ${\Psi^C_{ss}}$
	Jbar      ${J_{ss}}$
	deltaFbar      ${\delta^F_{ss}}$
	deltaWbar      ${\delta^W_{ss}}$
	Deltabar      ${\Delta_{ss}}$
	mrsbar      ${mrs_{ss}}$
	kappa      ${\kappa}$
	kappaL      ${\kappa_L}$
	cbar      ${c_{ss}}$
	lambdabar      ${\lambda_{ss}}$
	Afactor      ${A_{fac}}$
	end;

model;
// ********* Steady-State values for the given targets - moved inside for estimation
#nbar        = 1-ubar;   
#mbar        = vtheta*nbar; 
#vbar        = mbar/qbar;
#sbar        = mbar/ubar;
#sigmam      = mbar*(ubar^xi*vbar^(1-xi))^(-1);  
#thetabar    = vbar/ubar;
#mcbar       = (epsilon-1)/epsilon;  
#xLbar       = mcbar;  
#Rbar        = 1/bet;  
#zbar        = ybar/(nbar*hbar^(alp)); 
#wbar        = xLbar*zbar*alp*hbar^(alp-1);  
#Phi         = Phi_y*ybar/nbar;
#PsiLbar     = xLbar*zbar*hbar^(alp) - wbar*hbar - Phi; 
#PsiCbar     = (1-mcbar)*ybar;  
#Jbar		= 1/(1-bet*(1-vtheta))*PsiLbar;         
#deltaFbar   = 1/(1-bet*(1-vtheta)*gamma)*wbar*hbar;  
#b           = b_wh*wbar*hbar;  
#mrsbar      = (Jbar*eta/(1-bet*(1-vtheta)*gamma)*alp/(alp-1)*hbar*wbar - (1-eta)*deltaFbar/(1-bet*(1-vtheta-sbar))*(wbar*hbar-b))/ (Jbar*hbar*eta/(1-bet*(1-vtheta)*gamma)*(-1)/(1-alp) - (1-eta)*deltaFbar*hbar/(1-bet*(1-vtheta-sbar))*1/(1+vphi)  );
#deltaWbar   = 1/(1-bet*(1-vtheta)*gamma)*hbar*1/(1-alp)*(-alp*wbar - (-1)*mrsbar);  
#Deltabar    = 1/(1-bet*(1-vtheta-sbar))*(wbar*hbar - mrsbar*hbar/(1+vphi) - b);  
#kappa       = qbar*bet*Jbar; 
#cbar        = ybar - kappa*vbar - Phi*nbar-gbar;  
#lambdabar   = (cbar*(1-habit))^(-sig);  
#kappaL      = mrsbar*lambdabar/hbar^vphi;  
// - factor of proportionality between period profits and wages
#Afactor =  (1-alp)/alp*wbar*hbar/(PsiLbar);      
R         =     ((1-gamma_R)*gamma_Pi)*Pi(-1) + (1-gamma_R)*gamma_y*y + gamma_R*R(-1) + emoney;   // Monetary policy rule  
// consumption Euler equation
lambda    =    lambda(+1)  + R + eb - Pi(+1);   // Monetary policy rule          
lambda    =     - sig/(1-habit)*( c - habit*c(-1)  );   // marginal utility of consumption 
Pi        =      price_index/(1+bet*price_index)*Pi(-1) 
                + bet/(1+bet*price_index)*Pi(+1)
                + 1/(1+bet*price_index)*(1-omega)*(1-omega*bet)/omega*(mc); // New Keynesian Phillips curve (with inflation indexation)
mc        =     xL;  // marginal cost                          
m         =     xi*u   + (1-xi)*v; // new matches
n         =     (1-vtheta)*n(-1) + mbar/nbar*m(-1);    // employment
n         =   - ubar/(1-ubar)*u;    // unemployment                        
q         =     m-v;   // job-filling rate                         
s         =     m-u; // job-finding rate
Jstar + deltaW = Deltastar + deltaF;   // newly optimized wage (wage setting FOC)    
w         =     xL + z + (alp-1)*h ; // hours FOC
w         = 	 gamma*( w(-1) - Pi + wage_index*Pi(-1) ) + (1-gamma)*wstar;    // evolution of aggregate wage          
deltaF    = 	    (1-bet*(1-vtheta)*gamma)*( -alp/(1-alp)*wstar + 1/(1-alp)*(xL + z) )
        										+ bet*(1-vtheta)*gamma*(   -alp/(1-alp)*(wstar + wage_index*Pi - wstar(+1) - Pi(+1) )
                                                                           + deltaF(+1) + lambda(+1) - lambda  );      // deltaF (-\partial surplus of firm/\partial wage)                
deltaWbar*deltaW	=         -alp/(1-alp)*wbar*hbar*( -alp/(1-alp)*wstar + 1/(1-alp)*(xL+z) )
        						+ 1/(1-alp)*mrsbar*hbar*( (-1)*(1+vphi)/(1-alp)*wstar - lambda + (1+vphi)/(1-alp)*(xL+z) )
                                + bet*(1-vtheta)*gamma/(1-bet*(1-vtheta)*gamma)*( (alp/(1-alp))^2*wbar*hbar - (1+vphi)/(1-alp)^2*mrsbar*hbar )
                                     *( wstar + wage_index*Pi - wstar(+1) - Pi(+1) )
                                + bet*(1-vtheta)*gamma*deltaWbar*( lambda(+1) - lambda + deltaW(+1)  );     // deltaW ( \partial surplus of worker/\partial wage)                                          
Jbar*Jstar =     wbar*hbar/alp*( -alp*wstar + xL + z )
                + bet*(1-vtheta)*gamma/(1-bet*(1-vtheta)*gamma)*wbar*hbar*( wstar(+1) + Pi(+1) - wstar - wage_index*Pi  )
        		+ bet*(1-vtheta)*Jbar*( lambda(+1)- lambda + Jstar(+1) );	  // value of firm that resets wage                                                                              												
Deltabar*Deltastar =   wbar*hbar*1/(1-alp)*( - alp*wstar + xL + z )
        			  - mrsbar*hbar/(1+vphi)*( (1+vphi)/(1-alp)*( (-1)*wstar+xL+z) - lambda )
        			  + bet*(1-vtheta)*gamma/(1-bet*(1-vtheta)*gamma)*(wbar*hbar*alp/(1-alp)-1/(1-alp)*mrsbar*hbar)*( wstar(+1) + Pi(+1) - wstar - wage_index*Pi )
        			  - bet*gamma*sbar/(1-bet*(1-vtheta)*gamma)*(wbar*hbar*alp/(1-alp)-1/(1-alp)*mrsbar*hbar)*( wstar(+1) + Pi(+1) - w - wage_index*Pi )
    	              + bet*(1-vtheta-sbar)*Deltabar*(  lambda(+1) - lambda + Deltastar(+1)  )
                      - bet*Deltabar*sbar*s;    // surplus of worker who resets wage                                                     
kappa/qbar*( -q )
            =     bet*gamma/(1-bet*(1-vtheta)*gamma)*wbar*hbar*( wstar(+1) - w - wage_index*Pi + Pi(+1) )
                + bet*Jbar*( lambda(+1) - lambda  + Jstar(+1) );    // vacancy posting condition                                                                                                      
ybar*y    =     cbar*c + gbar*g + vbar*kappa*v + Phi*nbar*n;     // resource constraint  
y         =     n + z  + alp*h;  // production function
Piw = Pi + w - w(-1);  // wage inflation
PsiL  = Afactor*(w + h); // labour profits
// ****************** shocks ************************
eb        =     rho_eb*eb(-1) +  sig_innoeb*inno_eb;   // shock to discount factor (preference shock)          
g         =     rho_g*g(-1) +  g_ ;     // government spending shock              
emoney    =     rho_emoney*emoney(-1) + sig_monpol*interest_;     // monetary policy shock  
z         =     rho_z*z(-1) +  sig_innoz*inno_z;  // productivity shock
end;

shocks;
var inno_eb  = sig_innoeb^2;
var inno_z   = sig_innoz^2;
%var interest_ = sig_monpol^2;
var interest_ = 0.1^2; % 1% monpol shock to reproduce Fig.1
var g_   = sig_innog^2;
end;

resid;
steady;
check;

stoch_simul (Tex,irf = 60,relative_irf) y Pi R u v PsiL h w Piw; // 5 years = 60 months

%----------------------------------------------------------------
% generate LaTeX output
%----------------------------------------------------------------
%write_latex_dynamic_model;
write_latex_original_model;
write_latex_parameter_table;
write_latex_definitions;
write_latex_prior_table;
collect_latex_files;
%if system(['pdflatex -halt-on-error -interaction=batchmode ' M_.fname '_TeX_binder.tex'])
%    error('TeX-File did not compile.')
%end
%disp(' ');
%disp('STARTING DYNGRAPH');
%dyngraph;

% CK08-simRTM model
