% Model used in Dynare Handout 2025
% Endogenous variables:
var 
    y           ${y}$           (long_name='Output')
    c           ${c}$           (long_name='Consumption')
    i        ${i}$           (long_name='Investment')
    k           ${k}$       (long_name='Capital stock') 
    n         ${n}$           (long_name='Hours worked')
    r           ${r}$           (long_name='Nominal interest rate')
    a           ${\varepsilon_a}$       (long_name='Productivity process')
;
% Changing the timing convention
predetermined_variables k;
% Shocks
varexo e;
% Parameters of the model
parameters 
alpha   ${\alpha}$  (long_name='capital share') 
rho    ${\rho}$  (long_name='persistence of TFP shock') 
beta    ${\beta}$   (long_name='discount factor') 
delta   ${\delta}$  (long_name='depreciation rate') 
eta   ${\eta}$  (long_name='risk aversion')
Yss_Kss	${\frac{Yss}{Kss}}$ (long_name='SS output-capital ratio') 
Iss_Kss	${\frac{Iss}{Kss}}$ (long_name='SS investment-capital ratio') 
Iss_Yss	${\frac{Iss}{Yss}}$ (long_name='SS investment-output ratio') 
Css_Yss ${\frac{Css}{Yss}}$ (long_name='SS consumption-output ratio')
Rss		${Rss}$ (long_name='SS return on capital')
;
% Calibration
alpha = 0.33;
rho   = 0.95;
beta  = 0.99;
delta = .015;
eta   = 1;
Rss = 1/beta;
Yss_Kss = ((1/beta)+delta-1)/alpha;
Iss_Kss = delta;
Iss_Yss = (Iss_Kss)/(Yss_Kss);
Css_Yss = 1 - (Iss_Yss);
% Dynamic Equations
model;
[name='Production Function'] 
    	y = a + alpha*k + (1 - alpha)*n;
[name='Euler equation']
    	c = c(+1) - (1/eta)*r(+1);
[name='Labour FOC']
    	n = y - eta*c;
[name='Law of motion of capital']
	k(+1) = (Iss_Kss)*i + (1 - delta)*k;
[name='Resource Constraint'] 
	y = (Css_Yss)*c + (Iss_Yss)*i;
[name='Real interest rate/firm FOC capital'] 
	r = (alpha*(Yss_Kss)/Rss)*(y - k);
[name='Exogenous TFP process'] 
    	a = rho*a(-1) + e;
end;
% Steady-State
resid;
steady;
% Check Blanchard-Kahn conditions
check;
% Shocks of the model
% In Dynare, these shocks follow a normal distribution with zero mean and standard error given by user here
shocks;
var e; 
stderr 0.1; % ==> variance = .01 (ie, 1% in a log-linearised model)
end;
% Stochastic Simulation
stoch_simul(Tex,irf=100,order=1) y, c, i, k, n, r, a;
/*
%----------------------------------------------------------------
% Generate LaTeX output
%----------------------------------------------------------------
write_latex_original_model;
write_latex_parameter_table;
write_latex_definitions;
write_latex_prior_table;
collect_latex_files;
% delete the next command if you do not have a Tex app installed
if system(['pdflatex -halt-on-error -interaction=batchmode ' M_.fname '_TeX_binder.tex'])
    error('TeX-File did not compile.')
end
*/