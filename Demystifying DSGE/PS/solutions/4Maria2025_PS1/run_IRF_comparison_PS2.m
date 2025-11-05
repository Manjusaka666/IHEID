% NB: This version includes response of Lh to prod shock (compared to L in orig model)

dynare RBC_4PS2_Q10
oo_EHL=oo_;
dynare RBC_4PS2_Q5 noclearall
oo_SGU=oo_;

hh=figure('Name','Dynamic Responses to AS shock');
subplot(3,2,1)
plot(1:options_.irf,oo_EHL.irfs.Y_e,'-',1:options_.irf,oo_SGU.irfs.Y_e,'r--','LineWidth',3)
xlim([1 options_.irf]);
ylabel('percent')
title('Output')
ll=legend('W/ Domestic','W/O Domestic');
set(ll,'Location','NorthEast');
subplot(3,2,2)
plot(1:options_.irf,oo_EHL.irfs.Lh_e,'-',1:options_.irf,oo_SGU.irfs.L_e,'r--','LineWidth',3)
xlim([1 options_.irf]);
title('Hours Worked-h')
subplot(3,2,3)
plot(1:options_.irf,oo_EHL.irfs.Lm_e,'-',1:options_.irf,oo_SGU.irfs.L_e,'r--','LineWidth',3)
xlim([1 options_.irf]);
title('Hours Worked-m')
subplot(3,2,4)
plot(1:options_.irf,oo_EHL.irfs.Ctot_e,'-',1:options_.irf,oo_SGU.irfs.C_e,'r--','LineWidth',3)
xlim([1 options_.irf]);
xlabel('quarter')
ylabel('percent')
title('Consumption')
subplot(3,2,5)
plot(1:options_.irf,oo_EHL.irfs.W_e,'-',1:options_.irf,oo_SGU.irfs.W_e,'r--','LineWidth',3)
xlim([1 options_.irf]);
xlabel('quarter')
ylabel('percent')
title('WageRate')
subplot(3,2,6)
plot(1:options_.irf,oo_EHL.irfs.R_e,'-',1:options_.irf,oo_SGU.irfs.R_e,'r--','LineWidth',3)
xlim([1 options_.irf]);
xlabel('quarter')
ylabel('percent')
title('InterestRate')
set(findall(hh,'-property','FontWeight'),'FontWeight','normal')

print -depsc2 model11_jc2v2