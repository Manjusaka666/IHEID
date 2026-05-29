%%% 
%%% Full-fledged RBC model
%%% gauthier@vermandel.fr
%%% DSGE course @dauphine
%%% 

close all;
%----------------------------------------------------------------
% 0. Housekeeping (close all graphic windows)
%----------------------------------------------------------------

close all;

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var y c k i h w r z;
var ln_y ln_c ln_k ln_i ln_h ln_w ln_r ln_z;
var    e_a   e_g   e_c   e_i;


varexo eta_a eta_g eta_c eta_i;

parameters beta delta alpha sigmaC sigmaL chi gy
			% shocks AR(1) terms
			rho_a rho_g rho_c rho_i;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------



%Parametres exogenes RBC Cycles
beta 	= 0.99; 	%Discount Factor
delta 	= 0.025;	%Depreciation rate
alpha 	= 0.36;		%Capital share
gy 		= 0.2;   	%Public spending in GDP
sigmaC 	= 1;
sigmaL 	= 1; 		%Elasticity of labor

% autoregressive roots parameters
rho_a	= 0.95;
rho_g	= 0.95;
rho_c	= 0.95;
rho_i	= 0.95;

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model; 
	%% Household
	[name='Euler']
	beta*r = (e_c/e_c(+1)) * (c(+1)/c)^sigmaC;
	[name='Labor Supply']
	w = chi*(h^sigmaL)*(c^sigmaC);
	
	%% Capital supply
	[name='No arbitrage Bonds-Capital']
	r/e_i = (1-delta)/e_i(+1) + z(+1);
	[name='Capital law of motion']
	e_i*i = k-(1-delta)*k(-1);
	
	%% Production
	[name='technology']
	y = e_a*(k(-1)^alpha)*(h^(1-alpha));
	[name='Inputs Cost minimization']
	z=alpha*y/k(-1);
	w=(1-alpha)*y/h;
	
	[name='Resources Constraint']
	y = c + i + gy*steady_state(y)*e_g;
	
	[name='shocks']
	log(e_a) = rho_a*log(e_a(-1))+eta_a;
	log(e_g) = rho_g*log(e_g(-1))+eta_g;
	log(e_c) = rho_c*log(e_c(-1))+eta_c;
	log(e_i) = rho_i*log(e_i(-1))+eta_i;
	
	[name='Linearized counterpart']
	ln_y = log(y/STEADY_STATE(y));
	ln_c = log(c/STEADY_STATE(c));
	ln_k = log(k/STEADY_STATE(k));
	ln_i = log(i/STEADY_STATE(i));
	ln_h = log(h/STEADY_STATE(h));
	ln_w = log(w/STEADY_STATE(w));
	ln_r = log(r/STEADY_STATE(r));
	ln_z = log(z/STEADY_STATE(z));
	
end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

steady_state_model;
	r		= 1/beta;
	h		= 1/3;
	q		= 1;
	z		= (r*q-(1-delta)*q);
	k		= h*(z/alpha)^(1/(alpha-1));
	y		= k^alpha*h^(1-alpha);
	i		= delta*k;
	w		= (1-alpha)*y/h;
	c		= (1-gy)*y-i;
	chi		= w/((h^sigmaL)*(c^sigmaC));

	ln_y = 0;
	ln_c = 0;
	ln_k = 0;
	ln_i = 0;
	ln_h = 0;
	ln_w = 0;
	ln_r = 0;
	ln_z = 0;
  
	e_a = 1;
	e_g = 1;
	e_c = 1;
	e_i = 1;
end;

shocks;
	var eta_a;  stderr 0.01;
	var eta_g;  stderr 0.01;
	var eta_c;  stderr 0.01;
	var eta_i;  stderr 0.01;
end;

resid(1);

steady;

stoch_simul(irf=60) ln_y ln_c ln_k ln_i ln_h ln_w ln_r ln_z;
