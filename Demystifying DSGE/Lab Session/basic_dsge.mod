var y c k i a;
varexo e;

parameters beta alpha delta rho sigma;

beta  = 0.99;
alpha = 0.36;
delta = 0.025;
rho   = 0.95;
sigma = 0.01;

model;
% Production function
y = exp(a)*k(-1)^alpha;
% Resource constraint
i = k - (1-delta)*k(-1);
c = y - i;
% Euler equation (log utility U(c)=log(c))
1/c = beta * (1/c(+1)) * (alpha*exp(a(+1))*k^(alpha-1) + 1 - delta);
% 技术冲击过程：把它放在 model 块内
a = rho*a(-1) + e;
end;

shocks;
var e; stderr sigma;
end;

% Steady state (with a=0)
steady_state_model;
r = 1/beta - 1 + delta;
k = (alpha / r)^(1/(1-alpha));
y = k^alpha;
i = delta*k;
c = y - i;
a = 0;
end;

check;
stoch_simul(order=1, irf=20, periods=200);