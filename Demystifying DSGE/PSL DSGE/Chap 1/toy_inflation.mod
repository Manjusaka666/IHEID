%%% 
%%% Toy model of inflation
%%% to illustrate how to solve a (one equation) DSGE model
%%% and perform IRF plot, artificial cycles and second moment statistics computation
%%% gauthier@vermandel.fr
%%% DSGE course
%%% 

close all;

var  pi;

varexo e;

parameters gamma beta sigma;  

gamma 	= 0.9;	% expectations in the NK curve
beta	= .99;	% discount factor
sigma	= 0.01;	% std of the inflation shock

model(linear);
	pi = beta*gamma*pi(+1) + (1-gamma)*pi(-1) + e;
end;

shocks;
var e; stderr sigma;
end;

stoch_simul(order=1,irf=10) pi;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SOLVING BY HAND THE MODEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% time horizon of the IRF
T		= 11;
% Use matlab to find the root
A 		= roots([beta*gamma -1 (1-gamma)]);
% and select the stable one
A 		= A(A<1);
% Or compute A1 and A2 directly through their close form solution:
A1		=(1-sqrt(1-4*gamma*beta*(1-gamma)))/(2*gamma*beta);
A2		=(1+sqrt(1-4*gamma*beta*(1-gamma)))/(2*gamma*beta);
B 		= (1-gamma*beta*A)^-1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% IRF COMPUTATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p 		= zeros(1,T);
eta		= zeros(1,T);
% initizalization of the shock in the second period
eta(2) 	= sigma;

for t = 2:T
	p(t) = A*p(t-1) + B*eta(t);
end
figure
plot(1:T,p,1:T,[0 oo_.irfs.pi_e],'r*')
legend('By-hand','Dynare')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% RANDOM CYCLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T			= 101;
p_r 		= zeros(1,T);
eta_r		= zeros(1,T);
% vector of shock fed from a gaussian law N(0,sigma)
eta_r(2:end)= normrnd(0,sigma,1,T-1);

for t = 2:T
	p_r(t) = A*p_r(t-1) + B*eta_r(t);
end
figure
plot(1:T,p_r)
xlim([2 T])
legend('By-hand')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SECOND MOMENT STATISTICS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T				= 100000;
p_sms 			= zeros(1,T);
eta_sms			= zeros(1,T);
% initizalization of the shock in the second period
eta_sms(2:end)	= normrnd(0,sigma,1,T-1);
% compute the cycle
for t = 2:T
	p_sms(t) = A*p_sms(t-1) + B*eta_sms(t);
end
% discard the first 500 draws
p_sms = p_sms(500:end);
% compute the variance and std
var_sms = var(p_sms(500:end));
std_sms = sqrt(var_sms);

% compute the variance/std via stochastic calculus
var_sc	= B^2*sigma^2/(1-A^2);
std_sc	= sqrt(var_sc);
