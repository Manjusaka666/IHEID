
% PS1 2025 – Part 1: Basic RBC (σ=1, P=1)
% Author: ChatGPT (GPT-5 Thinking)
% Model: Non-linear levels, capital dated at t-1; Euler with one-period lead on C and R

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

% ---- Steady state (analytical) ----
steady_state_model;
  % Gross net-capital return and ratios
  Rbar = 1/beta - 1 + delta;           % From 1 = beta*(R + 1 - delta)
  KY   = alpha / Rbar;                 % From r = alpha*y/k(-1) with r=Rbar in SS
  IY   = delta*KY;                     % i/y in SS
  CY   = 1 - IY;                       % c/y in SS

  % Labor from intratemporal FOC: ((1-gamma)/gamma)*CY*L = (1-alpha)*(1-L)
  l = (1-alpha) / ( (1-alpha) + ((1-gamma)/gamma)*CY );

  % Output level (Abar=1): Y = A^(1/(1-alpha)) * (alpha*beta/(1-beta+beta*delta))^(alpha/(1-alpha)) * L
  y = (Abar^(1/(1-alpha))) * ( (alpha*beta)/(1 - beta + beta*delta) )^(alpha/(1-alpha)) * l;

  % Other SS levels
  k = KY * y;
  i = delta * k;
  c = CY * y;
  w = (1-alpha)*y/l;
  r = Rbar;
  a = Abar;
end;

% ---- Initialization and solve ----
initval;
  y = 0.7446975;
  c = 0.5727078;
  i = 0.1719897;
  k = 2.8664943;
  l = 0.3603960;
  r = 0.0909278;
  w = 1.3431151;
  a = 1.0;
  epsA = 0;
end;

resid; steady; check;

% ---- Shocks ----
shocks;
  var epsA; stderr sigmaA;
end;

% ---- Simulation ----
stoch_simul(order=1, irf=40, hp_filter=1600, TeX) y c i l r w;

%  -------------------- OPTIONAL (Dynare ≥ 5): auto-build a LaTeX/PDF report --------------------
report(filename='rbc_basic_report', directory='report/rbc_basic')
  page()
    section('Impulse Responses')
      graph_list(var_list=[y c i l r w], irf=40, col=3)
    endsection
    section('Moments (HP=1600, order=1)')
      moments_table(var_list=[y c i l r w], hp_filter=1600)
    endsection
  endpage
endreport
