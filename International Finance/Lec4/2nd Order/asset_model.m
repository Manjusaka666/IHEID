%ASSET_MODEL.M
function [nfx,nfxp,nfy,nfyp,nfypyp,nfypy,nfypxp,nfypx,nfyyp,nfyy,nfyxp,nfyx,nfxpyp,nfxpy,nfxpxp,nfxpx,nfxyp,nfxy,nfxxp,nfxx,eta] = asset_model
%This program produces the first- or second- derivative (depending on the value assigned to the variable approx) of the equilibrium conditions (function f) of the Burnside asset-pricing model as described in ``Accuracy of stochastic perturbation methods: the case of asset pricing models," by F. Collard and M. Juillard, JEDC, 25, June 2001, 979-999. 
%
%(c) Stephanie Schmitt-Grohe and Martin Uribe
%
%January 22, 2002
%
%Calls asset_ss_linear.m

approx = 2; %Order of approximation desired

%Define parameters
syms XBAR RHO THETA BETTA

%Define variables 
syms p pp a ap
     
%Write equations (e1 and e2)
e1 = -p + BETTA * (1 + pp) * exp(THETA * ap);

e2 = -ap + (1-RHO) * XBAR + RHO * a;

%Create function f
f = [e1;e2];

% Define the vector of controls, y, and states, x

x = a;

y = p;

xp = ap;

yp = pp;

%Compute analytical derivatives of f
[fx,fxp,fy,fyp,fypyp,fypy,fypxp,fypx,fyyp,fyy,fyxp,fyx,fxpyp,fxpy,fxpxp,fxpx,fxyp,fxy,fxxp,fxx]=anal_deriv(f,x,y,xp,yp,approx);
%Numerical evaluation

%Assign values to parameters and steady-state variables
[XBAR, RHO, THETA, BETTA,eta,sig,p,pp,a,ap] = asset_ss;

%Compute numerical derivatives of f
num_eval