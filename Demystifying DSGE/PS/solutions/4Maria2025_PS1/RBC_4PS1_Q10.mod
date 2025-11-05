% Basic RBC Model with Household Work for Week 2 of Class2022, Q10

var Y, Cm, Ch, I, K, Lm, Lh, W, R, A, B, Ctot, Ltot; % Ch, Lh = home activities; Cm, Lm = market activities
varexo e, u;
parameters 
alpha ${\alpha}$ (long_name= 'Capital share')
beta ${\beta}$ (long_name= 'Discount factor')
delta ${\delta}$ (long_name= 'Depreciation rate')
gamma ${\gamma}$ (long_name= 'Preferences parameter')
omega ${\omega}$ (long_name= 'Rel wt mkt vs home')
eta ${\eta}$ (long_name= 'Goods substitution parameter')
theta ${\theta}$ (long_name= 'Home production parameter')
rho1 ${\rho1}$ (long_name= 'TFP persistence')
rho2 ${\rho2}$ (long_name= 'Home production persistence')
;
% Initial calibration
alpha = 0.35;
beta  = 0.97;
delta = 0.06;
gamma = 0.60;
omega = 0.45;
eta   = 0.80;
theta = 0.8;
rho1  = 0.95;
rho2  = 0.95;

model;
gamma*omega*(Cm^(eta-1))/(omega*Cm^eta+(1-omega)*Ch^eta)=(1-gamma)/(W*(1-Lm-Lh)); 
gamma*(1-omega)*(Ch^(eta-1))/(omega*Cm^eta+(1-omega)*Ch^eta)=(1-gamma)/(theta*B*Lh^(theta-1)*(1-Lm-Lh));
((Cm^(eta-1))/(omega*Cm^eta+(1-omega)*Ch^eta))/((Cm(+1)^(eta-1))/(omega*Cm(+1)^eta+(1-omega)*Ch(+1)^eta))=beta*(R(+1)+1-delta); 
Y = A*(K(-1)^alpha)*(Lm^(1-alpha)); 
Ch = B*Lh^theta;
K = (Y-Cm)+(1-delta)*K(-1); 
I = Y-Cm; 
W = (1-alpha)*Y/Lm;
R = alpha*Y/K;
Ctot = (omega*Cm^eta+(1-omega)*Ch^eta)^(1/eta);
Ltot = Lm + Lh;
log(A) = rho1*log(A(-1))+e; 
log(B) = rho2*log(B(-1))+u; 
end;

% Steady-state values
initval;
Y  = 0.58995;
Cm = 0.45370;
Ch = 0.34759;
Lm = 0.28550;
Lh = 0.26689; 
K = 2.27082;
I = 0.13625;
W = (1-alpha)*Y/Lm;
R = alpha*Y/K;
A = 1;
B = 1;
e = 0;
u = 0;
end;

resid;
steady;
check;

shocks;
var e; stderr 0.01;
var u; stderr 0.01;
end;

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

