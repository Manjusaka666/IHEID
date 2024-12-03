%NEOCLASSICAL_MODEL_RUN.M
%This program computes a second-order  approximation to the policy functions of a simple neoclassical model (see ``Solving Dynamic General Equilibrium Models Using a Second-Order Approximation to the Policy Function,'' by Stephanie Schmitt-Grohe and Martin Uribe, (JEDC, 2004, p. 755-775). The equilibrium conditions of the model can be written as: %E_t[f(yp,y,xp,x)=0, 
%The solution is of the form
%xp = h(x,sigma) + sigma* eta * ep
%y = g(x,sigma)
%The quadratic approximation to these functions are (in tensor notation) [Notation: x is x_t and xp is x_t+1, variables are expressed in log-deviations from their steady state value]
%xp^i = hx^i_a x_a + 1/2 [hxx^i_ab x_a x_b + hss^i sigma^2] + sigma*  eta^i_c ep_c
%y^i = gx^i_a x_a + 1/2 [gxx^i_ab x_a x_b + gss^i sigma^2]
%
%where 
% hx is nx by nx
% gx is ny by nx
% hxx is nx by nx by nx
% gxx is ny by nx by nx
% eta is nx by ne
% gss is ny by 1
% hss is nx by 1
% sigma is a positive scalar
%Calls: neoclassical_model.m num_eval.m  neoclassical_model_ss.m gx_hx.m gxx_hxx.m gss_hss.m
% 
%(c) Stephanie Schmitt-Grohe and Martin Uribe
%Date July 17, 2001, revised 22-Oct-2004

[fx,fxp,fy,fyp,fypyp,fypy,fypxp,fypx,fyyp,fyy,fyxp,fyx,fxpyp,fxpy,fxpxp,fxpx,fxyp,fxy,fxxp,fxx,f] = neoclassical_model;

%Numerical Evaluation
%Steady State and Parameter Values
[SIG,DELTA,ALFA,BETTA,RHO,eta,c,cp,k,kp,a,ap,A,K,C]=neoclassical_model_ss;

%Order of approximation desired 
approx = 2;

%Obtain numerical derivatives of f
num_eval

%First-order approximation
[gx,hx] = gx_hx(nfy,nfx,nfyp,nfxp)

%Second-order approximation
[gxx,hxx] = gxx_hxx(nfx,nfxp,nfy,nfyp,nfypyp,nfypy,nfypxp,nfypx,nfyyp,nfyy,nfyxp,nfyx,nfxpyp,nfxpy,nfxpxp,nfxpx,nfxyp,nfxy,nfxxp,nfxx,hx,gx) 

[gss,hss] = gss_hss(nfx,nfxp,nfy,nfyp,nfypyp,nfypy,nfypxp,nfypx,nfyyp,nfyy,nfyxp,nfyx,nfxpyp,nfxpy,nfxpxp,nfxpx,nfxyp,nfxy,nfxxp,nfxx,hx,gx,gxx,eta)