% New Keynesian 2 country model
% gauthier[at]vermandel.fr

close all;

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var y_h c_h r_h pi_h w_h z_h h_h k_h i_h q_h mc_h x_h px_h pix_h e_a_h e_g_h e_p_h e_r_h;
var y_f c_f r_f pi_f w_f z_f h_f k_f i_f q_f mc_f x_f px_f pix_f e_a_f e_g_f e_p_f e_r_f;
var de rer b ca;
varexo	eta_a_h eta_g_h eta_p_h eta_r_h;
varexo	eta_a_f eta_g_f eta_p_f eta_r_f;

parameters	beta alpha delta sigmaC sigmaL gy
			rho phi_r theta_p chi_I
			phi nu chi_B
			rho_a rho_g rho_p rho_r  
			Rss Yss Zss Css Iss;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------
alpha   	= 0.20;				% share of capital in ouput
beta    	= 0.993;			% discount factor
delta  		= 0.025;			% depreciation of capital
sigmaC		= 1.4;				% risk aversion consumption
sigmaL		= 2;				% labor disutility
gy 			= 0.18; 			% Public spending to GDP ratio
theta_p		= 0.65;				% new keynesian Philips Curve, forward term
rho			= .8;				% Monetary Policy Smoothing Parameter
phi_r		= 2;				% Monetary Policy Inflation Growth Target
chi_I		= 5.5;				% Investment adjustment cost
mu			= 1.1;				% mark-up on goods
phi			= 0.15;				% intermediate market openness
nu			= 1.5;				% Substitutability
chi_B		= 0.01;				% country premium

% shock process
rho_a   	= 0.95; 			% productivity 
rho_g   	= 0.97; 			% public spending
rho_p		= 0.90;				% price shock
rho_r		= 0.12;				% monetary policy shock

% steady states
Rss			= 1/beta;
Zss			= 1/beta-(1-delta);
Hss			= 1/3;				
MCss		= 1/mu;
Kss			= Hss*(Zss/(alpha*MCss))^(1/(alpha-1));
Yss			= Kss^alpha*Hss^(1-alpha);
Css			= (1-gy)*Yss-delta*Kss;
Iss			= delta*Kss;
Wss			= (1-alpha)*MCss*Yss/Hss;

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------
model(linear);	
    %% Household
	% Euler
	sigmaC*(c_h(+1)-c_h)=r_h-pi_h(+1);
	sigmaC*(c_f(+1)-c_f)=r_f-pi_f(+1);
	% Hours supply
	w_h = sigmaL*h_h+sigmaC*c_h;
	w_f = sigmaL*h_f+sigmaC*c_f;

	
	%% Capital supply
	% No arbitrage Bonds-Capital
	r_h - pi_h(+1) = (Zss/Rss)*z_h(+1) + ((1-delta)/Rss)*q_h(+1) - q_h ;
	r_f - pi_f(+1) = (Zss/Rss)*z_f(+1) + ((1-delta)/Rss)*q_f(+1) - q_f ;
	% Capital law of motion
	delta*i_h = k_h-(1-delta)*k_h(-1);
	delta*i_f = k_f-(1-delta)*k_f(-1);
	% Investment equation
	q_h = chi_I*(i_h-i_h(-1)) - beta*chi_I*(i_h(+1)-i_h);
	q_f = chi_I*(i_f-i_f(-1)) - beta*chi_I*(i_f(+1)-i_f);

	
    % Intermediary firms
	% Production function
	x_h = e_a_h + alpha*k_h(-1) + (1-alpha)*h_h;
	x_f = e_a_f + alpha*k_f(-1) + (1-alpha)*h_f;
	% Real marginal cost
	mc_h = alpha*z_h + (1-alpha)*w_h -  e_a_h;
	mc_f = alpha*z_f + (1-alpha)*w_f -  e_a_f;
	% Cost minimization
	w_h + h_h = z_h + k_h(-1);
	w_f + h_f = z_f + k_f(-1);
	% Price dynamics NKPC
	pix_h = beta*pix_h(+1) + (1-theta_p)*(1-theta_p*beta)/theta_p*mc_h + eta_p_h;
	pix_f = beta*pix_f(+1) + (1-theta_p)*(1-theta_p*beta)/theta_p*mc_f + eta_p_f;
	
	
	%% International intermediate good market equilibrium
	x_h = (1-phi)*(y_h - nu*px_h) + phi*(y_f - nu*(px_h - rer));
	x_f = (1-phi)*(y_f - nu*px_f) + phi*(y_h - nu*(px_f + rer));
	% CES price index
	(1-phi)*px_h + phi*(px_f + rer) = 0;
	(1-phi)*px_f + phi*(px_h - rer) = 0;
	% Relative prices
	px_h - px_h(-1) = pix_h - pi_h;
	px_f - px_f(-1) = pix_f - pi_f;
    % Resources constraint
	Yss*y_h = Css*c_h + Iss*i_h + gy*Yss*e_g_h;
	Yss*y_f = Css*c_f + Iss*i_f + gy*Yss*e_g_f;
	
	
	% Monetary policy
	r_h = rho*r_h(-1) + (1-rho)*phi_r*pi_h + e_r_h;
	r_f = rho*r_f(-1) + (1-rho)*phi_r*pi_f + e_r_f;
	
	
	%% International macro definitions
	% variation of the real exchange rate
	de(+1) = r_h - r_f + chi_B*b;
	% Real exchange rate
	rer - rer(-1) = de + pi_f - pi_h;
	% net foreign assets
	b = Rss*b(-1) + Yss/Css*( px_h + x_h - y_h );
	% current account
	ca = b - b(-1);

	
    % Exogenous shocks
	e_a_h = rho_a*e_a_h(-1) + eta_a_h;
	e_a_f = rho_a*e_a_f(-1) + eta_a_f;
	e_g_h = rho_g*e_g_h(-1) + eta_g_h;
	e_g_f = rho_g*e_g_f(-1) + eta_g_f;
	e_p_h = rho_p*e_p_h(-1) + eta_p_h;
	e_p_f = rho_p*e_p_f(-1) + eta_p_f;
	e_r_h = rho_r*e_r_h(-1) + eta_r_h;
	e_r_f = rho_r*e_r_f(-1) + eta_r_f;
end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------
check;

shocks;
var eta_a_h;  stderr .45;
var eta_g_h;  stderr .5;
var eta_p_h;  stderr .5;
var eta_r_h;  stderr .25;
end;

stoch_simul(order=1,irf=30,nograph) y_h y_f c_h c_f pi_h pi_f i_h i_f r_h r_f rer ca b;
plot2c(var_list_,4,2);