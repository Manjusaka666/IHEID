%This Matlab-File replicates figure 2 and 3 of the paper J.F. Cogan, T. Cwik, J.B. Taylor and V. Wieland (2010), 
%"New Keynesian versus old Keynesian government spending multipliers", Journal of Economic Dynamics & Control 34, 281-295.
clear all;
close all;

%Dynare reads in the model equations
dynare SW_US_fiscal2002
warning off;
options_.periods=2000;
options_.simul_algo=0;
options_.dynatol=0.00001;
options_.maxit=10;
options_.slowc=1;
options_.timing=0;
options_.gstep=1e-2;
options_.scalv=1;
clc;

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp('J.F. Cogan, T. Cwik, J.B. Taylor and V. Wieland (2010)');, 
disp('"New Keynesian versus old Keynesian government spending multipliers"');
disp('Journal of Economic Dynamics & Control 34, 281-295');
disp(' ');
disp('Deterministic simulation of the Smets and Wouters(2007) model to replicate figure 2 and 3 of the paper.');
disp('Figure 1 displays the output effects of government purchases in the February 2009 stimulus legislation and');
disp('figure 2 the consumption and investment effects.');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(' ');
%Starts the deterministic simulation 
simul(oo_.dr); %Dynare V4


%Options
horizon=20;
time = (0:horizon)';
% US package
gs=[0;0.1964;0.4657;0.4657;0.59;0.77;0.77;0.77;0.73;0.49;0.49;0.49;0.4;0.25;0.25;0.25;0.17;0.16;0.16;0.16;0.16];  

%Figure 2 (page 286)
figure;
set(gcf,'Visible','on')
axes1=axes('XTickLabel',{'2009','2010','2011','2012','2013'},'XTick',[1 5 9 13 17],'FontName','Arial');
hold(axes1,'all');
AXIS([0 20 -0.1 0.8])
bar(time,gs,'w','LineWidth',2);
hold on;
plot(time,y(1:21),'Color',[1 0 0],'LineWidth',4); hold on;
set(gca, 'FontSize',14);
h= legend('Government purchases','Impact on GDP');    
set(h,'Box','off','Position',[0.5948 0.7183 0.2017 0.08282])
ylabel({'Percent of GDP',''});


%Figure 3 (page 287)
figure;
set(gcf,'Visible','on')
axes1=axes('XTickLabel',{'2009','2010','2011','2012','2013'},'XTick',[1 5 9 13 17],'FontName','Arial');
hold(axes1,'all');
AXIS([0 20 -0.4 0.8])
bar(time,gs,'w','LineWidth',2);
hold on;
plot(time,ccy*c(1:21),'Color',[0.5 0 0.5],'LineWidth',4); hold on;
plot(time,ciy*inve(1:21),'Color',[0 0.5 0],'LineWidth',4); hold on;
plot(time,ccy*c(1:21)+ciy*inve(1:21),'Color',[0.2 0.2 0.2],'LineWidth',4); hold on;
set(gca, 'FontSize',14);
ylabel({'Percent of GDP',''});
annotation('textbox',[0.459 0.3179 0.1732 0.04438],...
    'String',{'Consumption (C)'},...
    'FontSize',12,...
    'FontName','Arial',...
    'EdgeColor','none','FitBoxToText','on');
annotation('textbox',[0.4317 0.2512 0.14 0.04438],...
    'String',{'Investment (I)'},...
    'FontSize',12,...
    'FontName','Arial',...
    'EdgeColor','none','FitBoxToText','on');
annotation('textbox',[0.4412 0.1719 0.09371 0.04438],...
    'String',{'C plus I'},...
    'FontSize',12,...
    'FontName','Arial',...
    'EdgeColor','none','FitBoxToText','on');
annotation('textbox',[0.4719 0.7704 0.2539 0.04438],...
    'String',{'Government purchases (G)'},...
    'FontSize',12,...
    'FontName','Arial',...
    'EdgeColor','none','FitBoxToText','on');