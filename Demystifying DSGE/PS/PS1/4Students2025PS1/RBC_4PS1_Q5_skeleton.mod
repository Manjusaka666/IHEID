% Basic RBC Model 1 for Week 3 of Class2022, Q5

%----------------------------------------------------------------
%      Block 1: Defining variables
%----------------------------------------------------------------
var Y, C, I, K, L, W, R, A;
varexo e;
parameters
alpha ${\alpha}$ (long_name= 'Capital share')
beta ${\beta}$ (long_name= 'Discount factor')
delta ${\delta}$ (long_name= 'Depreciation rate')
gamma ${\gamma}$ (long_name= 'Preferences parameter')
rho ${\rho}$ (long_name= 'TFP persistence')
;

%-------------------------------------------------------------
%     Block 2: Calibration
%----------------------------------------------------------------
alpha = 0.35;
beta  = 0.97;
delta = 0.06;
gamma = 0.40;
rho   = 0.95;

%*********************************************
%      Block 3: The model
%*********************************************
model;
... % Euler Equation
... % Production Function
... % Labour Supply Function
... % Resource Constraint
K = I+(1-delta)*K(-1);
W = (1-alpha)*A*(K(-1)^alpha)*(L^(-alpha));
R = alpha*A*(K(-1)^(alpha-1))*(L^(1-alpha));
log(A) = rho*log(A(-1))+ e;
end;


%**********************************************
%       Block 4: Initial values
%**********************************************
initval;
Y = 0.75; 
C = 0.57; 
L = 0.36; 
K = 2.87;
I = 0.17;
W = (1-alpha)*Y/L;
R = alpha*Y/K;
A = 1;
e = 0;
end;

%**********************************************
%       Block 5: Computing the Steady state
%       and its uniqueness
%**********************************************

% Steady-state values
steady;

% Checking Blanchard-Kahn rank condition
check;

%**********************************************
%       Block 6: Shocks
%**********************************************

% Perturbation
shocks;
var e; stderr 0.01; % since a = log(A), this is effectively a 1% shock to productivity (AS shock)
end;

%**********************************************
%       Block 7: Simulating the model
%**********************************************

% Stochastic simulation

stoch_simul(Tex,irf=40);

%----------------------------------------------------------------
% generate LaTeX output
% use only if you have LaTex installed
%----------------------------------------------------------------

write_latex_dynamic_model;
write_latex_parameter_table;
write_latex_definitions;
write_latex_prior_table;
collect_latex_files;
if system(['pdflatex -halt-on-error -interaction=batchmode ' M_.fname '_TeX_binder.tex'])
    error('TeX-File did not compile.')
end
