%This simple Matlab program shows how to implement the Blanchard-Kahn
%approach to the RBC model seen in the class of November 8
%In this program I use an ordering of the eigenvalues matrix that is the
%same as in the review session. This requires some manipulation as Matlab
%gives a reverse ordering.

clear;

% We set the parameters values
alpha=1/3;         %share of capital in production
g=0.005;           %trend growth rate of productivity
n=0.0025;          %trend growth rate of population
delta=0.025;       %rate of capital depreciation
rbar=0.015;        %steady state real interest rate
lbar=1/3;          %share of time spent working in steady state
G_Y=0.2;           %share of government to GDP in steady state
rho_A=0.95;        %persistence of productivity shocks
rho_G=0.95;        %persistence of government shocks

%We compute some steady state values
kbar=(alpha/(rbar+delta))^(1/(1-alpha));     %scaled capital
Y_K=(rbar+delta)/alpha;                      %ratio Y/K
G_K=G_Y*Y_K;                                 %ratio G/K
C_K=1-delta+kbar^(alpha-1)-exp(g+n)-G_K;     %ratio C/K
C_Y=C_K/Y_K;                                 %ratio C/Y

%We compute some terms that are useful later
lbar_rat=lbar/(1-lbar);
rd_rat=(rbar+delta)/(1+rbar)*(1-alpha);
exp_rat=exp(g+n)/(exp(g+n)-1+delta);

%We compute the coefficients for the capital dynamics
eta_KK=(1+rbar)/exp(g+n);
eta_KA=(rbar+delta)/exp(g+n)*(1-alpha)/alpha;
eta_KL=eta_KA;
eta_KC=-C_K/exp(g+n);
eta_KG=-G_K/exp(g+n);

%We compute the coefficients for labor
eta_LK=alpha/(lbar_rat+alpha);
eta_LA=(1-alpha)/(lbar_rat+alpha);
eta_LC=-1/(lbar_rat+alpha);

%We compute the matrices of the system
X=zeros(4,4); Y=zeros(4,4); Z=zeros(4,2);
X(1,1)=1;
X(2,1)=rd_rat*(1-eta_LK); X(2,2)=-rd_rat*(1+eta_LA); X(2,4)=1-rd_rat*eta_LC;
X(3,2)=1;
X(4,3)=1;
Y(1,1)=eta_KK+eta_KL*eta_LK; Y(1,2)=eta_KA+eta_KL*eta_LA; Y(1,3)=eta_KG; Y(1,4)=eta_KC+eta_KL*eta_LC;
Y(2,4)=1;
Y(3,2)=rho_A;
Y(4,3)=rho_G;
Z(3,1)=1;
Z(4,2)=1;

A=inv(X)*Y;  B=inv(X)*Z;

% We compute the left eigenvectors LV, the right eigenvectors RV and the eigenvalues EV of the matrix A

[RV,EV]=eig(A);
[LV,EV] = eig(A.'); LV = conj(LV);

%In the notation of the review session however we listed the SMALLEST eigenvalues
%first, so we need to re-order things

EVsort=diag(sort(diag(EV),'ascend'));
[c, index]=sort(diag(EV),'ascend');
LVsort=LV(:,index);

%EVsort is a diagonal matrix with the SMALLEST eigenvalues listed first
%You can check that (LVsort)'*A=EVsort*(LVsort)'  
%You can check that there is only one eigenvalue above 1, which is fine as
%two out of the three state variables (A and G) have stable dynamics by
%assumption

%We compute the matrix C, which is C=(LV)', and the blocks of C that we need
C=LVsort';
C11=C(1:3,1:3); C12=C(1:3,4); C21=C(4,1:3); C22=C(4,4);

%We compute the sensitivity of control variables to K, A and G
%Coeff is a x3 matrix in which each row contains the impact of K, A and G
%on the variable of interest.
%The rows correspond to the following control variables: 1-consumption, 2-
%labor, 3-output, 4-investment, 5-wage, 6-marginal product of capital,
%7-next period capital, 8-productivity, 9-government

Coeff=zeros(9,3);

%The sensitivity of consumption is computed from the matrix analysis above
for s=1:3
    Coeff(1,s)=-inv(C22)*C21(1,s);
end

%Labor
Coeff(2,1)=eta_LK+eta_LC*Coeff(1,1);
Coeff(2,2)=eta_LA+eta_LC*Coeff(1,2);
Coeff(2,3)=eta_LC*Coeff(1,3);

%Output
Coeff(3,1)=alpha+(1-alpha)*Coeff(2,1);
Coeff(3,2)=(1-alpha)*(1+Coeff(2,2));
Coeff(3,3)=(1-alpha)*Coeff(2,3);

%Investment
Coeff(4,1)=(1+exp_rat*(eta_KK-1))+exp_rat*(eta_KC*Coeff(1,1)+eta_KL*Coeff(2,1));
Coeff(4,2)=exp_rat*(eta_KA+eta_KC*Coeff(1,2)+eta_KL*Coeff(2,2));
Coeff(4,3)=exp_rat*(eta_KC*Coeff(1,3)+eta_KL*Coeff(2,3)+eta_KG);

%Wage, equal to y-l
Coeff(5,1)=Coeff(3,1)-Coeff(2,1);
Coeff(5,2)=Coeff(3,2)-Coeff(2,2);
Coeff(5,3)=Coeff(3,3)-Coeff(2,3);

%Marginal product of capital, equal to y-k
Coeff(6,1)=Coeff(3,1)-1;
Coeff(6,2)=Coeff(3,2);
Coeff(6,3)=Coeff(3,3);

%We compute the dynamics of state variables
Omega=C11-C12*inv(C22)*C21;
J1=EVsort(1:3,1:3);
D=inv(Omega)*J1*Omega;
Coeff(7:9,1:3)=D;

%We compute the sensitivity of the state variables to shocks
CoeffV=B(1:3,1:2);

%We trace the effect of a unit productivity shock
%We compute a 9x50 matrix with the values of 1-consumption, 2-
%labor, 3-output, 4-investment, 5-wage, 6-marginal product of capital,
%7-current period capital, 8-productivity, 9-government

RES_A=zeros(9,51);  %The last column is left unused
RES_A(8,1)=1;
for s=1:50
    RES_A(8,s+1)=Coeff(8,1:3)*RES_A(7:9,s);
    RES_A(7,s+1)=Coeff(7,1:3)*RES_A(7:9,s);
    RES_A(1,s)=Coeff(1,1:3)*RES_A(7:9,s);
    RES_A(2,s)=Coeff(2,1:3)*RES_A(7:9,s);
    RES_A(3,s)=Coeff(3,1:3)*RES_A(7:9,s);
    RES_A(4,s)=Coeff(4,1:3)*RES_A(7:9,s);
    RES_A(5,s)=Coeff(5,1:3)*RES_A(7:9,s);
    RES_A(6,s)=Coeff(6,1:3)*RES_A(7:9,s);
end

%We draw a serie of charts of the impact

figure(1);
time=1:50;    %the horizontal axis time frame
plot(time, RES_A([8,7,2],1:50))
title('Response to productivity')
hleg=legend('productivity','capital','labor')
orient landscape;   %So the figures appear in landscape format
print('ML_Prod_shock_fig_1','-dpdf');

figure(2);
time=1:50;    %the horizontal axis time frame
plot(time, RES_A([3,1],1:50))
title('Response to productivity')
hleg=legend('output','consumption');
orient landscape;
print('ML_Prod_shock_fig_2','-dpdf');

figure(3);
time=1:50;    %the horizontal axis time frame
plot(time, RES_A([5,6],1:50))
title('Response to productivity')
hleg=legend('wage','marginal product of capital');
orient landscape;
print('ML_Prod_shock_fig_3','-dpdf');


%We similarly trace the effect of a unit government shock

RES_G=zeros(9,51);  %The last column is left unused
RES_G(9,1)=1;
for s=1:50
    RES_G(9,s+1)=Coeff(9,1:3)*RES_G(7:9,s);
    RES_G(7,s+1)=Coeff(7,1:3)*RES_G(7:9,s);
    RES_G(1,s)=Coeff(1,1:3)*RES_G(7:9,s);
    RES_G(2,s)=Coeff(2,1:3)*RES_G(7:9,s);
    RES_G(3,s)=Coeff(3,1:3)*RES_G(7:9,s);
    RES_G(4,s)=Coeff(4,1:3)*RES_G(7:9,s);
    RES_G(5,s)=Coeff(5,1:3)*RES_G(7:9,s);
    RES_G(6,s)=Coeff(6,1:3)*RES_G(7:9,s);
end

%We draw a serie of charts of the impact

figure(4);
time=1:50;    %the horizontal axis time frame
plot(time, RES_G([7,2],1:50))
title('Response to government spending')
hleg=legend('capital','labor');
orient landscape;
print('ML_Govt_shock_fig_4','-dpdf');

figure(5);
time=1:50;    %the horizontal axis time frame
plot(time, RES_G([3,1],1:50))
title('Response to government spending')
hleg=legend('output','consumption');
orient landscape;
print('ML_Govt_shock_fig_5','-dpdf');

figure(6);
time=1:50;    %the horizontal axis time frame
plot(time, RES_G([5,6],1:50))
title('Response to government spending')
hleg=legend('wage','marginal product of capital');
orient landscape;
print('ML_Govt_shock_fig_6','-dpdf');



