var C I Y K L R W P A;
predetermined_variables K;
parameters beta sigma phi alpha delta rhoA;
varexo e;

% Model equations block
model;
C^sigma*L^phi = W/P;
(C(+1)/C)^sigma = beta*((1-delta)+R(+1)/P(+1));
K(+1) = (1-delta)*K+I;
Y = A*(K^alpha)*(L^(1-alpha));
K = alpha*Y/(R/P);
L = (1-alpha)*Y/(W/P);
P = (1/A)*(W/(1-alpha))^(1-alpha)*(R/alpha)^alpha;
I = Y - C;
log(A) = rhoA*log(A(-1)) + e;
end;

initval;
Y = 2.3;
C = 1.8;
L = 0.7;
K = 20;
I = Y-C;
W = (1-alpha)*Y/L;
R = alpha*Y/K + (1 - delta);
A = 1;
P = 1;
e = 0;
end;

% Parameter calibration
beta = 0.99;
sigma = 2;
phi = 1;
alpha = 0.36;
delta = 0.025;
rhoA = 0.95;

% Compute steady state
steady;

% Check eigenvalues
check;

% Stochastic simulation
shocks;
var e; stderr 0.01;
end;

stoch_simul(order=1,irf=40);