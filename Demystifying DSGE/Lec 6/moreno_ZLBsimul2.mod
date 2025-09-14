// Cho-Moreno model with ZLB (limits r to -2)

tic;
// # declaration of endogenous variables 
var infl, y, r rzlb;

// # declaration of exogenous variables
varexo eas, eis, emp impose_ZLB;

// # declaration of paramaters
parameters del,lam,mu,phi,roe,bet,gam,sigas,sigis,sigmp;

//parameter values
del=.5586;
lam=.0011;
mu=.4859;
phi=.0045;
roe=.8458;
bet=1.6409;
gam=.6038;
sigas=.4585;
sigis=.3734;
sigmp=.7327;

// # specification of the model equations
model(linear);

infl = del*infl(+1) + (1-del)*infl(-1) + lam*y + eas;  % Phillips Curve
y = mu*y(+1) + (1-mu)*y(-1) - phi*(rzlb-infl(+1)) + eis; % IS Curve
r = roe*r(-1) + (1-roe)*(bet*infl(+1)+gam*y) + emp;  % Taylor Rule

[mcp='rzlb>-2']                                                                  %Inequality condition/ZLB condition (the mcp-tag defines the ZLB condition)
rzlb=max(rzlb*impose_ZLB+(1-impose_ZLB)*r, -2);     %Nominal interest rate

end;

steady_state_model;
y=0;
r=0;
infl=0;
end;

// # specification of shocks
shocks;
var eas= sigas^2;
var emp=sigmp^2;
var impose_ZLB;
    periods 0:20;
    values 1;
 var eis;
    periods 0:5;
    values -0.5;
end;

%simul(periods=50);
perfect_foresight_setup(periods=50);
perfect_foresight_solver(lmmcp);

figure
subplot(4,3,1)
plot(0:49,oo_.endo_simul(strmatch('y',M_.endo_names,'exact'),M_.maximum_lag+1:M_.maximum_lag+50),'-o')
title('output')

subplot(4,3,2)
plot(0:49,oo_.endo_simul(strmatch('infl',M_.endo_names,'exact'),M_.maximum_lag+1:M_.maximum_lag+50),'-o')
title('inflation')

subplot(4,3,3)
plot(0:49,oo_.endo_simul(strmatch('r',M_.endo_names,'exact'),M_.maximum_lag+1:M_.maximum_lag+50),'-o')
title('interest rate')


toc;

%dyngraph;

