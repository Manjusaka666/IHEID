%% Use SW Models

load 'J:\MyCourseDSGEs2024\Tests\SW2007original_4HW3Q4\Output\SW2007original_4HW3Q4_results'; 
% The line above needs to be edited to reflect your installation
oo_EHL = oo_;
periods = 40 ; % This number has to be identical to that used in producing the IRFs in the models above

X = zeros(7,periods); % Hours
X(1,:)	=	oo_EHL.irfs.lab_ea	;
X(2,:)	=	oo_EHL.irfs.lab_eb	;
X(3,:)	=	oo_EHL.irfs.lab_eg	;
X(4,:)	=	oo_EHL.irfs.lab_em	;
X(5,:)	=	oo_EHL.irfs.lab_ew	;
X(6,:)	=	oo_EHL.irfs.lab_epinf	;
X(7,:)	=	oo_EHL.irfs.lab_eqs	;

Y = zeros(7,periods); % Output
Y(1,:)	=	oo_EHL.irfs.y_ea	;
Y(2,:)	=	oo_EHL.irfs.y_eb	;
Y(3,:)	=	oo_EHL.irfs.y_eg	;
Y(4,:)	=	oo_EHL.irfs.y_em	;
Y(5,:)	=	oo_EHL.irfs.y_ew	;
Y(6,:)	=	oo_EHL.irfs.y_epinf	;
Y(7,:)	=	oo_EHL.irfs.y_eqs	;

Z = zeros(7,periods); % Inflation
Z(1,:)	=	oo_EHL.irfs.pinf_ea	;
Z(2,:)	=	oo_EHL.irfs.pinf_eb	;
Z(3,:)	=	oo_EHL.irfs.pinf_eg	;
Z(4,:)	=	oo_EHL.irfs.pinf_em	;
Z(5,:)	=	oo_EHL.irfs.pinf_ew	;
Z(6,:)	=	oo_EHL.irfs.pinf_epinf	;
Z(7,:)	=	oo_EHL.irfs.pinf_eqs	;

W = zeros(7,periods); % Interest rate
W(1,:)	=	oo_EHL.irfs.r_ea	;
W(2,:)	=	oo_EHL.irfs.r_eb	;
W(3,:)	=	oo_EHL.irfs.r_eg	;
W(4,:)	=	oo_EHL.irfs.r_em	;
W(5,:)	=	oo_EHL.irfs.r_ew	;
W(6,:)	=	oo_EHL.irfs.r_epinf	;
W(7,:)	=	oo_EHL.irfs.r_eqs	;

%titles = ['RiskPremium';'ExogSpending';'InvestSpecific'];

%'RiskPremium '; % 2
%'ExogSpending'; % 3
%'InvestSpecif'; % 7

titles(1,:) ='Output      '; % Y
titles(2,:) ='Hours       '; % X
titles(3,:) ='Inflation   '; % Z
titles(4,:) ='InterestRate'; % W

figure('NumberTitle','off','Name','Output/Hours/Inflation/InterestRate Response');   
     subplot(4,2,1)
     plot(1:1:periods,Y(2,:),'-k', 1:1:periods,Y(3,:),'-b', 1:1:periods,Y(7,:),'--r', 'LineWidth',1.5)
     title(titles(1,:));

     subplot(4,2,2)
     plot(1:1:periods,X(2,:),'-k', 1:1:periods,X(3,:),'-b', 1:1:periods,X(7,:),'--r', 'LineWidth',1.5)
     title(titles(2,:));

     subplot(4,2,3)
     plot(1:1:periods,Z(2,:),'-k', 1:1:periods,Z(3,:),'-b', 1:1:periods,Z(7,:),'--r', 'LineWidth',1.5)
     title(titles(3,:));

     subplot(4,2,4)
     plot(1:1:periods,W(2,:),'-k', 1:1:periods,W(3,:),'-b', 1:1:periods,W(7,:),'--r', 'LineWidth',1.5)
     title(titles(4,:));

ll=legend('Risk','Exog','Inv');
set(ll,'Location','SouthEast'); 





