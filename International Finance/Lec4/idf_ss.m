%Steady state of the Small Open Economy Model With An Internal Discount
%Factor (IDF)
%as presented in chapter 4 of ``Open Economy Macroeconomics,'' by Martín Uribe and Stephanie Schmitt-Grohé, 2013.


%Calibration
%Time unit is a year
SIGG = 2; %mENDOZA
DELTA = 0.1; %depreciation rate
RSTAR = 0.04; %long-run interest rate
ALFA = 0.32; %F(k,h) = k^ALFA h^(1-ALFA)
OMEGA = 1.455; %Frisch ela st. from Mendoza 1991
%DBAR =  0.7442; %debt
PSSI = 0.11135; %taken from section 4.6.3 of book 

PHI = 0.028; %capital adjustment cost
RHO = 0.42; %persistence of TFP shock
STD_EPS_A = 0.0129; %standard deviation of innovation to TFP shock

BETTA = 1/(1+RSTAR); %subjective discount factor

r = RSTAR; %interest rate

KAPA = ((RSTAR+DELTA) / ALFA)^(1/(ALFA-1)); %k/h

h = ((1-ALFA)*KAPA^ALFA)^(1/(OMEGA -1)); 

k = KAPA * h; %capital

output = KAPA^ALFA * h; %output

c = (1+RSTAR)^(1/PSSI) -1 + h^OMEGA/OMEGA;

ivv = DELTA * k; %investment

tb = output - ivv - c; %trade balance

tby = tb/output;

d =  tb/RSTAR

ca = -r*d+tb;

cay = ca/output;

a = 1; %technological factor
ap = 1; 
rstar = RSTAR; 
rstarp = rstar; 
tfp = a; %technological factor

X = (c - h^OMEGA/OMEGA);
U =( X^(1-SIGG) -1)/(1-SIGG); 
eta = -U/(1-BETTA);

la = X^(-SIGG) + PSSI * eta*(1+X)^(-PSSI-1);  %marginal utility of wealth

