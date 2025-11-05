%for CK-08 model 
% This attempts to construct Fig1

filepart = 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS5';
load(fullfile(filepart,'CK08_simRTM\Output','CK08_simRTM_results.mat'));
%load 'CK08_simRTM_results';
OOPT.MODELS.oo_EHL = oo_;
load(fullfile(filepart,'CK08_simRTMv2\Output','CK08_simRTMv2_results.mat'));
%load 'CK08_simRTMv2_results';
% load(fullfile(filepart,'CK08_simRTM_q4\Output','CK08_simRTM_q4_results.mat'));
OOPT.MODELS.oo_EHL1 = oo_;
load(fullfile(filepart,'CK08_simRTMv3\Output','CK08_simRTMv3_results.mat'));
%load 'CK08_simRTMv3_results';
% load(fullfile(filepart,'CK08_simRTM_q4v2\Output','CK08_simRTM_q4v2_results.mat'));
OOPT.MODELS.oo_EHL2 = oo_;

OOPT.NN=60;
OOPT.plot_color={'k' '--r' ':b'}
OOPT.shocks_names={'interest_'};
OOPT.tit_shocks={'MonPol Shock'};
OOPT.type_models={'oo_EHL' 'oo_EHL1' 'oo_EHL2'};
OOPT.legend_models={'5mo','2mo','12mo'}
OOPT.list_endo={'y' 'Pi' 'R' 'u' 'v' 'PsiL' 'h' 'w' 'Piw'};
OOPT.label_variables={'Output' 'Inflation' 'Nominal Rate' 'Unemployment Rate' 'Vacancies' 'Labour Profits' 'Hours per worker' 'Real Wage per Hour' 'Nominal Wage Inflation'};
plot_comp(OOPT);

