var y c i k l r w a;
varexo epsA;

parameters alpha beta gamma delta rhoA sigmaA Abar;

% ---- Calibration (Table 1) ----
alpha   = 0.35;
beta    = 0.97;
gamma   = 0.40;
delta   = 0.06;
rhoA    = 0.95;
sigmaA  = 0.01;
Abar    = 1;

% ---- Model equations ----
model;
% Production and factor prices
y = a* k(-1)^alpha * l^(1-alpha);
r = alpha*y/k(-1);
w = (1-alpha)*y/l;

% Euler (lead C and R by one period, per assignment note)
c(+1)/c = beta*( r(+1) + 1 - delta );

% Intratemporal labor supply
((1-gamma)/gamma)* c/(1 - l) = w;

% Resource constraint and capital accumulation
y = c + i;
k = (1 - delta)*k(-1) + i;

% TFP process in logs; Abar = 1
log(a) = rhoA*log(a(-1)) + epsA;
end;

% ---- Initialization and solve ----
initval;
  y = 0.75;
  c = 0.57;
  i = 0.17;
  k = 2.87;
  l = 0.36;
  r = alpha*y/k;
  w = (1-alpha)*y/l;
  a = 1.0;
  epsA = 0;
end;

resid; steady; check;

% ---- Shocks ----
shocks;
  var epsA; stderr sigmaA;
end;

% ---- Simulation ----
stoch_simul(irf=40, TeX);
