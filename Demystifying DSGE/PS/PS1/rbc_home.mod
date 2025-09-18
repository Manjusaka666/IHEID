
% PS1 2025 – Part 2: RBC with Home Production (σ=1, CES aggregator)
% Author: ChatGPT (GPT-5 Thinking)
% Non-linear levels; capital dated at t-1; Euler with one-period lead on C_m and R

var y cm ch ctot i k lm lh r w a b;
varexo epsA epsB;

parameters alpha beta gamma delta eta omega theta rhoA sigmaA rhoB sigmaB Abar Bbar Lm_ss Lh_ss;

% ---- Calibration (Table 3) ----
alpha  = 0.35;
beta   = 0.97;
gamma  = 0.45;
delta  = 0.06;
eta    = 0.80;
omega  = 0.40;
theta  = 0.80;
rhoA   = 0.95;
sigmaA = 0.001;
rhoB   = 0.95;
sigmaB = 0.001;
Abar   = 1;
Bbar   = 1;

graph_format (png);

% For steady state: use the table values for (l_m, l_h)
Lm_ss  = 0.28550;
Lh_ss  = 0.26689;

% ---- Model equations ----
model;
  % Market production and factor prices (market labor only)
  y  = a * k(-1)^alpha * lm^(1-alpha);
  r  = alpha*y/k(-1);
  w  = (1-alpha)*y/lm;

  % Home production
  ch = b * lh^theta;

  % CES aggregator for total consumption used in utility
  ctot = ( omega*cm^eta + (1-omega)*ch^eta )^(1/eta);

  % Euler (lead the RHS marginal utility term of cm and r by one period)
  beta * ( gamma*omega*cm(+1)^(eta-1) / ( omega*cm(+1)^eta + (1-omega)*ch(+1)^eta ) ) * ( r(+1) + 1 - delta )
    =      ( gamma*omega*cm^(eta-1)      / ( omega*cm^eta      + (1-omega)*ch^eta      ) );

  % Intratemporal FOCs for market and home time
  (1-gamma)/(1 - lm - lh) = ( gamma*omega*cm^(eta-1)   / ( omega*cm^eta + (1-omega)*ch^eta ) ) * w;
  (1-gamma)/(1 - lm - lh) = ( gamma*(1-omega)*ch^(eta-1)/ ( omega*cm^eta + (1-omega)*ch^eta ) ) * theta*b*lh^(theta-1);

  % Market resource constraint and capital accumulation
  y = cm + i;                          % only market goods are produced/used for saving
  k = (1 - delta)*k(-1) + i;

  % Exogenous processes (logs), Abar=Bbar=1
  log(a) = rhoA*log(a(-1)) + epsA;
  log(b) = rhoB*log(b(-1)) + epsB;
end;

% ---- Steady state (uses table values for lm, lh) ----
steady_state_model;
  % Part 1 ratios still apply in the market block
  Rbar = 1/beta - 1 + delta;
  KY   = alpha / Rbar;
  IY   = delta*KY;
  CY   = 1 - IY;

  % Labor (given)
  lm   = Lm_ss;
  lh   = Lh_ss;

  % Output and levels with Abar=1
  y    = (Abar^(1/(1-alpha))) * ( (alpha*beta)/(1 - beta + beta*delta) )^(alpha/(1-alpha)) * lm;
  k    = KY * y;
  i    = delta * k;
  cm   = CY * y;
  ch   = Bbar * lh^theta;
  ctot = ( omega*cm^eta + (1-omega)*ch^eta )^(1/eta);
  w    = (1-alpha)*y/lm;
  r    = Rbar;
  a    = Abar;
  b    = Bbar;
end;

% ---- Initialization and solve ----
initval;
  y    = 0.58995;
  cm   = 0.45370;
  ch   = 0.34759;
  ctot = 0.0;
  i    = 0.13625;
  k    = 2.27082;
  lm   = 0.28550;
  lh   = 0.26689;
  r    = 0.0909278;
  w    = 1.3431151;
  a    = 1.0;
  b    = 1.0;
  epsA = 0;
  epsB = 0;
end;

resid; steady; check;

% ---- Shocks ----
shocks;
  var epsA; stderr sigmaA;
  var epsB; stderr sigmaB;
end;

% ---- Simulation ----
stoch_simul(order=1, irf=40, hp_filter=1600, Tex) y cm ch ctot lm lh i r w;

%  -------------------- OPTIONAL (Dynare ≥ 5): auto-build a LaTeX/PDF report --------------------
report(type='TeX', filename='rbc_home_report', directory='report/rbc_home', useGraphNames=true)
  page()
    section('Impulse Responses – Market TFP shock (A)')
      graph_list(var_list=(y cm i lm r w), irf=40, col=3)
    end
    section('Impulse Responses – Home TFP shock (B)')
      graph_list(var_list=(ch ctot lh), irf=40, col=3)
    end
    section('Moments (HP=1600, order=1)')
      moments_table(var_list=(y cm ch ctot lm lh i r w), hp_filter=1600)
    end
  end
end