% JP2010_Q4_Alternative.mod - Using LEVEL form for nominal exchange rate
% Key difference: Nominal exchange rate in LEVELS not differences
% This requires careful treatment of the stochastic trend

%*************************************************************************
% PREAMBLE
%*************************************************************************
var
    y c s psi q mc i pi pi_h pi_f nfa
    eps_a eps_g eps_cp eps_gs eps_rp 
    e           % Nominal ER in LEVELS
    p p_star    % Need price levels for level relationship
    y_star mc_star i_star pi_star eps_astar
    y_au pi_au i_au y_us pi_us i_us q_au s_au;

varexo
    epsilon_a epsilon_i epsilon_cp epsilon_rp epsilon_g 
    epsilon_gs epsilon_astar epsilon_istar;

parameters
    beta alpha sigma phi theta_h theta_f eta h delta_h delta_f
    rho_i psi_pi psi_y psi_e psi_dy
    chi rho_g rho_a rho_cp rho_rp
    theta_star rho_a_star rho_i_star psi_pi_star psi_y_star rho_gs;

% CALIBRATION
beta = 0.99;
alpha = 0.185;

eta = 0.6;
theta_h = 0.7;
theta_f = 0.7;
phi = 2;
sigma = 0.5;
h = 0.8;
delta_h = 0.1;
delta_f = 0.1;
chi = 0.01;

rho_i = 0.5;
psi_pi = 1.5;
psi_y = 0.5;
psi_dy = 0.10;
psi_e = 0.2;

rho_g = 0.5;
rho_a = 0.5;
rho_cp = 0.5;
rho_rp = 0.5;
rho_gs = 0.5;
rho_a_star = 0.5;

theta_star = 0.7;
rho_i_star = 0.5;
psi_pi_star = 1.5;
psi_y_star = 0.25;

model_local_variable
lambda_h lambda_f lambda_star;

%*************************************************************************
% MODEL
%*************************************************************************
model(linear);
    # lambda_h = ((1-beta*theta_h)*(1-theta_h))/theta_h;
    # lambda_f = ((1-beta*theta_f)*(1-theta_f))/theta_f;
    # lambda_star = ((1-beta*theta_star)*(1-theta_star))/theta_star;
    
    % Domestic Euler Equation (eq. 14)
    c - h*c(-1) = c(+1) - h*c - (1/sigma)*(1-h)*(i - pi(+1)) 
                  + (1/sigma)*(1-h)*(eps_g - eps_g(+1));
    
    % Goods market clearing (eq. 15)
    (1 - alpha)*c = y - alpha*eta*(2 - alpha)*s - alpha*eta*psi - alpha*y_star;
    
    % Terms of trade (eq. 16)
    s - s(-1) = pi_f - pi_h;
    
    % NOMINAL EXCHANGE RATE - LEVEL FORM (eq. 17 LHS literal interpretation)
    % Paper states: q_t = e_t + p*_t - p_t
    % In levels (all in log deviations from steady state):
    q = e + p_star - p;
    
    % Price level accumulation (needed for level form)
    p = p(-1) + pi;
    p_star = p_star(-1) + pi_star;
    
    % Real exchange rate and LOOP gap (eq. 17 RHS)
    q = psi + (1-alpha)*s;
    
    % Domestic inflation (eq. 18)
    pi_h - delta_h*pi_h(-1) = lambda_h*mc + beta*(pi_h(+1) - delta_h*pi_h);
    
    % Domestic marginal cost
    mc = phi*y - (1+phi)*eps_a + alpha*s + (sigma/(1-h))*(c-h*c(-1));
    
    % Imported inflation (eq. 19)
    pi_f - delta_f*pi_f(-1) = lambda_f*psi + beta*(pi_f(+1) - delta_f*pi_f) + eps_cp;
    
    % CPI inflation (eq. 20)
    pi = pi_h + alpha*(s - s(-1));
    
    % Uncovered interest parity (eq. 21)
    (i - pi(+1)) - (i_star - pi_star(+1)) = q(+1) - q - chi*nfa - eps_rp;
    
    % Flow budget constraint (eq. 22)
    c + nfa = (1/beta)*nfa(-1) - alpha*(s + psi) + y;
    
    % Monetary policy rule (eq. 23)
    % Note: Using Δe in levels means e - e(-1)
    i = rho_i*i(-1) + psi_pi*pi + psi_y*y + psi_dy*(y - y(-1)) 
        + psi_e*(e - e(-1)) + epsilon_i;
    
    % Foreign sector
    y_star - h*y_star(-1) = y_star(+1) - h*y_star 
                           - (1/sigma)*(1-h)*(i_star - pi_star(+1)) 
                           + eps_gs - eps_gs(+1);
    
    pi_star = lambda_star*mc_star + beta*pi_star(+1);
    
    mc_star = phi*y_star + alpha*s - (1+phi)*eps_astar 
              + (sigma/(1-h))*(y_star-h*y_star(-1));
    
    i_star = rho_i_star*i_star(-1) + psi_pi_star*pi_star 
             + psi_y_star*y_star + epsilon_istar;
    
    % Exogenous processes
    eps_g = rho_g*eps_g(-1) + epsilon_g;
    eps_gs = rho_gs*eps_gs(-1) + epsilon_gs;
    eps_a = rho_a*eps_a(-1) + epsilon_a;
    eps_cp = rho_cp*eps_cp(-1) + epsilon_cp;
    eps_astar = rho_a_star*eps_astar(-1) + epsilon_astar;
    eps_rp = rho_rp*eps_rp(-1) + epsilon_rp;
    
    % MEASUREMENT EQUATIONS
    y_au = y;
    pi_au = pi;
    i_au = i;
    q_au = q - q(-1);      % Data is in first differences
    s_au = s - s(-1);      % Data is in first differences
    y_us = y_star;
    pi_us = pi_star;
    i_us = i_star;
end;

shocks;
    var epsilon_a; stderr 1;
    var epsilon_i; stderr 1;
    var epsilon_cp; stderr 1;
    var epsilon_rp; stderr 1;
    var epsilon_g; stderr 1;
    var epsilon_gs; stderr 1;
    var epsilon_astar; stderr 1;
    var epsilon_istar; stderr 1;
end;

steady;
check;

%*************************************************************************
% ESTIMATED PARAMETERS
%*************************************************************************
estimated_params;
    sigma, gamma_pdf, 1.2, 0.4;
    phi, gamma_pdf, 1.5, 0.5;
    theta_h, beta_pdf, 0.5, 0.1;
    theta_f, beta_pdf, 0.5, 0.1;
    eta, gamma_pdf, 1.5, 0.5;
    h, beta_pdf, 0.5, 0.25;
    delta_h, beta_pdf, 0.5, 0.25;
    delta_f, beta_pdf, 0.5, 0.25;
    
    rho_i, beta_pdf, 0.75, 0.1;
    psi_pi, gamma_pdf, 1.5, 0.25;
    psi_y, gamma_pdf, 0.25, 0.13;
    psi_e, gamma_pdf, 0.25, 0.13;
    psi_dy, gamma_pdf, 0.25, 0.13;
    
    theta_star, beta_pdf, 0.5, 0.1;
    rho_i_star, beta_pdf, 0.75, 0.1;
    psi_pi_star, gamma_pdf, 1.5, 0.25;
    psi_y_star, gamma_pdf, 0.25, 0.13;
    
    rho_a, beta_pdf, 0.8, 0.1;
    rho_g, beta_pdf, 0.8, 0.1;
    rho_rp, beta_pdf, 0.8, 0.1;
    rho_gs, beta_pdf, 0.8, 0.1;
    rho_a_star, beta_pdf, 0.8, 0.1;
    
    chi, gamma_pdf, 0.01, 0.005;
    
    stderr epsilon_a, inv_gamma_pdf, 1, inf;
    stderr epsilon_i, inv_gamma_pdf, 1, inf;
    stderr epsilon_cp, inv_gamma_pdf, 1, inf;
    stderr epsilon_rp, inv_gamma_pdf, 1, inf;
    stderr epsilon_g, inv_gamma_pdf, 1, inf;
    stderr epsilon_gs, inv_gamma_pdf, 1, inf;
    stderr epsilon_astar, inv_gamma_pdf, 1, inf;
    stderr epsilon_istar, inv_gamma_pdf, 1, inf;
end;

varobs y_au pi_au i_au q_au s_au y_us pi_us i_us;

estimation(
    datafile=JP_Australian_Data,
    first_obs=9,
    presample=4,
    prefilter=1,
    mode_compute=4,
    mh_replic=0,
    tex
);

stoch_simul(irf=24) y c i pi pi_h pi_f e nfa mc;