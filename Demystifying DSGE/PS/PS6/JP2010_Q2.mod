% Based on E:\MyCourseDSGEs2025\Justiniano and Preston 2010a JAE Monetary Policy and Uncertainty in an Empirical SOE.pdf
% For Australia, alpha is calibrated at 0.185 - see note to Table 1						  

%*************************************************************************
% PREAMBLE 
%*************************************************************************
% ENDOGENOUS VARIABLE DECLARATIONS
var
% Domestic variables 
	y 		${y}$       (long_name='Domestic output')
	c 		${c}$       (long_name='Domestic consumption')
	s 		${s}$       (long_name='Terms of Trade')
	psi 	${\Psi}$    (long_name='LOOP gap')
	q 		${q}$       (long_name='Real ER')
	mc 		${mc}$      (long_name='Domestic marginal cost')
	i 		${i}$       (long_name='Domestic interest rate')
	pi 		${\pi}$     (long_name='Overall inflation rate')
	pi_h 	${\pi_H}$   (long_name='Domestic inflation')
	pi_f 	${\pi_F}$   (long_name='Imported inflation')
	nfa 		${nfa}$      (long_name='Net foreign assets')
	eps_a 		${\epsilon_a}$       (long_name='TFP shock process')
    eps_g 		${\epsilon_g}$       (long_name='Domestic preferences shock process')
	eps_cp		${\epsilon_{cp}}$     (long_name='Cost-push shock process')
	eps_gs 		${\epsilon_{gs}}$      (long_name='Foreign preferences shock process')
	eps_rp		${\epsilon_{rp}}$     (long_name='Risk premium shock process')
	e		${e}$       (long_name='Nominal ER')
%Foreign variables
	y_star 		${y^*}$      (long_name='Foreign output')
	mc_star 	${mc^*}$     (long_name='Foreign marginal cost')
	i_star		${i^*}$      (long_name='Foreign interest rate') 
	pi_star 	${\pi^*}$    (long_name='Foreign inflation')
	eps_astar 		${\epsilon_{a*}}$       (long_name='Foreign TFP shock process')
% Observables
	% y_au pi_au i_au y_us pi_us i_us
;

% SHOCK VARIABLE DECLARATIONS   
varexo 
    epsilon_a	${\varepsilon_a}$   	(long_name='domestic productivity shock')
    epsilon_i   ${\varepsilon_i}$   	(long_name='domestic interest rate shock')
	epsilon_cp   ${\varepsilon_{cp}}$   	(long_name='cost-push shock')
    epsilon_rp   ${\varepsilon_s}$   	(long_name='risk premium shock')
    epsilon_g	${\varepsilon_g}$   	(long_name='domestic preferences shock')
    epsilon_gs  ${\varepsilon_{gs}}$  	(long_name='foreign preferences shock')
    epsilon_astar ${\varepsilon_{a*}}$  (long_name='foreign productivity shock')
    epsilon_istar ${\varepsilon_{i*}}$  (long_name='foreign interest rate shock')
;

% PARAMETER DECLARATIONS 
parameters 
% Domestic parameters
    beta      ${\beta}$       (long_name='lifetime discount factor')
	alpha     ${\alpha}$      (long_name='share of foreign goods in consumption') 
    sigma     ${\sigma}$      (long_name='inverse elast intertemp substn')
    phi    	  ${\varphi}$     (long_name='inverse elast intertemp labour supply')   
    theta_h   ${\theta_{H}}$  (long_name='domestic producer Calvo parameter')
    theta_f   ${\theta_{F}}$  (long_name='importer Calvo parameter')
	eta       ${\eta}$        (long_name='elast substn betw dom and import goods')
	h         ${\hbar}$      	  (long_name='degree of habit persistence')
	delta_h   ${\delta_{H}}$  (long_name='indexation to domestic inflation')
	delta_f   ${\delta_{F}}$  (long_name='indexation to import inflation')    
% Domestic monetary policy parameters
    rho_i     ${\rho_{i}}$    (long_name='interest rate persistence')
    psi_pi    ${\psi_{\pi}}$  (long_name='inflation response')
    psi_y     ${\psi_{y}}$    (long_name='output response')
    psi_e     ${\psi_{\Delta {e}}}$    (long_name='nominal ER response')
	psi_dy	  ${\psi_{\Delta {y}}}$    (long_name='output change response')
	psi_istar ${\psi_{i^*}}$  (long_name='US interest rate response')
% Other domestic parameters
	chi    	  ${\chi}$     (long_name='NFA factor')
	rho_g     ${\rho_{g}}$    (long_name='domestic preferences persistence')
    rho_a     ${\rho_{a}}$    (long_name='technology persistence')
	rho_cp     ${\rho_{cp}}$    (long_name='cost-push persistence')
	rho_rp     ${\rho_{rp}}$    (long_name='risk premium persistence')
% All foreign parameters
    theta_star    ${\theta^*}$   (long_name='foreign Calvo parameter')
    rho_a_star  ${\rho_{a*}}$    (long_name='foreign technology persistence')
    rho_i_star  ${\rho_{i*}}$    (long_name='foreign interest rate persistence')
    psi_pi_star ${\psi_{\pi^*}}$ (long_name='foreign inflation response')
    psi_y_star  ${\psi_{y*}}$    (long_name='foreign output response')
	rho_gs      ${\rho_{gs}}$    (long_name='foreign preferences persistence')
;
    
% INITIAL PARAMETER CALIBRATION
% "Deep" parameters
beta = 0.99; % Calibrated
alpha = 0.185; % Calibrated
eta = 0.6; 
theta_h = 0.7;
theta_f = 0.7;
phi = 2;
sigma = 0.5;
h = 0.8;
delta_h = 0.1;
delta_f = 0.1;
chi = .35;

% MonPol		
rho_i = 0.5;
psi_pi = 1.5; % original Taylor estimate
theta_star = 0.7;
rho_i_star = 0.5;
psi_pi_star = 1.5; % original Taylor estimate
psi_y = 0.5; % original Taylor estimate 			
psi_y_star = 0.25; % original Taylor estimate
psi_dy = 0.10;
psi_istar = 0.1;
psi_e = 0.2;

% Persistence			 
rho_g = 0.5;
rho_a = 0.5;
rho_cp = 0.5 ;
rho_rp = 0.5 ;
rho_gs = 0.5 ;
rho_a_star = 0.5; % original Taylor estimate 
psi_e = 0.2;

model_local_variable 
lambda_h ${\lambda_{h}}$
lambda_f ${\lambda_{f}}$
lambda_star ${\lambda_{*}}$
;

%*************************************************************************
% MODEL 
%*************************************************************************
model(linear);
    # lambda_h = ((1-beta*theta_h)*(1-theta_h))/theta_h;
    # lambda_f = ((1-beta*theta_f)*(1-theta_f))/theta_f;
    # lambda_star = ((1-beta*theta_star)*(1-theta_star))/theta_star;
    % Home Euler Equation  // eq. 14
        c - h*c(-1) = c(+1) - h*c - (1/sigma)*(1-h)*( i - pi(+1) )
                  + (1/sigma)*(1-h)*( eps_g - eps_g(+1) );
    % Goods market clearing // eq. 15
        (1 - alpha)*c = y - alpha*eta*(2 - alpha)*s - alpha*eta*psi - alpha*y_star;
    % Terms of trade // eq. 16 	
        s - s(-1) = pi_f - pi_h;
	% Nominal exchange rate // eq. 17 (LHS)   
        e - e(-1) = q - q(-1) + pi - pi_star;
    % Real exchange rate and LOOP gap // eq. 17 (RHS)
        q = psi + (1-alpha)*s;
	% Domestic inflation // eq.18 
        pi_h - delta_h*pi_h(-1) = lambda_h*mc + beta*(pi_h(+1) - delta_h*pi_h);
    % Domestic marginal cost // definition below eq. 18
        mc = phi*y - (1+phi)*eps_a + alpha*s + (sigma/(1-h))*(c-h*c(-1)); 
	% Imported inflation // eq. 19
        pi_f - delta_f*pi_f(-1) = lambda_f*psi + beta*(pi_f(+1) - delta_f*pi_f) + eps_cp; 
	% CPI inflation // eq. 20 
        pi = pi_h + alpha*(s - s(-1));
    % Uncovered interest parity // eq. 21 
       (i - pi(+1)) - (i_star - pi_star(+1)) = q(+1) - q - chi*nfa - eps_rp;	
    % Flow budget constraint // eq. 22
        c + nfa = (1/beta)*nfa(-1) - alpha*(s + psi) + y;	
    % Monetary policy rule // eq. 23 
		i = rho_i*i(-1) + psi_pi*pi + psi_y*y + psi_dy*(y - y(-1)) + psi_e*(e-e(-1)) + epsilon_i;  
% Foreign sector as in Monacelli 2005		
    % Foreign Euler equation 
        y_star - h*y_star(-1) = y_star(+1) - h*y_star - (1/sigma)*(1-h)*(i_star - pi_star(+1)) + eps_gs - eps_gs(+1);
    % Foreign inflation 
        pi_star = lambda_star*mc_star + beta*pi_star(+1);
    % Foreign marginal cost 
        mc_star = phi*y_star + alpha*s - (1+phi)*eps_astar + (sigma/(1-h))*(y_star-h*y_star(-1));
    % Foreign monetary policy rule 
		i_star = rho_i_star*i_star(-1) + psi_pi_star*pi_star + psi_y_star*y_star + epsilon_istar;
% Exogenous Processes
%	 Domestic shock in preferences (demand shock)
		eps_g = rho_g * eps_g(-1) + epsilon_g ;
% 	 Foreign shock in preferences
		eps_gs = rho_gs * eps_gs(-1) + epsilon_gs ;
% 	 Domestic technological shock (supply shock)
        eps_a = rho_a*eps_a(-1) + epsilon_a;
% 	 Cost-push shock
        eps_cp = rho_a*eps_cp(-1) + epsilon_cp;
%    Foreign technology process
        eps_astar = rho_a_star*eps_astar(-1) + epsilon_astar;
% 	 Exchange rate shock 
		eps_rp = rho_rp * eps_rp(-1) + epsilon_rp ;		
% Measurement equations
% ...
end;

%*************************************************************************
% CHECK BLANCHARD-KAHN CONDITIONS
%*************************************************************************
resid;
check;
steady;

%*************************************************************************
% SHOCKS 
%*************************************************************************
shocks;
     var epsilon_a; stderr 1;  
     var epsilon_i; stderr 1; 
	 var epsilon_cp; stderr 1;	 
     var epsilon_rp; stderr 1;
     var epsilon_g; stderr 1; 
     var epsilon_gs; stderr 1; 
     var epsilon_astar; stderr 1; 
     var epsilon_istar; stderr 1; 	
end;

% SIMULATION  
%*************************************************************************
stoch_simul(irf=24) y c i pi pi_h pi_f e nfa mc; 

%*************************************************************************
/*
%*************************************************************************
% ESTIMATED PARAMETERS 
%*************************************************************************
  estimated_params;      
	 sigma, gamma_pdf, 1.2, 0.4 ;
     phi, gamma_pdf, 1.5, 0.75;
     theta_h, beta_pdf,0.5, 0.1 ;  
     theta_f, beta_pdf,0.5, 0.1 ; 
	 eta, gamma_pdf, 1.5, 0.75;	 	 
     h, beta_pdf,0.5, 0.25 ; 
	 delta_h, beta_pdf,0.5, 0.25 ;
	 delta_f, beta_pdf,0.5, 0.25 ;
	
	 rho_i, beta_pdf,0.5, 0.25 ;
     psi_pi, gamma_pdf, 1.5, 0.3;
	 psi_y, gamma_pdf, 0.25, 0.13;
	 psi_e, normal_pdf, 0.2, 0.05;
	 psi_dy, gamma_pdf, 0.25, 0.13;
     theta_star, beta_pdf,0.7, 0.15 ;
	 rho_i_star, beta_pdf,0.5, 0.15 ;
     psi_pi_star, gamma_pdf, 1.5, 0.75;	  
	 psi_istar, gamma_pdf, 0.25, 0.13;
	 psi_y_star, gamma_pdf, 0.25, 0.13;     
     	 
	 rho_a, beta_pdf,0.8, 0.1 ;
	 rho_g, beta_pdf,0.8, 0.1 ;
	 rho_rp, beta_pdf,0.8, 0.1 ;
	 rho_gs, beta_pdf,0.5, 0.15 ;
     rho_a_star, beta_pdf,0.5, 0.15 ;  
	 
	 chi, gamma_pdf, 1.5, 0.75;
        
     stderr epsilon_a, inv_gamma_pdf, 1, inf;        
     stderr epsilon_i, inv_gamma_pdf, 1, inf;
	 stderr epsilon_cp, inv_gamma_pdf, 1, inf;      
     stderr epsilon_rp, inv_gamma_pdf, 1, inf;       
     stderr epsilon_g, inv_gamma_pdf, 1, inf;     
     stderr epsilon_gs, inv_gamma_pdf, 1, inf;     
     stderr epsilon_astar, inv_gamma_pdf, 1, inf;   
     stderr epsilon_istar, inv_gamma_pdf, 1, inf;
 end; 

estimated_params_init(use_calibration);
end;

%*************************************************************************
% OBSERVED VARIABLES 
%*************************************************************************
varobs y_au pi_au i_au q y_us pi_us i_us;

%*************************************************************************
% ESTIMATION  
%*************************************************************************
estimation(Tex,datafile=JP_Australian_Data, first_obs=XXX,prefilter=1,presample=4,mode_compute=4,mh_replic=0) y_au pi_au i_au q;

%*************************************************************************
% SIMULATION  
%*************************************************************************
stoch_simul(irf=24) y c i pi pi_h pi_f e nfa mc; 
*/
%----------------------------------------------------------------
% generate LaTeX output
%----------------------------------------------------------------
write_latex_original_model;
write_latex_parameter_table;
write_latex_definitions;
write_latex_prior_table;
collect_latex_files;
% delete the next command if you do not have a Tex app installed
if system(['pdflatex -halt-on-error -interaction=batchmode ' M_.fname '_TeX_binder.tex'])
    error('TeX-File did not compile.')
end