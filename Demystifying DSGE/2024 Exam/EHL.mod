% EHL 2000 model
% based on: Erceg, Henderson and Levin (2000) 
% "Optimal Monetary Policy with Staggered Wage and Price Contracts" 
% Journal of Monetary Economics, 46 (March), pp. 281-313

var g mpl mrs pi w rw yn rn rwn i x z u ms; 
% var yobs iobs wobs pipobs
varexo ex ez eu ems;
parameters beta alpha chi sigma  phipi phiy rhor rhox rhoz rhou xip xiw thetaw
Lss Uss Zss Yss Css l_barL  l_barZ  l_barC  l_barU ;

beta  =  0.975;
alpha  =  0.3;
sigma       =   1.5;
chi       =   1.5;
xip  =  0.5;
xiw  =  0.75;
thetaw      =   0.75;
rhor        =   0.9;
rhox        =   0.75;
rhoz        =   0.75;
rhou        =   0.25;
phipi    =   1.5;
phiy   =   0.5;
Lss  =  0.27;
Uss  =  0.3163;
Zss  =  0.03;
Yss  =  10*Uss;
Css  =  Yss;
l_barL = ...;
l_barZ = ...;
…

model(linear);
#bigLambda = alpha + chi*l_barL + (1-alpha)*sigma*l_barC;
#kappa_p = (1 - xip*beta)*(1 - xip)/xip;
#kappa_w = (1 - xiw*beta)*(1 - xiw)/(xiw*(1 + chi*l_barL*(1 + thetaw)/thetaw));
#psi_yn1 = (1-alpha)*sigma*l_barU/bigLambda;
#psi_yn2 = (1-alpha)*chi*l_barZ/bigLambda;
#psi_rwn1 = -alpha*sigma*l_barU/bigLambda;
#psi_rwn2 = alpha*chi*l_barZ/bigLambda;
#tau1 = chi*l_barL/bigLambda;
#tau2 = (chi*l_barL + alpha*l_barC)/bigLambda;

g = g(+1) -(1/sigma*l_barC)*(i - pi(+1) - rn);
…
rn = sigma*l_barC*(yn(+1)-yn) + sigma*l_barU*(u(+1)-u);
yn = psi_yn1*u - psi_yn2*z + (1 + tau1)*x;
...
%Observation equations
%yobs=g;
...
end;

resid(1);
steady;
check;

shocks;
var ex  =   0.05;
var ez  =   0.05;
var eu  = 0.05;
var ems  =   0.05;
end;

stoch_simul(irf=24) g pi w i;

/*
estimated_params;
	thetaw, beta_pdf,0.75,0.1;
...
stderr ex, inv_gamma_pdf, 0.05, 4;
...
end;

% estimate over period 1971Q1-2015Q4
estimation(Tex,datafile=Data4Exam_jc1,xls_sheet=...
stoch_simul(Tex,order=1,irf=24) pi g w i;
*/