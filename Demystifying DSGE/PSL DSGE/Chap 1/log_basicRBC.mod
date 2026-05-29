%%% 
%%% New Classical Growth Model
%%% gauthier@vermandel.fr
%%% DSGE course @dauphine
%%% 

var c k a;
parameters  alpha beta delta rho_A Css Kss;
varexo e_a;

% Calibration
alpha		= 0.40;				% capital share in production 
beta    	= 0.99;				% discount factor
delta    	= 0.025;			% depreciation rate
rho_A		= 0.95;				% shock autocorrelation

% steady states
Kss			= ((1/beta-(1-delta))/alpha)^(1/(alpha-1));
Css			= Kss^alpha - delta*Kss;

% Model
model(linear);
	[name='Euler equation']
	c = c(+1) - beta*alpha*Kss^(alpha-1)*(a(+1) + (alpha-1)*k);
	[name='Budget constraint']
	k = Kss^(alpha-1)*( a + alpha*k(-1) ) + (1-delta)*k(-1) - Css/Kss*c;
	[name='Productivity shock']
	a = rho_A*a(-1)+e_a;
end;

% shock calibration
shocks;
	var e_a;  stderr .007;
end;

% check the stability 
check;

% perform stochastic simulations
stoch_simul(irf=30) c k a;