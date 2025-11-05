%for CK-08 model 
% This attempts to construct Fig1
%load 'CK08_simRTM_results';
load(fullfile('CK08_simRTMv4_Q3\Output','CK08_simRTMv4_Q3_results.mat'));
OOPT.MODELS.oo_EHL = oo_;
%load 'CK08_simRTMv2_results';
load(fullfile('CK08_simEB_HW\Output','CK08_simEB_HW_results.mat'));
OOPT.MODELS.oo_EHL1 = oo_;


OOPT.NN=20;
OOPT.plot_color={'k' '--r'}
OOPT.shocks_names={'inno_eta'};
OOPT.tit_shocks={'Bargaining Power Shock'};
OOPT.type_models={'oo_EHL' 'oo_EHL1'};
OOPT.legend_models={'RTM Bargaining','Efficient Bargaining'}
OOPT.list_endo={'y' 'Pi' 'u' 'w'};
OOPT.label_variables={'Output' 'Inflation' 'Unemployment Rate' 'Real Wage per Hour'};
plot_comp(OOPT);

