%.......Question .b........%
%Define variables and functions
D_1 = 1:0.001:2; %total borrowing
R_Ss = ((1-sqrt(1-D_1*(2*1.02/25)))./(D_1/25)); %inverse supply of funds
R_Ds = (sqrt((50*(1-(1.02/1.05)))./(D_1/1.05))); %inverse demand for funds

%Plot the functions
figure
plot(D_1, R_Ss, 'b', D_1, R_Ds, 'r')
xlabel('D_1')
ylabel('R^s')
title('Equilibrium borrowing and gross interest rate')
legend('Supply', 'Demand')

%Modify the calibration: decrease phi from .5 to .4
R_Ss1 = ((1-sqrt(1-D_1*(1.02/10)))./(D_1/20)); %new supply
R_Ds1 = (sqrt((40*(1-(1.02/1.05)))./(D_1/1.05))); %new demand

%Plot the comparative statics
figure
plot (D_1, R_Ss, 'b', D_1, R_Ss1, 'b--', D_1, R_Ds, 'r', D_1, R_Ds1, 'r--')
xlabel('D_1')
ylabel('R^s')
title('Comparative statics: decrease in default cost')
legend('Supply phi=.5', 'Supply phi=.4','Demand phi=.5', 'Demand phi=.4')

%.........Question .c........%
%Rename functions with new calibration: z=.5
R_Ss1 = ((1-sqrt(1-D_1*(1.02/25)))./(D_1/50)); %new supply

%Plot the comparative statics
figure
plot (D_1, R_Ss, 'b', D_1, R_Ss1, 'b--', D_1, R_Ds, 'r')
xlabel('D_1')
ylabel('R^s')
title('Comparative statics: decrease in haircut rate')
legend('Supply haircut 100%', 'Supply haircut 50%','Demand')

%.........Question .d........%
%Rename functions with new calibration Y^L = 20
clear
D_1 = 1:0.001:12; %total borrowing
R_Ss = ((1-sqrt(1-D_1*(2*1.02/25)))./(D_1/25)); %inverse supply of funds
R_Ds = (sqrt((50*(1-(1.02/1.05)))./(D_1/1.05))); %inverse demand for funds
R_Ss1 = ((5/4)-sqrt((25/16)-(1.02*D_1/10)))./(D_1/20) ; %new supply
R_Ds1 = ((1/3.36)+sqrt((1/(3.36^2))-(4*D_1/33.6)*((1.02/1.05)-1)))./(2*D_1/33.6) ; %new demand

%Plot the comparative statics
figure
plot (D_1, R_Ss, 'b', D_1, R_Ss1, 'b--', D_1, R_Ds, 'r', D_1, R_Ds1, 'r--')
xlabel('D_1')
ylabel('R^s')
title('Comparative statics: increase in Y_L')
legend('Supply with Y_L=0', 'Supply with Y_L=20','Demand with Y_L=0','Demand with Y_L=20')
