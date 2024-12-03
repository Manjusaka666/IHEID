function [nfx,nfxp,nfy,nfyp,nfypyp,nfypy,nfypxp,nfypx,nfyyp,nfyy,nfyxp,nfyx,nfxpyp,nfxpy,nfxpxp,nfxpx,nfxyp,nfxy,nfxxp,nfxx] = kim_model
%This economy is taken from  ``Spurious welfare reversals in international business cycle models,'' Journal of International Economics, 60,  August 2003, 471-500, by Jinill Kim and Sunghyun Henry Kim.

approx = 2; %Order of approximation desired

%Define parameters
syms GAMA DELTA ALFA RHO BETTA

%Define variables 
syms c cp k1 k1p k2 k2p a1 a1p a2 a2p     
%Write equations (e1 e2 e3 e4 e5)
e1 = c^(-GAMA) - BETTA * cp^(-GAMA) * (ALFA * a1p * k1p^(ALFA-1) + 1 - DELTA);

e2 = c^(-GAMA) - BETTA * cp^(-GAMA) * (ALFA * a2p * k2p^(ALFA-1) + 1 - DELTA);

e3 = 2 * c + k1p - (1-DELTA) * k1 + k2p - (1-DELTA) * k2 - a1 * k1^(ALFA) - a2 * k2^(ALFA);

e4 = log(a1p) - RHO * log(a1);

e5 = log(a2p) - RHO * log(a2);

%Create function f
f = [e1;e2;e3;e4;e5];

% Define the vector of controls, y, and states, x

x = [k1 k2 a1 a2];

y = c;

xp = [k1p k2p a1p a2p];

yp = cp;

%Make f a function of the logarithm of the state and control vector (Note: this step, which greatly facilitates keying in the model, does not appear in neoclassical_model.m)
f = subs(f, [x,y,xp,yp], exp([x,y,xp,yp]));

%Compute analytical derivatives of f
[fx,fxp,fy,fyp,fypyp,fypy,fypxp,fypx,fyyp,fyy,fyxp,fyx,fxpyp,fxpy,fxpxp,fxpx,fxyp,fxy,fxxp,fxx]=anal_deriv(f,x,y,xp,yp,approx);
%Numerical evaluation

%Assign values to parameters and steady-state variables

[GAMA, DELTA, ALFA, RHO, BETTA, c, cp, k1, k1p, k2, k2p, a1, a1p, a2, a2p] = kim_ss;

%Evaluate derivatives of f
num_eval