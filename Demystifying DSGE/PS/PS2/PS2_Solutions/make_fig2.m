% make_fig2.m — Reproduce SW (2007) Figure 2 style panels
if ~exist('oo_','var') || ~isfield(oo_,'irfs')
    error('Please load the Dynare results file (e.g., load usmodel_q3_results.mat) so that oo_.irfs is in memory.');
end
periods = 40;
X = zeros(7,periods); Y = X; Z = X; W = X;
X(1,:)=oo_.irfs.lab_ea; X(2,:)=oo_.irfs.lab_eb; X(3,:)=oo_.irfs.lab_eg; X(4,:)=oo_.irfs.lab_em; X(5,:)=oo_.irfs.lab_ew; X(6,:)=oo_.irfs.lab_epinf; X(7,:)=oo_.irfs.lab_eqs;
Y(1,:)=oo_.irfs.y_ea;   Y(2,:)=oo_.irfs.y_eb;   Y(3,:)=oo_.irfs.y_eg;   Y(4,:)=oo_.irfs.y_em;   Y(5,:)=oo_.irfs.y_ew;   Y(6,:)=oo_.irfs.y_epinf;   Y(7,:)=oo_.irfs.y_eqs;
Z(1,:)=oo_.irfs.pinf_ea;Z(2,:)=oo_.irfs.pinf_eb;Z(3,:)=oo_.irfs.pinf_eg;Z(4,:)=oo_.irfs.pinf_em;Z(5,:)=oo_.irfs.pinf_ew;Z(6,:)=oo_.irfs.pinf_epinf;Z(7,:)=oo_.irfs.pinf_eqs;
W(1,:)=oo_.irfs.r_ea;   W(2,:)=oo_.irfs.r_eb;   W(3,:)=oo_.irfs.r_eg;   W(4,:)=oo_.irfs.r_em;   W(5,:)=oo_.irfs.r_ew;   W(6,:)=oo_.irfs.r_epinf;   W(7,:)=oo_.irfs.r_eqs;
titles = char('Output      ','Hours       ','Inflation   ','InterestRate');
figure('NumberTitle','off','Name','Output/Hours/Inflation/InterestRate Response');
subplot(4,2,1); plot(1:periods,Y(2,:),'-k',1:periods,Y(3,:),'-b',1:periods,Y(7,:),'--r','LineWidth',1.5); title(titles(1,:));
subplot(4,2,2); plot(1:periods,X(2,:),'-k',1:periods,X(3,:),'-b',1:periods,X(7,:),'--r','LineWidth',1.5); title(titles(2,:));
subplot(4,2,3); plot(1:periods,Z(2,:),'-k',1:periods,Z(3,:),'-b',1:periods,Z(7,:),'--r','LineWidth',1.5); title(titles(3,:));
subplot(4,2,4); plot(1:periods,W(2,:),'-k',1:periods,W(3,:),'-b',1:periods,W(7,:),'--r','LineWidth',1.5); title(titles(4,:));
legend('Risk','Exog','Inv','Location','SouthEast');