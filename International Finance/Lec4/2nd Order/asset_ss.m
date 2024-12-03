%ASSET_SS_LINEAR
function [XBAR, RHO, THETA, BETTA,eta,sig,p,pp,a,ap] = asset_ss;
%This program produces the deep structural parameters and computes the steady state of the Burnside asset pricing model as described in ``Accuracy of stochastic perturbation methods: the case of asset pricing models," by F. Collard and M. Juillard, JEDC, 25, June 2001, 979-999. Parameter values are given on p. 989. 
%
%(c) Stephanie Schmitt-Grohe and Martin Uribe

%January 22, 2002

XBAR = 0.0179; %steady state of growth rate of dividend process
 
RHO =-0.139; %persistence parameter of growth rate of dividend process

THETA = -1.5; %Curvature of single-period utility funciton

BETTA = 0.95; %subjective discount factor
sig = 1; %parameter scaling the vector of innovations

eta=0.0348; %Matrix multiplying the vector of innovations

% Steady-state price-Divident ratio, p, is the only endogenous variable
p  = BETTA * exp(THETA*XBAR)/(1-BETTA * 	exp(THETA*XBAR));

a = XBAR; %growth rate of dividend process (exogenous shock)

%Next-period variables
pp = p;
ap = a;