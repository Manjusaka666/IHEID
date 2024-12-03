%NEOCLASSICAL_MODEL_SS.M
function [SIG,DELTA,ALFA,BETTA,RHO,eta,c,cp,k,kp,a,ap,A,K,C]=neoclassical_model_ss
%This program produces the the deep structural parameters and computes the steady state of the simple neoclassical growth model described in section 2.1 of ``Solving Dynamic General Equilibrium Models Using a Second-Order Approximation to the Policy Function,'' by Stephanie Schmitt-Grohe and Martin Uribe, (2001). 
%
%(c) Stephanie Schmitt-Grohe and Martin Uribe
%Date July 17, 2001, revised 22-Oct-2004

BETTA=0.95; %discount rate
DELTA=1; %depreciation rate
ALFA=0.3; %capital share
RHO=0; %persistence of technology shock
SIG=2; %intertemporal elasticity of substitution
eta=[0 1]'; %Matrix defining driving force


A = 1; %steady-state value of technology shock 
K = ((1/BETTA+DELTA-1)/ALFA)^(1/(ALFA-1)); %steady-state value of capital
C = A * K^(ALFA)-DELTA*K; %steady-state value of consumption 
a = log(A); 
k = log(K);
c = log(C);


ap=a;
kp=k;
cp = c;