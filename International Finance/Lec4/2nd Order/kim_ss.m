function [GAMA, DELTA, ALFA, RHO, BETTA, c, cp, k1, k1p, k2, k2p, a1, a1p, a2, a2p] = kim_ss
%This program produces the deep structural parameters and computes the steady state of a 2-country neoclassical growth model with complete asset markets described in ``Spurious Welfare Reversals in International Business Cycle Models,'' by J. Kim and S. H. Kim, forthcoming in the Journal of International Economics.  
%(c) Stephanie Schmitt-Grohe and Martin Uribe

%January 21, 2002

GAMA = 2; 

DELTA = 0.1; %Depreciation rate

ALFA = 0.3; %Capital elasticity of the production function

RHO = 0; %Serial correlation of productivity shock

BETTA = 0.95;

k1 = (( BETTA^(-1) - 1 + DELTA ) / ALFA)^(1/ (ALFA-1)); 

k2 = k1;

c = k1^(ALFA) - DELTA * k1;

a1 = 1;

a2 = 1; 

%Take logs
c = log(c);
k1 = log(k1);
k2 = log(k2);
a1 = log(a1);
a2 = log(a2);

%Next-period variables
cp = c;
k1p = k1;
k2p = k2;
a1p = a1;
a2p = a2;