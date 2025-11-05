% Basic RBC Model 1 for Week 3 of Class2020

var Y, C, I, K, L, W, R, A;
varexo e;
parameters
alpha ${\alpha}$ (long_name= 'Capital share')
beta ${\beta}$ (long_name= 'Discount factor')
delta ${\delta}$ (long_name= 'Depreciation rate')
gamma ${\gamma}$ (long_name= 'Preferences parameter')
rho ${\rho}$ (long_name= 'TFP persistence')
;
% Initial calibration
alpha = 0.35;
beta  = 0.97;
delta = 0.06;
gamma = 0.40;
rho   = 0.95;

model;
(C(+1)/C) = beta*(R(+1)+(1-delta)); % Euler Equation
Y = A*(K(-1)^alpha)*(L^(1-alpha)); % Production Function
C=(gamma/(1-gamma))*(1-L)*(1-alpha)*Y/L; % Labour Supply Function
I = Y-C; % Resource Constraint
K = I+(1-delta)*K(-1);
W = (1-alpha)*A*(K(-1)^alpha)*(L^(-alpha));
R = alpha*A*(K(-1)^(alpha-1))*(L^(1-alpha));
log(A) = rho*log(A(-1))+ e;
end;

% Steady-state values
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

resid;
steady;
check;

shocks;
var e; stderr 0.01;
end;

stoch_simul(Tex,irf=40);

write_latex_parameter_table;
write_latex_dynamic_model;
write_latex_definitions;
collect_latex_files;
if system(['pdflatex -halt-on-error -interaction=batchmode ' M_.fname '_TeX_binder.tex'])
    error('TeX-File did not compile.')
end
