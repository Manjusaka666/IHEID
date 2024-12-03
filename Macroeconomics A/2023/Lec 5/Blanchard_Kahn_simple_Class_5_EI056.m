%This simple Matlab program shows how to implement the Balanchard-Kahn
%approach to the simple model seen in the class of October 13
%A VERY useful resource is Seton Leonard's technical "Introductory Guide to
%Macroeconomic Theory" which provides clear technical steps and Matlab
%guidance.

clear;

% We set the parameters values
alpha=1/3;   %share of capital in production
theta=1;     %intertemporal elasticity of substition
n=0.02;      %population growth rate
rho=0.035;   %rate of time preference
rstar=0.05;  %steady state real interest rate
delta=rstar-rho;  %depreciation rate

% We define the two matrices of the linear system and compute A
X=zeros(2,2);
X(1,1)=1;
X(2,1)=(1/theta)*(rstar/(1+rstar-delta))*(1-alpha);
X(2,2)=1;

Y=zeros(2,2);
Y(1,1)=(1+rstar-delta)/(1+n);
Y(1,2)=-(1/alpha)*(rstar-alpha*(n+delta))/(1+n);
Y(2,2)=1;

A=inv(X)*Y;

% We compute the left eigenvectors LV, the right eigenvectors RV and the eigenvalues EV of the matrix A

[RV,EV]=eig(A);
[LV,EV] = eig(A.'); LV = conj(LV);
C=LV';

%EV is a diagonal matrix with the largest eigenvalues listed first
%You can check that A*RV=RV*EV and (LV)'*A=EV*(LV)'
%The matric C in the algebra appendix is thus C=(LV)'

% We compute eta_kk and eta_ck
eta_ck=-inv(C(1,2))*C(1,1);
M=C(2,1)-C(2,2)*inv(C(1,2))*C(1,1);
eta_kk=inv(M)*EV(2,2)*M;

display(eta_ck); display(eta_kk);

%We compute a 2 x 30 matrix that shows the values of k_t and c_t for 30
%periods, starting with k=1

RES=zeros(2,31);  %The last column is left unused
RES(1,1)=1;
for s=1:30
      RES(1,s+1)=eta_kk*RES(1,s);
      RES(2,s)=eta_ck*RES(1,s);
end

%We draw a chart of the results for k and c. You may need to wait a couple of
%second for Matlab to display the graph

figure(1);
time=1:30;    %the horizontal axis time frame
plot(time, RES(:,1:30))
hleg=legend('capital stock','consumption');





