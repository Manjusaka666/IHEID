%----------------------------------------------------------------
% 0. Housekeeping (close all graphic windows)
%----------------------------------------------------------------
close all;

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------
var y pi r e_D e_S e_R;
var y_obs pi_obs r_obs;

varexo eta_D eta_S eta_R;

parameters  beta sigma varphi rho phi_pi phi_y phi_dy theta
			% shocks
			rho_D rho_S rho_R;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------
beta    	= 0.9951;			% discount factor
sigma		= 1;				% risk aversion consumption
varphi		= 1;				% labor disutility
theta		= 0.75;				% new keynesian Philips Curve, forward term
rho			= 0.80;				% MPR Smoothing
phi_pi		= 1.5;				% MPR Inflation
phi_y		= 0.2;				% MPR GDP
phi_dy		= 0;

% shock processes
rho_D   = 0.80;
rho_S   = 0.95;
rho_R 	= 0.40;

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------
model(linear); 
	[name='IS curve']
	y = y(+1) - 1/sigma*(r-pi(+1)) + e_D;
	[name='AS curve']
	pi = beta*pi(+1) + ((1-theta)*(1-beta*theta)/theta)*(sigma+varphi)*y + e_S;
	[name='Monetary Policy Rule']
	r = rho*r(-1) +  (1-rho)*( phi_pi*pi + phi_y*y ) + phi_dy*(y-y(-1)) + e_R  ;
	
	[name='demand shock']
	e_D = rho_D*e_D(-1)+eta_D;
	[name='supply shock']
	e_S = rho_S*e_S(-1)+eta_S;
	[name='monetary policy shock']
	e_R = rho_R*e_R(-1)+eta_R;
	
	[name='observables']
	r_obs = r;
	y_obs = y - y(-1);
	pi_obs = pi;
end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------
estimated_params;
//	PARAM NAME,		INITVAL,	LB,		UB,		PRIOR_SHAPE,		PRIOR_P1,		PRIOR_P2,		PRIOR_P3,		PRIOR_P4,		JSCALE
	stderr eta_D,   	,		,		,		INV_GAMMA_PDF,		.1,				2;
	stderr eta_S,     	,		,		,		INV_GAMMA_PDF,		.1,				2;
	stderr eta_R,		,		,		,       INV_GAMMA_PDF,		.1,				2;
	rho_D,				.9,    	,		,		beta_pdf,			.5,				0.2;
	rho_S,				.9,     ,		,		beta_pdf,			.5,				0.2;
	rho_R,				.4,		,		,		beta_pdf,			.5,				0.2;
 	sigma,				,		,		,		gamma_pdf,			1,				0.4;
	varphi,				1,		,		,		gamma_pdf,			2,				0.75;
	phi_pi,				,		,		,		normal_pdf,			1.5,       		0.1;
	phi_y,				0.01,	,		,		normal_pdf,			0.05,			0.05;
	phi_dy,				0.01,	,		,		normal_pdf,			0.05,			0.05;
	rho,				,		,		,		beta_pdf,			.75,			0.05;
	theta,				,		,		,		beta_pdf,			.5,	    	    0.1;
end;



varobs 	y_obs pi_obs r_obs;

%%% Commment or uncomment one of them:

%%% estimation of the model
estimation(datafile=mydata,first_obs=1,mode_compute=4,mh_replic=20000,mh_jscale=0.5,prefilter=1,lik_init=2,bayesian_irf,irf=30) y_obs pi_obs r_obs;
%%% or loading back the previous estimation
%%% (not working if you have not run an estimation before)
%estimation(datafile=mydata,first_obs=1,mh_replic=0,mh_jscale=0.5,prefilter=1,lik_init=2,load_mh_file,mode_file=NK3eq_estim_mode,mode_compute=0) y y_obs pi_obs r_obs;

