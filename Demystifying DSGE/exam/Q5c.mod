% Open-economy New Keynesian model by Central Bank of Brazil

%----------------------------------------------------------------
% 0. Housekeeping (close all graphic windows)
%----------------------------------------------------------------
close all;

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------
var
% Domestic variables
y ${y}$ (long_name = 'Domestic output')
c ${c}$ (long_name = 'Domestic consumption')
s ${s}$ (long_name = 'Terms of Trade')
q ${q}$ (long_name = 'Real ER')
r ${r}$ (long_name = 'Domestic interest rate')
pi ${\ pi}$ (long_name = 'Domestic CPI inflation rate')
pi_h ${\ pi_H}$ (long_name = 'Domestic goods inflation')
pi_f ${\ pi_F}$ (long_name = 'Imported inflation')
eps_a ${\ varepsilon_{a}}$ (long_name = 'Domestic technology shock process')
eps_r ${\ varepsilon_{r}}$ (long_name = 'Domestic interest rate shock process')
eps_q ${\ varepsilon_{q}}$ (long_name = 'ER shock process')
eps_s ${\ varepsilon_{s}}$ (long_name = 'TOT shock process')
e ${e}$ (long_name = 'Nominal ER')
de ${\ Delta e}$ (long_name = 'Nominal ER Depreciation')
%Foreign variables
y_star ${y ^ *}$ (long_name = 'Foreign output')
r_star ${r ^ *}$ (long_name = 'Foreign interest rate')
pi_star ${\ pi ^ *}$ (long_name = 'Foreign CPI inflation')
%Observed variables
y_obs
yst_obs
r_obs
pi_obs
q_obs
s_obs
pif_obs
rst_obs
;

varexo
e_q ${e_{q}}$ (long_name = 'UIP Risk Premium shock')
e_r ${e_{r}}$ (long_name = 'domestic interest rate shock')
e_a ${e_{a}}$ (long_name = 'domestic technology shock')
e_s ${e_{s}}$ (long_name = 'TOT shock')
e_y_star ${e_{y ^ *}}$ (long_name = 'foreign output shock')
e_pi_star ${e_{\ pi ^ *}}$ (long_name = 'foreign inflation shock')
e_r_star ${e_{r ^ *}}$ (long_name = 'foreign interest rate shock')
;

parameters
% Domestic parameters
beta ${\ beta}$ (long_name = 'lifetime discount factor')
sigma ${\ sigma}$ (long_name = 'inverse elast intertemp substn')
phi ${\ varphi}$ (long_name = 'inverse elast intertemp labour supply')
h ${h}$ (long_name = 'degree of habit persistence')
eta ${\ eta}$ (long_name = 'elast substn betw dom and import goods')
alpha ${\ alpha}$ (long_name = 'share of foreign goods in consumption')
theta_h ${\ theta_{H}}$ (long_name = 'domestic producer Calvo parameter')
theta_f ${\ theta_{F}}$ (long_name = 'importer Calvo parameter')
rho_a ${\ rho_{a}}$ (long_name = 'technology persistence')
rho_s ${\ rho_{s}}$ (long_name = 'TOT persistence')
rho_q ${\ rho_{q}}$ (long_name = 'ER persistence')
rho_r ${\ rho_{r}}$ (long_name = 'interest rate persistence')
delta_h ${\ delta_{H}}$ (long_name = 'indexation to domestic inflation')
delta_f ${\ delta_{F}}$ (long_name = 'indexation to import inflation')

% Domestic monetary policy parameters
psi_r ${\ psi_{r}}$ (long_name = 'interest rate response')
psi_pi ${\ psi_{\ pi}}$ (long_name = 'inflation response')
psi_y ${\ psi_{y}}$ (long_name = 'output gap response')
psi_de ${\ psi_{de}}$ (long_name = 'nominal ER response')

% All foreign parameters
a1 ${a_1}$ (long_name = 'foreign inflation persistence')
b1 ${b_1}$ (long_name = 'foreign output persistence')
c1 ${c_1}$ (long_name = 'foreign interest rate persistence')
;

model_local_variable
lambda_h ${\ lambda_{h}}$
lambda_f ${\ lambda_{f}}$
;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------
beta = 0.994535; % discount factor calibrated to match realized real interest rate
alpha = 0.19; %share of import in domestic consumption
h = 0.7; %habit persistence
sigma = 0.5; %inverse elasticity of substitution
phi = 2; %inverse elasticity of labour supply
eta = 0.6; %elasticity of subtitution between home and foreign goods
delta_h = 0.8; %degree of indexation of home produced goods (equals 80 % of lagged home inflation)
delta_f = 0.8; %degree of indexation of imported goods (equals 80 % of lagged foreign inflation)
theta_h = 0.5; %Calvo domestic prices
theta_f = 0.5; %Calvo foreign prices
a1 = 0.5; %Persistence of foreign inflation
b1 = 0.5; %Persistence of foreign output
c1 = 0.5; %Persistence of foreign nominal interest rate
rho_a = 0.8; %Persistence of technology shock
rho_s = 0.8; %Persistence of terms-of-trade shock
rho_q = 0.8; %Persistence of exchange rate shock
rho_r = 0.1; % Persistence of monetary policy shock
% rho_r = 0.8;
psi_r = 0.5; %Taylor rule smoothing parameter
psi_pi = 1.5; %Taylor rule coefficient on inflation
psi_de = 0.25/4; %Taylor rule coefficient on ER depreciation (adjusted to quarterly interest rate)
psi_y = 0.25/4; %Taylor rule coefficient on output gap (adjusted to quarterly interest rate)

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------
model(linear);
#lambda_h = ((1 - beta * theta_h) * (1 - theta_h)) / theta_h;
#lambda_f = ((1 - beta * theta_f) * (1 - theta_f)) / theta_f;
c - h * c(-1) = y_star - h * y_star(-1) + (1 / sigma) * (1 - h) * q; % (Revised) equation 34
pi_h = beta * (pi_h(+1) - delta_h * pi_h) + delta_h * pi_h(-1) + lambda_h * (phi * y - (1 + phi) * eps_a + alpha * s + (sigma / (1 - h)) * (c - h * c(-1))); %Domestic goods inflation eq.35
pi_f = beta * (pi_f(+1) - delta_f * pi_f) + delta_f * pi_f(-1) + lambda_f * (q - (1 - alpha) * s); % Imports inflation eq.36
q(+1) - q = (r - pi(+1)) - (r_star - pi_star(+1)) + eps_q; %real interest rate parity condition eq.37
s - s(-1) = pi_f - pi_h + eps_s; % TOT eq. 38
y = (1 - alpha) * c + alpha * eta * q + alpha * eta * s + alpha * y_star; %Market clearing condition eq.39
pi = (1 - alpha) * pi_h + alpha * pi_f; %Total CPI inflation eq. 40
r = psi_r * r(-1) + (1 - psi_r) * (psi_pi * pi + psi_y * y) + eps_r; %Taylor rule equation 26
%  + psi_de * (e - e(-1))
%Variables definition
de = e - e(-1); %Depreciation rate definition
q - q(-1) = de + pi_star - pi; %Link between real and nominal exchange rate
%Shock processes
eps_r = rho_r * eps_r(-1) + e_r;
eps_s = rho_s * eps_s(-1) + e_s;
eps_q = rho_q * eps_q(-1) + e_q;
eps_a = rho_a * eps_a(-1) + e_a;

%Foreign variables AR(1) processes
pi_star = a1 * pi_star(-1) + e_pi_star;
y_star = b1 * y_star(-1) + e_y_star;
r_star = c1 * r_star(-1) + e_r_star;
%Observation equations
y_obs = y;
yst_obs = y_star;
r_obs = 4 * r;
pi_obs = 4 * pi;
q_obs = q;
s_obs = s;
pif_obs = 4 * pi_star;
rst_obs = 4 * r_star;

end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------
shocks;
var e_r; stderr 1;
var e_q; stderr 1;
var e_a; stderr 1;
var e_s; stderr 1;
var e_y_star; stderr 1;
var e_pi_star; stderr 1;
var e_r_star; stderr 1;
end;

resid;
steady;
check;

% stoch_simul(Tex, irf = 20) y pi r q s e pi_h pi_f;
%----------------------------------------------------------------
% 5. Estimation
%----------------------------------------------------------------
%*************************************************************************
% ESTIMATED PARAMETERS
%*************************************************************************

estimated_params;
alpha, beta_pdf, 0.5, 0.2;
eta, gamma_pdf, 1.5, 1;
theta_h, beta_pdf, 0.5, 0.2;
theta_f, beta_pdf, 0.5, 0.2;
phi, gamma_pdf, 1.5, 1;
sigma, gamma_pdf, 1.5, 1;
h, beta_pdf, 0.5, 0.2;
delta_h, beta_pdf, 0.5, 0.2;
delta_f, beta_pdf, 0.5, 0.2;
% ...
psi_r, beta_pdf, 0.5, 0.2;
psi_pi, normal_pdf, 1.5, 0.5;
psi_y, normal_pdf, 0.25, 0.1;
psi_de, normal_pdf, 0.2, 0.1;

rho_a, beta_pdf, 0.5, 0.2;
rho_s, beta_pdf, 0.5, 0.2;
rho_q, beta_pdf, 0.5, 0.2;
rho_r, beta_pdf, 0.5, 0.2;
% ...
c1, beta_pdf, 0.5, 0.2;
b1, beta_pdf, 0.5, 0.2;
a1, beta_pdf, 0.5, 0.2;

stderr e_r, inv_gamma_pdf, 1, inf;
stderr e_q, inv_gamma_pdf, 1, inf;
stderr e_a, inv_gamma_pdf, 1, inf;
stderr e_s, inv_gamma_pdf, 1, inf;
stderr e_y_star, inv_gamma_pdf, 1, inf;
stderr e_pi_star, inv_gamma_pdf, 1, inf;
stderr e_r_star, inv_gamma_pdf, 1, inf;
end;

estimated_params_init(use_calibration);
end;

%*************************************************************************
% OBSERVED VARIABLES
%*************************************************************************
varobs y_obs yst_obs r_obs pi_obs rst_obs pif_obs;

%*************************************************************************
% ESTIMATION
%*************************************************************************
estimation(Tex, datafile = Data4Exam, first_obs = 1, kalman_algo = 4, prefilter = 1, mode_compute = 1, mh_replic = 0) y pi r q s e pi_h pi_f;

stoch_simul(Tex, irf = 24);

/*
%----------------------------------------------------------------
% generate LaTeX output
%----------------------------------------------------------------
write_latex_dynamic_model;
write_latex_parameter_table;
write_latex_definitions;
write_latex_prior_table;
collect_latex_files;
% delete the next command if you do not have a Tex app installed
if system(['pdflatex -halt-on-error -interaction=batchmode ' M_.fname '_TeX_binder.tex'])
    error('TeX-File did not compile.')
end

*/
