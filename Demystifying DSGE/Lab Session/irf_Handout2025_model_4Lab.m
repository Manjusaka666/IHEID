% for RBC model
% Comparing IRF under different calibration

filepart = 'D:\MyCourseDSGEs2025\Lab2025\4Lab';

% Load first set of results
load(fullfile(filepart,'DynareHandout2025\Output','DynareHandout2025_results.mat'));
OOPT.MODELS.oo_EHL = oo_;

% Load second set of results
load(fullfile(filepart,'DynareHandout2025_v2\Output','DynareHandout2025_v2_results.mat'));
OOPT.MODELS.oo_EHL1 = oo_;

OOPT.NN=100;
OOPT.plot_color={'b' '--r'}
OOPT.shocks_names={'e'};
OOPT.tit_shocks={'Productivity shock'};
OOPT.type_models={'oo_EHL' 'oo_EHL1'};
OOPT.legend_models={'\sigma = 2','\sigma = 1'}
OOPT.list_endo={'y' 'c' 'i' 'k' 'n' 'r'};
OOPT.label_variables={'Output' 'Consumption' 'Investment' 'Capital Stock' 'Labour' 'Interest Rate'};
plot_comp(OOPT);

