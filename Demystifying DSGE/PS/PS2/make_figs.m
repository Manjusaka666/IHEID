%% Use SW Models

% load 'J:\MyCourseDSGEs2024\Tests\SW2007original_4HW3Q4\Output\SW2007original_4HW3Q4_results'; 

% Cahnge the data source here to switch between Q3, Q6 and Q7

% Q3
load 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS2\PS2_Solutions\usmodel_q3\Output\usmodel_q3_results.mat';

% Q6
% load 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS2\PS2_Solutions\usmodel_q6\Output\usmodel_q6_results.mat';

% Q7
% load 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS2\PS2_Solutions\usmodel_q7\Output\usmodel_q7_results.mat';

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

% === 新增：Consumption 与 Investment 的 IRFs 收集 ===
C = zeros(7,periods); % Consumption
C(1,:) = oo_EHL.irfs.c_ea;
C(2,:) = oo_EHL.irfs.c_eb;
C(3,:) = oo_EHL.irfs.c_eg;
C(4,:) = oo_EHL.irfs.c_em;
C(5,:) = oo_EHL.irfs.c_ew;
C(6,:) = oo_EHL.irfs.c_epinf;
C(7,:) = oo_EHL.irfs.c_eqs;

I = zeros(7,periods); % Investment
I(1,:) = oo_EHL.irfs.inve_ea;
I(2,:) = oo_EHL.irfs.inve_eb;
I(3,:) = oo_EHL.irfs.inve_eg;
I(4,:) = oo_EHL.irfs.inve_em;
I(5,:) = oo_EHL.irfs.inve_ew;
I(6,:) = oo_EHL.irfs.inve_epinf;
I(7,:) = oo_EHL.irfs.inve_eqs;

%titles = ['RiskPremium';'ExogSpending';'InvestSpecific'];

%'RiskPremium '; % 2
%'ExogSpending'; % 3
%'InvestSpecif'; % 7

titles(1,:) ='Output      '; % Y
titles(2,:) ='Hours       '; % X
titles(3,:) ='Inflation   '; % Z
titles(4,:) ='InterestRate'; % W

% === 七个冲击的名字（课堂顺序） ===
shockNames = {'TFP','Risk premium','Exog spending', ...
              'Monetary policy','Wage markup', ...
              'Price markup','InvestSpecific'};

figure('NumberTitle','off','Name','IRFs per shock: Y vs C vs Inv');
    % 1) ea
    subplot(4,2,1)
    plot(1:1:periods, Y(1,:),'-b', 1:1:periods, C(1,:),'-r', 1:1:periods, I(1,:),'-k','LineWidth',1.5)
    title(shockNames{1});

    % 2) eb
    subplot(4,2,2)
    plot(1:1:periods, Y(2,:),'-b', 1:1:periods, C(2,:),'-r', 1:1:periods, I(2,:),'-k','LineWidth',1.5)
    title(shockNames{2});

    % 3) eg
    subplot(4,2,3)
    plot(1:1:periods, Y(3,:),'-b', 1:1:periods, C(3,:),'-r', 1:1:periods, I(3,:),'-k','LineWidth',1.5)
    title(shockNames{3});

    % 4) em
    subplot(4,2,4)
    plot(1:1:periods, Y(4,:),'-b', 1:1:periods, C(4,:),'-r', 1:1:periods, I(4,:),'-k','LineWidth',1.5)
    title(shockNames{4});

    % 5) ew
    subplot(4,2,5)
    plot(1:1:periods, Y(5,:),'-b', 1:1:periods, C(5,:),'-r', 1:1:periods, I(5,:),'-k','LineWidth',1.5)
    title(shockNames{5});

    % 6) epinf
    subplot(4,2,6)
    plot(1:1:periods, Y(6,:),'-b', 1:1:periods, C(6,:),'-r', 1:1:periods, I(6,:),'-k','LineWidth',1.5)
    title(shockNames{6});

    % 7) eqs
    subplot(4,2,7)
    plot(1:1:periods, Y(7,:),'-b', 1:1:periods, C(7,:),'-r',  1:1:periods, I(7,:),'-k','LineWidth',1.5)
    title(shockNames{7});

ll = legend('Y','C','Inv');
set(ll,'Location','East');

% Export PDF
outPDF = fullfile('E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS2','Q3_fig_2.pdf');
% Change the file name above as needed
exportgraphics(gcf, outPDF, 'ContentType','vector');
