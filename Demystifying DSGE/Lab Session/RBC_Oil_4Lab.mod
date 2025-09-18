% RBC with Oil
%Endogenous Variables
var y, c, i, k, h, w, r, a, z, o, q;

%Changing the timing convention
predetermined_variables k;

%Exogenous Variables
varexo e u;

%Parameters of the model
parameters alpha, beta, theta, delta ,gamma, m, rhoa, rhoz;
alpha = 0.32;
beta = 0.97;
theta = 0.64;
delta = 0.06;
gamma = 0.4;
m = 0.05;
rhoa = 0.95;
rhoz = 0.95;

%Dynamic Equations
model;
y = c + i;
k(+1) = i +(1-delta)*k;
c(+1)/c = beta*(r(+1)+ (1 - delta));
y = a*(k^alpha)*(h^theta)*(o^(1-alpha-theta));
h = (w - gamma*c)/w;
r = alpha*(y/k);
w = (theta)*(y/h);
q = (1-alpha-theta)*(y/o);
o = m*z;
log(a)= rhoa*log(a(-1))+ e;
log(z)= rhoz*log(z(-1))+ u;
end;

% /*
%Initial Values
initval;
y = 1;
c = 0.8;
i = 0.2;
k = 3.5;
h = 0.2;
r = 0.05;
w = 1.3;
a = 1;
z = 1;
e = 0;
u = 0;
o = z*m;
q = (1-alpha-theta)*y/o;
end;
% */

%Steady-State
resid;
steady;

%Check Blanchard-Kahn conditions
check;

%Shocks of the model
shocks;
var e; stderr 0.01;
var u; stderr 0.01;
end;

%Stochastic Simulation
stoch_simul y c i k h r w o q;