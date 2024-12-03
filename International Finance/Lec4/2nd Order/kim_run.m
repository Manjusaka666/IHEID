%This program computes a second-order  approximation to the policy functions of a 2-country neoclassical growth model with complete asset markets described in ``Spurious Welfare Reversals in International Business Cycle Models,'' by J. Kim and S. H. Kim, forthcoming in the Journal of International Economics. The reduced form of the model can be written as: %E_t[f(yp,y,xp,x)=0, 

%The solution is of the form

%xp = h(x,sigma) + sigma* eta * ep

%y = g(x,sigma)

%The quadratic approximation to these functions are (in tensor notation) [Notation: x is x_t and xp is x_t+1, variables are expressed in log-deviations from their steady state value]

%xp^i = hx^i_a x_a + 1/2 [hxx^i_ab x_a x_b + hss^i sigma^2] + sigma*  eta^i_c ep_c

%y^i = gx^i_a x_a + 1/2 [gxx^i_ab x_a x_b + gss^i sigma^2]

%where 

% hx is nx by nx
% gx is ny by nx
% hxx is nx by nx by nx
% gxx is ny by nx by nx
% eta is nx by ne
% gss is ny by 1
% hss is nx by 1
% sigma is a positive scalar

%Calls: kim_model.m gx_hx.m gxx_hxx.m gss_hss.m
% 
%(c) Stephanie Schmitt-Grohe and Martin Uribe
%Date January 21, 2002
[fx,fxp,fy,fyp,fypyp,fypy,fypxp,fypx,fyyp,fyy,fyxp,fyx,fxpyp,fxpy,fxpxp,fxpx,fxyp,fxy,fxxp,fxx]=kim_model;

[gx,hx] = gx_hx(fy,fx,fyp,fxp)

[gxx,hxx] = gxx_hxx(fx,fxp,fy,fyp,fypyp,fypy,fypxp,fypx,fyyp,fyy,fyxp,fyx,fxpyp,fxpy,fxpxp,fxpx,fxyp,fxy,fxxp,fxx,hx,gx) 

eta=[0 0; 0 0; 1 0; 0 1];

[gss,hss] = gss_hss(fx,fxp,fy,fyp,fypyp,fypy,fypxp,fypx,fyyp,fyy,fyxp,fyx,fxpyp,fxpy,fxpxp,fxpx,fxyp,fxy,fxxp,fxx,hx,gx,gxx,eta)