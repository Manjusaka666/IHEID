close all;

var lb c y pi r h w mc lp lr ly
	e_a e_c e_p;

varexo eta_A eta_C eta_P ;

parameters beta sigmaC epsilon sigmaH kappa chi rho phi_y phi_pi
		rho_A rho_C rho_P;


beta	= .994;
sigmaC	= 1.5;
sigmaH	= 2;
kappa	= 100;
epsilon	= 6;
rho		= .8;
phi_y 	= .125;
phi_pi	= 1.5;
rho_A	= .95;
rho_P	= .15;
rho_C	= .18;


model;
	[name='marginal utility - consumption']
	lb = c^-sigmaC*e_c;
	[name='marginal disutility - labor']
	chi*h^sigmaH*e_c = lb*w;
	[name='Euler']
	lb = beta*lb(+1)*r/pi(+1);
	[name='production technology']					
	y = e_a*h;
	[name='inputs costs']					
	mc = w/e_a;
	[name='resources constraint']					
	y = c + 0.5*kappa*(pi-1)^2*y;
	[name='sticky prices']	
	(epsilon-1)-epsilon*e_p*mc + kappa*(pi-1)*pi - beta*lb(+1)/lb*kappa*(pi(+1)-1)*pi(+1)*y(+1)/y;
	[name='monetary policy']
	r = r(-1)^rho * (steady_state(r)*(pi/steady_state(pi))^phi_pi*(y/steady_state(y))^phi_y)^(1-rho);
	[name='TFP Shock']					
	log(e_a) = rho_A*log(e_a(-1)) + eta_A;
	[name='Premium Shock']					
	log(e_c) = rho_C*log(e_c(-1)) + eta_C;
	[name='Mk Shock']					
	log(e_p) = rho_P*log(e_p(-1)) + kappa/(epsilon-1)*eta_P; % this shock is normalized by the slope of the NK curve
	[name='Log deviation pi']					
	lp = log(pi/steady_state(pi));
	[name='Log deviation r']					
	lr = log(r/steady_state(r));
	[name='Log deviation y']					
	ly = log(y/steady_state(y));
end;

steady_state_model;
	e_a 	= 1; e_c 	= 1; e_p 	= 1;
	lp = 0; lr = 0; ly = 0;
	pi		= 1;
	r		= pi/beta; 
	h		= 1;
	mc		= ((1-beta)*kappa*(pi-1)*pi+epsilon-1)/epsilon;
	y		= h;
	c		= y*(1-0.5*kappa*(pi-1)^2);
	lb 		= c^-sigmaC;
	w		= mc;
	chi 	= lb*w*h^-sigmaH;
end;

shocks;
	var eta_A; stderr 0.0045;
	var eta_C; stderr 0.0023;
	var eta_P; stderr 0.0140;
end;

stoch_simul(order=1,nograph,irf=30) pi y r;
irfs1= oo_.irfs;


%%% optimal policy weights
gamm_pi	= .5/(1-beta)*kappa;
gamm_y	= .5/(1-beta)*(sigmaC+(epsilon-1)/epsilon*sigmaH);


optim_weights; 
	pi gamm_pi; 
	y  gamm_y; 
	r  0.07;
end;


osr_params  rho phi_pi phi_y; 
osr(nograph,irf=30) pi y r;
irfs2= oo_.irfs;


%% COMPARING IRFS
T=1:options_.irf;
n=size(var_list_,1);
for i1 = 1:M_.exo_nbr
	
	shockname =deblank(M_.exo_names(i1,:));
	
	if isfield(irfs1,[deblank(var_list_(1,:)) '_' shockname])
	
		figure('Name',shockname,'NumberTitle','off');
		for i2 = 1:n
			varname = deblank(var_list_(i2,:));
			
			subplot(n,1,i2)
			plot(	T,eval(['irfs1.' varname '_' shockname]),...
					T,eval(['irfs2.' varname '_' shockname]),':');
			title(varname)
		end
		
	end
	xlabel(['Response to ' shockname])
	legend('Calibrated','Optimal')
end
