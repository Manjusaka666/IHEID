%URIBE_YUE_RUN.M 
%Impulse respose functions to country-spread and world interest rates (theoretical impulse responses shown in figure 6 of ``CountrySpreads and Emerging Countries: Who Drives Whom?'' by Martin Uribe and Vivian Z. Yue)
% 
%(c) Martin Uribe and Z. Vivian Yue
%
%Date June 5, 2003


clc
clear 

T=24;

pssi =  0.000425;
phi= 72.8268;
eta = 1.2023;
mu = 0.2037;
 
%Construct model IR

%Assign values to parameters and steady-state variables
[BETTA,GAMA,DELTA, ALFA, PSSI, OMEGA, PHI, ETA, MU, R, RUS, RHOR, RHORUS, ARUSRUS1, ARRUS, ARRUS1, ARY, ARY1, ARIV, ARIV1, ARTBY, ARTBY1, ARR1, c, cp, cback, cbackp, h, hp, h1, h1p, k, kp, k1, k1p, d, dp, dback, dbackp, iv, ivp, iv1, iv1p, ivback, ivbackp, s0, s1, s2, s3, s0p, s1p, s2p, s3p, nu0, nu0p, nu1, nu1p, nu2, nu2p, tb, tbp, tby, tbyp, tbyback, tbybackp, la, lap, yy, yyp, yyback, yybackp, qq, qqp, r, rp, rback, rbackp, rus, rusp, rusback, rusbackp, er, erp, erus, erusp, C, H, K, D, IV, LA, YY, TBY, QQ] = uribe_yue_ss(pssi,phi,eta,mu);

approx=1;



%Compute Model IR
[f,fx,fxp,fy,fyp] = uribe_yue_model;

%Compute numerical derivatives of f
num_eval

[gx,hx] = gx_hx(real(nfy),real(nfx),real(nfyp),real(nfxp)); 
gx=real(gx);
hx=real(hx);

%Impulse responses to country spread shock
x0 = zeros(size(hx,1),1);
x0(end) = 1/4;

IR=ir(gx,hx,x0,T);

yi = IR(:,1);
ci = IR(:,17);
invei = IR(:,5);
tbyi = IR(:,2);
ri = IR(:,3)*4;
rusi = IR(:,4)*4;
hi = IR(:,24);
ki = IR(:,25);
di = IR(:,9);


%Impulse responses to country spread shock
x0 = zeros(size(hx,1),1);
x0(end-1) = 1/4;

IR=ir(gx,hx,x0,T);

yr = IR(:,1);
cr = IR(:,17);
inver = IR(:,5);
tbyr = IR(:,2);
rr = IR(:,3)*4;
rusr = IR(:,4)*4;
hr = IR(:,24);
kr = IR(:,25);
dr = IR(:,9);



t = (0:T-1)';

clf

subplot(4,2,2)
plot(t,yi)
title('Response of Output to \epsilon^r')
axis tight

subplot(4,2,4)
plot(t,invei)
title('Response of Investment to \epsilon^r')
axis tight

subplot(4,2,6)
plot(t,tbyi)
title('Response of TB/GDP to \epsilon^r')
axis tight

subplot(4,2,8)
plot(t,ri)
title('Response of Country Interest Rate to \epsilon^r')
axis tight


subplot(4,2,1)
plot(t,yr)
title('Response of Output to \epsilon^{rus}')
axis tight

subplot(4,2,3)
plot(t,inver)
title('Response of Investment to \epsilon^{rus}')
axis tight


subplot(4,2,5)
plot(t,tbyr)
title('Response of TB/GDP to \epsilon^{rus}')
axis tight

subplot(4,2,7)
plot(t,rr)
title('Response of Country Interest Rate to \epsilon^{rus}')
axis tight

orient tall


shg