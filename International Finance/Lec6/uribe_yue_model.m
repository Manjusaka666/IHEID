%URIBE_YUE_MODEL.M with Time-To-Build
function [f,fx,fxp,fy,fyp] = uribe_yue_model
%WC_DAC.M computes a log-linear approximation to the  function f for a small open economy with endogenous external discount factor. Production and absorption decisions (h, c, and i) are constrained to be made before observing the period's interest rate.  The function f defines  the DSGE model (a p denotes next-period variables) : 
%  E_t f(yp,y,xp,x) =0. 
%
%Inputs: none
%
%Output: Numerical first derivative of f
%
%Calls: anal_deriv.m
%
%(c) Martin Uribe and Z. Vivian Yue
%
%Date June 15, 2003 

%Establish whether approximation should be of first or second order
if nargout>5
approx=2;
else
approx = 1;
end

%Define parameters
syms D BETTA GAMA DELTA ALFA PSSI ETA RHO OMEGA PHI MU R RUS YY IV TBY ARUSRUS1 ARRUS ARRUS1 ARY ARY1 ARIV ARIV1 ARTBY ARTBY1 ARR1 RHOR RHORUS

%Define variables 
syms c cp cback cbackp k kp h hp d dp dback dbackp  yy yyp yyback yybackp iv ivp iv1 iv1p tb tbp la lap tby tbyp rus rusp rusback rusbackp r rp rback rbackp qq qqp er erp erus erusp ivback ivbackp tbyback tbybackp s0 s1 s2 s3 s0p s1p s2p s3p nu0 nu1 nu2 nu0p nu1p nu2p

ddac = PSSI / 2 * (d-D)^2;
ddacp = PSSI / 2 * (dp-D)^2;

uf = ((c - MU * cback - h^OMEGA/OMEGA)^(1-GAMA)-1)/(1-GAMA);
ufp = ((cp - MU * c - hp^OMEGA/OMEGA)^(1-GAMA)-1)/(1-GAMA);

output =  k^ALFA *  h^(1-ALFA);
outputp = kp^ALFA *  hp^(1-ALFA);

ac = s3/k - PHI / 2 * (s3/k - DELTA)^2; %capital adjustment cost function
acp = s3p/kp - PHI / 2 * (s3p/kp - DELTA)^2; %capital adjustment cost function

rd = r / (1-diff(ddac,'d'));
rdp = rp / (1-diff(ddacp,'dp'));

w = diff(output,'h') / (1 + ETA * (rd-1)/rd); %wage
wp = diff(outputp,'hp') / (1 + ETA * (rdp-1)/rdp); 

u = diff(output,'k'); %rental rate of capital
up = diff(outputp,'kp'); 

%Write equations (ei, i=1:n)
%Note: we take a linear, rather than log-linear, approximation with respect to tb, the trade balance)
e1 = rback * dback + ddac - w*h - u*k + c + iv  - d;

e2 = -log(tb) + yy - c - iv - ddac;

e3 = -yy + output;

e4 = -k * ac + kp - (1-DELTA) *k;

e5 = - la * (1 - diff(ddac,'d')) + BETTA * r *lap;

e6 = - lap + diff(ufp,'cp');

e7 = -log(tby) + log(tb) / yy;

e8 = -diff(ufp,'hp') - lap * wp;

e9 = -la * qq + BETTA * ( lap * qqp * ( 1- DELTA + acp - s3p / kp * diff(acp,'s3p') * kp ) + lap * up);

e10 = -iv + (s0 + s1 + s2 + s3)/4;

e11 = -yybackp + yy;

e12 = -rusbackp + rus;

e13 = -rbackp + r;

e14 = -log(rus/RUS) + ARUSRUS1 * log(rusback/RUS) + log(erus);

e15 = -log(r/R) + ARRUS * log(rus/RUS) + ARRUS1 * log(rusback/RUS) + ARY * log(yy/YY) + ARY1 * log(yyback/YY) + ARIV * log(iv/IV) + ARIV1 * log(ivback/IV) + ARTBY * (log(tby)-TBY) + ARTBY1 * (log(tbyback)-TBY) + ARR1 * log(rback/R) + log(er); 

e16 = -log(erusp) + RHORUS * log(erus);

e17 = -log(erp) + RHOR * log(er);

e18 = -d + dbackp;

e19 = -tby + tbybackp;

e20 = -iv + ivbackp;

e21 = -cbackp + c;

e22 = -nu0p + 1/4;

e23 = -BETTA * lap * nu1p + BETTA / 4 * lap + la * nu0;

e24 = -BETTA * lap * nu2p + BETTA / 4 * lap + la * nu1;

e25 = -BETTA * lap * qqp * diff(acp,'s3p') * kp + BETTA / 4 * lap + la * nu2;

e26 = -s1p + s0;

e27 = -s2p + s1;

e28 = -s3p + s2;

%Create function f

f = [e1;e2;e3;e4;e5;e6;e7;e8;e9;e10;e11;e12;e13;e14;e15;e16;e17;e18;e19;e20;e21;e22;e23;e24;e25;e26;e27;e28];

% Define the vector of controls, y, and states, x
x = [c s0 s1 s2 s3  cback rback rusback yyback ivback tbyback h k dback  erus er];

xp = [cp s0p s1p s2p s3p cbackp rbackp rusbackp yybackp ivbackp  tbybackp  hp kp dbackp  erusp erp];

y = [yy tby r rus iv tb la qq d  nu0 nu1 nu2];

yp = [yyp tbyp rp rusp ivp tbp lap qqp dp nu0p nu1p nu2p];
%Make f a function of the logarithm of the state and control vector
f = subs(f, [x,y,xp,yp], exp([x,y,xp,yp]));

%Compute analytical derivatives of f
[fx,fxp,fy,fyp]=anal_deriv(f,x,y,xp,yp,approx);

%Numerical evaluation