var y cm ch i k ctot lm lh r w a b;
varexo epsA epsB;

parameters alpha beta gamma delta eta omega theta rhoA sigmaA rhoB sigmaB Abar Bbar;

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
  % beta * ( gamma*omega*cm(+1)^(eta-1) / ( omega*cm(+1)^eta + (1-omega)*ch(+1)^eta ) ) * ( r(+1) + 1 - delta )
  %  =      ( gamma*omega*cm^(eta-1)      / ( omega*cm^eta      + (1-omega)*ch^eta      ) );

  % Intratemporal FOCs for market and home time
  % (1-gamma)/(1 - lm - lh) = ( gamma*omega*cm^(eta-1)   / ( omega*cm^eta + (1-omega)*ch^eta ) ) * w;
  % (1-gamma)/(1 - lm - lh) = ( gamma*(1-omega)*ch^(eta-1)/ ( omega*cm^eta + (1-omega)*ch^eta ) ) * theta*b*lh^(theta-1);

  gamma*omega*(cm^(eta-1))/(omega*cm^eta+(1-omega)*ch^eta)=(1-gamma)/(w*(1-lm-lh)); 
  gamma*(1-omega)*(ch^(eta-1))/(omega*cm^eta+(1-omega)*ch^eta)=(1-gamma)/(theta*b*lh^(theta-1)*(1-lm-lh));
  ((cm^(eta-1))/(omega*cm^eta+(1-omega)*ch^eta))/((cm(+1)^(eta-1))/(omega*cm(+1)^eta+(1-omega)*ch(+1)^eta))=beta*(r(+1)+1-delta); 

  % Market resource constraint and capital accumulation
  i = y - cm;                          % only market goods are produced/used for saving
  k = (1 - delta)*k(-1) + i;

  % Exogenous processes (logs), Abar=Bbar=1
  log(a) = rhoA*log(a(-1)) + epsA;
  log(b) = rhoB*log(b(-1)) + epsB;
end;

% ---- Initialization and solve ----
initval;
  y    = 0.58995;
  cm   = 0.45370;
  ch   = 0.34759;
  i    = 0.13625;
  k    = 2.27082;
  lm   = 0.28550;
  lh   = 0.26689;
  r    = alpha * y / k;
  w    = (1-alpha) * y / lm;
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
stoch_simul(order=1, irf=40, Tex);