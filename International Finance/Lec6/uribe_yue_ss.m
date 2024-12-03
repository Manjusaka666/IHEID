%URIBE_YUE_SS.M with Time-To-Build
function [BETTA,GAMA,DELTA, ALFA, PSSI, OMEGA, PHI, ETA, MU, R, RUS, RHOR, RHORUS, ARUSRUS1, ARRUS, ARRUS1, ARY, ARY1, ARIV, ARIV1, ARTBY, ARTBY1, ARR1, c, cp, cback, cbackp, h, hp, h1, h1p, k, kp, k1, k1p, d, dp, dback, dbackp, iv, ivp, iv1, iv1p, ivback, ivbackp, s0, s1, s2, s3, s0p, s1p, s2p, s3p, nu0, nu0p, nu1, nu1p, nu2, nu2p, tb, tbp, tby, tbyp, tbyback, tbybackp, la, lap, yy, yyp, yyback, yybackp, qq, qqp, r, rp, rback, rbackp, rus, rusp, rusback, rusbackp, er, erp, erus, erusp, C, H, K, D, IV, LA, YY, TBY, QQ] = uribe_yue_ss(pssi,phi,eta,mu)
%
%WC_SS.M produces the deep structural parameters and computes the steady state of a small open economy model with debt adjustment costs and a working capital constraint on labor payments. 

%(c) Martin Uribe and Z. Vivian Yue

%Date June 15, 2003

if nargin<4
mu = 0.25662293062270; %Intensity of external habit formation
end
if nargin<3
eta = 1.17848765297703; %Fraction of wage bill requiring working capital in advance
end
if nargin<2
phi =107.1685236678627; %Parameter of adjustment cost function
end
if nargin<1
pssi = 0.0003519795325248558; %Debt elasticity of debt adjustment cost function
end

PSSI=pssi;%Debt elastricity of debt adjustment cost function 
ETA=eta; %fraction of wege bill subject to a working-capital-in-advance constaint
PHI=phi;%parameter of capital adjustment cost function
MU = mu; %Intensity of external habit formation

OMEGA=1.455; %labor supply elasticity=1/(OMEGA-1);
GAMA = 2; %intertemporal elasticity of substitution

DELTA = 0.1/4; %Depreciation rate

ALFA = 0.32; %Capital elasticity of the production function

STB = 0.02; %Trade-to-GDP ratio

RUS = 1+0.04/4; %world interest rate

PREMIUM = 0.07/4; %Average country interest rate

%Parameters of the esimated processes for rus and r
ARUSRUS1 = 0.830391;


%Parameters of the estimated process for R
ARRUS =  0.5007957; 
ARRUS1 = 0.3552734;
ARY = -0.790594/4;
ARY1 = 0.6168297/4; 
ARIV = 0.1136852/4;
ARIV1 = -0.1219493/4;
ARTBY = 0.2885544/4;
ARTBY1 = -0.1898889/4;
ARR1 = 0.6346887;

RHOR=0; %Persistence of interest rate shock er

RHORUS=0; %Persistence of US interest rate shock erus

R = RUS * (1+PREMIUM); %Country interest rate

BETTA = 1/R; %Discount factor


NU0 = 1/4;
NU1 = 1/4 + NU0/BETTA;
NU2 = 1/4 + NU1/BETTA;
QQ = 1/4 + NU2/BETTA; %Tobin's 

h_over_k = ((R-1+DELTA)*QQ/ALFA)^(1/(1-ALFA)); %hours to capital ratio

H = ((1-ALFA) / (1+ETA*(R-1)/R) * (ALFA/(QQ*(R-1+DELTA))) ^ (ALFA/(1-ALFA)))^(1/(OMEGA-1)); %hours

K = H / h_over_k; %capital

IV = DELTA * K; %investment

S0 = IV; %New investment projects
S1 = IV; %1-period-old project
S2 = IV; %2-period-old project
S3 = IV; %3-period-old project

YY = K^ALFA * H^(1-ALFA); %output

tb = STB * YY; %trade balance

C = YY - IV - tb; %Consumption

W = (1-ALFA) * YY / H / (1+ETA*(R-1)/R); %wage

U = ALFA * YY / K; %rental rate of capital

D = (C+IV-W*H-U*K)/(1-R); %net foreign asset positioin

tby = tb / YY; %Trade Balance-to-GDP ratio
TBY = tby;


LA =  ( C * (1-MU) - H^OMEGA/OMEGA)^(-GAMA); %marginal urility of consumption

ER = 1; %Shock to country interest rate

ERUS = 1; %Shock to world interest rate


%Take logs
c = log(C);
cback = log(C);
h = log(H);
h1 = log(H);
k = log(K);
k1 = log(K);
la = log(LA);
yy = log(YY);
yyback = log(YY);
iv = log(IV);
s0 = log(IV);
s1 = log(IV);
s2 = log(IV);
s3 = log(IV);
iv1 = log(IV);
ivback = log(IV);
d = log(D);
dback = log(D);
qq = log(QQ);
r = log(R);
rback = log(R);
rus = log(RUS);
rusback = log(RUS);
er = log(ER);
erus = log(ERUS);
tbyback=tby;
nu0 = log(NU0);
nu1 = log(NU1);
nu2 = log(NU2);

%Next-period variables
cp = log(C);
cbackp = log(C);
hp = log(H);
h1p = log(H);
kp = log(K);
k1p = log(K);
lap = log(LA);
yyp = log(YY);
yybackp = log(YY);
ivp = log(IV);
iv1p = log(IV);
ivbackp = log(IV);
s0p = log(IV);
s1p = log(IV);
s2p = log(IV);
s3p = log(IV);
dp = log(D);
dbackp = log(D);
qqp = log(QQ);
rp = log(R);
rbackp = log(R);
rusp = log(RUS);
rusbackp = log(RUS);
erp = log(ER);
erusp = log(ERUS);
tbp = tb;
tbyp = tby;
tbybackp = tby;
nu0p = log(NU0);
nu1p = log(NU1);
nu2p = log(NU2);