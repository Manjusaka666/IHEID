% From Christoffel and Kuester (2008) "Resuscitating the wage channel in models with unemployment fluctuations", JME 55, p. 865? 887
% Note: the original model runs on a MONTHLY frequency
%  The file here presents a recalibration of the model to a QUARTERLY frequency
% Last edited: 2011/05/10 by K. Kuester
% This is the "RTM" version of the model

var
y ${y}$ (long_name = 'output')
c ${c}$ (long_name = 'consumption')
Pi ${\ pi}$ (long_name = 'inflation rate')
R ${R}$ (long_name = 'interest rate')
lambda ${\ lambda}$ (long_name = 'marginal utility')
w ${w}$ (long_name = 'aggregate wage rate')
wstar ${w ^ *}$ (long_name = 'newly optimized wage rate')
Jstar ${J ^ *}$ (long_name = 'market value of labour firm')
deltaW ${\ delta_W}$ (long_name = 'family surplus from employed worker')
deltaF ${\ delta_F}$ (long_name = 'firm surplus from employed worker')
Deltastar ${\ Delta ^ *}$ (long_name = 'optimised wage wedge')
h ${h}$ (long_name = 'hours worked - based on measure 1')
mc ${mc}$ (long_name = 'marginal cost')
m ${m}$ (long_name = 'matches')
n ${n}$ (long_name = 'employment - based on measure 1')
u ${u}$ (long_name = 'unemployment - based on measure 1')
v ${v}$ (long_name = 'vacancies - based on measure 1')
s ${s}$ (long_name = 'job-finding probability')
q ${q}$ (long_name = 'vacancy-filling probability')
xL ${xL}$ (long_name = 'real competitive price for labour good')
%	Piw 		${\pi_w}$       (long_name='wage inflation rate')
%	PsiL 		${\psi_L}$       (long_name='labour profits')
// shocks
z ${z}$ (long_name = 'TFP shock process')
g ${g}$ (long_name = 'govt spending shock process')
eb ${e_b}$ (long_name = 'preference shock process')
emoney ${e_m}$ (long_name = 'MonPol shock process')
yobs ${y_{obs}}$ (long_name = 'observed output')
cobs ${c_{obs}}$ (long_name = 'observed consumption')
robs ${r_{obs}}$ (long_name = 'observed interest rate')
piobs ${\ pi_{obs}}$ (long_name = 'observed inflation rate')
% rwobs iobs labobs
;
varexo
inno_eb ${\ varepsilon_{b}}$ (long_name = 'preference shock')
inno_z ${\ varepsilon_{z}}$ (long_name = 'TFP shock')
interest_ ${\ varepsilon_{r}}$ (long_name = 'MonPol shock')
g_ ${\ varepsilon_{g}}$ (long_name = 'govt spending shock')
;
parameters
bet ${\ beta}$ (long_name = 'lifetime discount factor')
epsilon ${\ epsilon}$ (long_name = 'markup')
habit ${\ varrho}$ (long_name = 'habit persistence')
sig ${\ sigma}$ (long_name = 'risk aversion')
vphi ${\ varphi}$ (long_name = 'inverse of Frisch elasticity')
omega ${\ omega}$ (long_name = 'Calvo price stickiness')
price_index ${\ zeta_p}$ (long_name = 'degree of price indexation')
xi ${\ xi}$ (long_name = 'elasticity of matches wrt unemployment')
eta ${\ eta}$ (long_name = 'worker bargaining power')
gamma ${\ gamma}$ (long_name = 'Calvo wage stickiness')
wage_index ${\ zeta_w}$ (long_name = 'degree of wage indexation')
vtheta ${\ vartheta}$ (long_name = 'separation rate (quarterly)')
alp ${\ alpha}$ (long_name = 'labour elasticity of production')
phi_R ${\ phi_R}$ (long_name = 'interest rate smoothing')
phi_Pi ${\ phi_{\ pi}}$ (long_name = 'Taylor Rule weight on inflation')
phi_y ${\ phi_y}$ (long_name = 'Taylor Rule weight on output')
rho_z ${\ rho_{z}}$ (long_name = 'persistence of TFP shock process')
rho_eb ${\ rho_{eb}}$ (long_name = 'persistence of preference shock process')
rho_g ${\ rho_{g}}$ (long_name = 'persistence of govt spending shock process')
rho_emoney ${\ rho_{m}}$ (long_name = 'persistence of MonPol shock process')
sig_innoz ${\ sigma_{z}}$ (long_name = 'std dev of TFP shock process')
sig_innoeb ${\ sigma_{eb}}$ (long_name = 'std dev of preference shock process')
sig_innog ${\ sigma_{g}}$ (long_name = 'std dev of govt spending shock process')
sig_monpol ${\ sigma_{m}}$ (long_name = 'std dev of MonPol shock process')
ybar ${y_{ss}}$ (long_name = 'output steady-state')
hbar ${h_{ss}}$ (long_name = 'hours worked steady-state')
ubar ${u_{ss}}$ (long_name = 'unemployment steady-state')
qbar ${q_{ss}}$ (long_name = 'job-finding probability steady-state')
gbar ${g_{ss}}$ (long_name = 'govt-output ratio steady-state')
Pibar ${\ pi_{ss}}$ (long_name = 'inflation rate steady-state')
b_wh ${b_{ss}}$ (long_name = 'replacement rate steady-state')
Phi_y ${\ phi_{ss}}$ (long_name = 'fixed-cost loss-output ratio steady-state')
;

//**** * parameter values
bet = 0.9939; // time - discount factor
epsilon = 11; // own price elasticity of demand for differentiated good
habit = 0.7; // habit persistence
sig = 1.5; // CRRA
vphi = 2; // inverse of Frisch elasticity
omega = 0.4; // Calvo price stickiness [re - scaled for quarterly data]
price_index = 0; // degree of price indexation
xi = 0.5; // weight on unemployment in matching function
eta = 0.5; // bargaining power of workers
gamma = 0.5; // Calvo wage stickiness
wage_index = 0; // wage indexation
vtheta = 0.03 * 3; // rate of separation [re - scaled for quarterly data]
alp = 0.99; // labour elasticity of production
phi_R = 0.85; // interest rate smoothing
phi_Pi = 1.5; // weight on inflation
phi_y = 0.5; // weight on output
rho_eb = 0.9; // persistence of preference shock
rho_emoney = 0; // persistence of mon pol shock
rho_g = 0.7912; // persistence of gov spending shock
rho_z = 0.6712; // persistence of productivity shock
sig_innoeb = 0.3640; // std dev of preference shock
sig_monpol = 0.25; // std dev of monpol shock
sig_innog = 0.8716; // std dev of govt spending shock
sig_innoz = 0.6849; // std dev of productivity shock

//***** ** ** calibration targets
ybar = 1; // steady state output
hbar = 1/3; // steady state hours worked [re - scaled for quarterly data]
Phi_y = 0.00863; // fraction of output lost due to fixed costs.
ubar = 0.1; // steady state unemployment rate
qbar = 0.7; // probability of finding a worker in a given month
gbar = 0.347026648444032; // share of government spending in GDP (y = c + g)
b_wh = 0.4; // replacement rate
Pibar = 1; // zero inflation steady state

model_local_variable
nbar ${n_{ss}}$
mbar ${m_{ss}}$
vbar ${v_{ss}}$
sbar ${s_{ss}}$
sigmam ${\ sigma_{m}}$
thetabar ${\ theta_{ss}}$
mcbar ${mc_{ss}}$
xLbar ${xL_{ss}}$
Rbar ${R_{ss}}$
zbar ${n_{ss}}$
wbar ${w_{ss}}$
Phi ${\ Phi}$
PsiLbar ${\ Psi ^ L_{ss}}$
PsiCbar ${\ Psi ^ C_{ss}}$
Jbar ${J_{ss}}$
deltaFbar ${\ delta ^ F_{ss}}$
deltaWbar ${\ delta ^ W_{ss}}$
Deltabar ${\ Delta_{ss}}$
mrsbar ${mrs_{ss}}$
kappa ${\ kappa}$
kappaL ${\ kappa_L}$
cbar ${c_{ss}}$
lambdabar ${\ lambda_{ss}}$
Afactor ${A_{fac}}$
;

model(linear);
//***** ** ** Steady - State values for the given targets - moved inside for estimation
#nbar = 1 - ubar;
#mbar = vtheta * nbar;
#vbar = mbar / qbar;
#sbar = mbar / ubar;
#sigmam = mbar * (ubar ^ xi * vbar ^ (1 - xi)) ^ (-1);
#thetabar = vbar / ubar;
#mcbar = (epsilon - 1) / epsilon;
#xLbar = mcbar;
#Rbar = 1 / bet;
#zbar = ybar / (nbar * hbar ^ (alp));
#wbar = xLbar * zbar * alp * hbar ^ (alp - 1);
#Phi = Phi_y * ybar / nbar;
#PsiLbar = xLbar * zbar * hbar ^ (alp) - wbar * hbar - Phi;
#PsiCbar = (1 - mcbar) * ybar;
#Jbar = 1 / (1 - bet * (1 - vtheta)) * PsiLbar;
#deltaFbar = 1 / (1 - bet * (1 - vtheta) * gamma) * wbar * hbar;
#b = b_wh * wbar * hbar;
#mrsbar = (Jbar * eta / (1 - bet * (1 - vtheta) * gamma) * alp / (alp - 1) * hbar * wbar - (1 - eta) * deltaFbar / (1 - bet * (1 - vtheta - sbar)) * (wbar * hbar - b)) / (Jbar * hbar * eta / (1 - bet * (1 - vtheta) * gamma) * (-1) / (1 - alp) - (1 - eta) * deltaFbar * hbar / (1 - bet * (1 - vtheta - sbar)) * 1 / (1 + vphi));
#deltaWbar = 1 / (1 - bet * (1 - vtheta) * gamma) * hbar * 1 / (1 - alp) * (-alp * wbar - (-1) * mrsbar);
#Deltabar = 1 / (1 - bet * (1 - vtheta - sbar)) * (wbar * hbar - mrsbar * hbar / (1 + vphi) - b);
#kappa = qbar * bet * Jbar;
#cbar = ybar - kappa * vbar - Phi * nbar - gbar;
#lambdabar = (cbar * (1 - habit)) ^ (-sig);
#kappaL = mrsbar * lambdabar / hbar ^ vphi;
//- factor of proportionality between period profits and wages
#Afactor = (1 - alp) / alp * wbar * hbar / (PsiLbar);

R = ((1 - phi_R) * phi_Pi) * Pi(-1) + (1 - phi_R) * phi_y * y + phi_R * R(-1) + emoney; // Monetary policy rule
// consumption Euler equation
lambda = lambda(+1) + R + eb - Pi(+1); // Monetary policy rule
lambda =- sig / (1 - habit) * (c - habit * c(-1)); // marginal utility of consumption
Pi = price_index / (1 + bet * price_index) * Pi(-1)
+ bet / (1 + bet * price_index) * Pi(+1)
+ 1 / (1 + bet * price_index) * (1 - omega) * (1 - omega * bet) / omega * (mc); // New Keynesian Phillips curve (with inflation indexation)
mc = xL; // marginal cost
m = xi * u + (1 - xi) * v; // new matches
n = (1 - vtheta) * n(-1) + mbar / nbar * m(-1); // employment
n =- ubar / (1 - ubar) * u; // unemployment
q = m - v; // job - filling rate
s = m - u; // job - finding rate
Jstar + deltaW = Deltastar + deltaF; // newly optimized wage (wage setting FOC)
w = xL + z + (alp - 1) * h; // hours FOC
w = gamma * (w(-1) - Pi + wage_index * Pi(-1)) + (1 - gamma) * wstar; // evolution of aggregate wage
deltaF = (1 - bet * (1 - vtheta) * gamma) * (-alp / (1 - alp) * wstar + 1 / (1 - alp) * (xL + z))
+ bet * (1 - vtheta) * gamma * (-alp / (1 - alp) * (wstar + wage_index * Pi - wstar(+1) - Pi(+1))
+ deltaF(+1) + lambda(+1) - lambda); // deltaF (- \ partial surplus of firm / \ partial wage)
deltaWbar * deltaW = -alp / (1 - alp) * wbar * hbar * (-alp / (1 - alp) * wstar + 1 / (1 - alp) * (xL + z))
+ 1 / (1 - alp) * mrsbar * hbar * ((-1) * (1 + vphi) / (1 - alp) * wstar - lambda + (1 + vphi) / (1 - alp) * (xL + z))
+ bet * (1 - vtheta) * gamma / (1 - bet * (1 - vtheta) * gamma) * ((alp / (1 - alp)) ^ 2 * wbar * hbar - (1 + vphi) / (1 - alp) ^ 2 * mrsbar * hbar)
* (wstar + wage_index * Pi - wstar(+1) - Pi(+1))
+ bet * (1 - vtheta) * gamma * deltaWbar * (lambda(+1) - lambda + deltaW(+1)); // deltaW (\ partial surplus of worker / \ partial wage)
Jbar * Jstar = wbar * hbar / alp * (-alp * wstar + xL + z)
+ bet * (1 - vtheta) * gamma / (1 - bet * (1 - vtheta) * gamma) * wbar * hbar * (wstar(+1) + Pi(+1) - wstar - wage_index * Pi)
+ bet * (1 - vtheta) * Jbar * (lambda(+1) - lambda + Jstar(+1)); // value of firm that resets wage
Deltabar * Deltastar = wbar * hbar * 1 / (1 - alp) * (- alp * wstar + xL + z)
- mrsbar * hbar / (1 + vphi) * ((1 + vphi) / (1 - alp) * ((-1) * wstar + xL + z) - lambda)
+ bet * (1 - vtheta) * gamma / (1 - bet * (1 - vtheta) * gamma) * (wbar * hbar * alp / (1 - alp) - 1 / (1 - alp) * mrsbar * hbar) * (wstar(+1) + Pi(+1) - wstar - wage_index * Pi)
- bet * gamma * sbar / (1 - bet * (1 - vtheta) * gamma) * (wbar * hbar * alp / (1 - alp) - 1 / (1 - alp) * mrsbar * hbar) * (wstar(+1) + Pi(+1) - w - wage_index * Pi)
+ bet * (1 - vtheta - sbar) * Deltabar * (lambda(+1) - lambda + Deltastar(+1))
- bet * Deltabar * sbar * s; // surplus of worker who resets wage
kappa / qbar * (-q)
= bet * gamma / (1 - bet * (1 - vtheta) * gamma) * wbar * hbar * (wstar(+1) - w - wage_index * Pi + Pi(+1))
+ bet * Jbar * (lambda(+1) - lambda + Jstar(+1)); // vacancy posting condition
ybar * y = cbar * c + gbar * g + vbar * kappa * v + Phi * nbar * n; // resource constraint
y = n + z + alp * h; // production function
%Piw = Pi + w - w(-1);  // wage inflation
%PsiL  = Afactor*(w + h); // labour profits
//******** ** * ** * ** ** shocks ** * ** * ** * ** * ** * ** * ** * ** *
eb = rho_eb * eb(-1) + sig_innoeb * inno_eb; // shock to discount factor (preference shock)
g = rho_g * g(-1) + g_; // government spending shock
emoney = rho_emoney * emoney(-1) + sig_monpol * interest_; // monetary policy shock
z = rho_z * z(-1) + sig_innoz * inno_z; // productivity shock
% Measurement Equations
yobs = y;
cobs = c;
piobs = Pi;
robs = R;
end;

shocks;
var inno_eb = sig_innoeb ^ 2;
var inno_z = sig_innoz ^ 2;
var interest_ = sig_monpol ^ 2;
var g_ = sig_innog ^ 2;
end;

resid;
steady;
check;

%stoch_simul (Tex,irf = 24);

estimated_params;
omega, beta_pdf, 0.5, 0.2;
gamma, beta_pdf, 0.5, 0.2;
habit, beta_pdf, 0.5, 0.2;
xi, beta_pdf, 0.5, 0.2;
%wage_index, beta_pdf, , 0.5, 0.2; // This does not work because the starting value for wage_index is 0, which is outside the bounds
wage_index, uniform_pdf,, , 0, 1;
vtheta, beta_pdf, 0.1, 0.05;
vphi, gamma_pdf, 2, 1;
sig, gamma_pdf, 1.5, 1;
eta, beta_pdf, 0.5, 0.2;
phi_R, gamma_pdf, 0.85, 0.2;
phi_Pi, gamma_pdf, 1.5, 0.2;
phi_y, gamma_pdf, 0.5, 0.2;
rho_z, beta_pdf, 0.5, 0.2;
rho_eb, beta_pdf, 0.5, 0.2;
rho_g, beta_pdf, 0.5, 0.2;
rho_emoney, beta_pdf, 0.5, 0.2;
stderr inno_eb, inv_gamma_pdf, 1, 0.5; // implicitly estimates sig_innoeb
stderr inno_z, inv_gamma_pdf, 1, 0.5;
stderr interest_, inv_gamma_pdf, 1, 0.5;
stderr g_, inv_gamma_pdf, 1, 0.5;

end;

% Need as many shocks as observed variables !!! Here there are 4 shocks, so use only 4 observed variables
varobs yobs cobs robs piobs;
estimation(Tex, optim = ('MaxIter', 10000), datafile = 'HP1side_filter2025_HW.m', mode_compute = 4, first_obs = 89, nobs = 168, presample = 4, lik_init = 2, prefilter = 0, mh_replic = 0, mh_nblocks = 2, mh_jscale = 0.20, mh_drop = 0.2);
stoch_simul (Tex, irf = 24);

% For Tex output
% write_latex_prior_table;
% write_latex_dynamic_model;
% write_latex_parameter_table;
% write_latex_definitions;
% collect_latex_files;
% verbatim;
% cmd = sprintf('pdflatex -halt-on-error -interaction=batchmode %s_TeX_binder.tex', M_.fname);
% status = system(cmd);

% if status
%     error('TeX-File did not compile.')
% end

% end;
% CK08-estRTM model estimated with HP-filtered US data
