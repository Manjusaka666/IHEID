% You will need to change the directory below to match your setup
filepart = 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS4';
% Load first set of results
load(fullfile(filepart,'Cai4PS4_Q3v1\Output','Cai4PS4_Q3v1_results.mat')); % SWFF+  SW (1965Q1 - 2004Q4)
OOPT.MODELS.oo_EHL1 = oo_;
% Load second set of results
load(fullfile(filepart,'Cai4PS4_Q3v2\Output','Cai4PS4_Q3v2_results.mat')); % SWFF+ FinCrises (1992Q1 - 2010Q4)
OOPT.MODELS.oo_EHL2 = oo_;
% Load third set of results
load(fullfile(filepart,'Cai4PS4_Q3v3\Output','Cai4PS4_Q3v3_results.mat')); % SWFF+  PostGFC (2011Q1 - 2025Q1)
OOPT.MODELS.oo_EHL3 = oo_;
% Load fourth set of results
load(fullfile(filepart,'Cai4PS4_Q3v4\Output','Cai4PS4_Q3v4_results.mat')); % SWFF+ Longest (1965Q1 - 2025Q1)
OOPT.MODELS.oo_EHL4 = oo_;

OOPT.NN=40;
OOPT.plot_color={'b' '--r' ':c' '--k'}
OOPT.shocks_names={'ea'};
OOPT.tit_shocks={'TFP'};
OOPT.type_models={'oo_EHL1' 'oo_EHL2' 'oo_EHL3' 'oo_EHL4'};
OOPT.legend_models={'SW' 'FinCrises' 'PostGFC' 'Longest' }
OOPT.list_endo={'y' 'c' 'inve' 'k' 'w' 'lab' 'r' 'pinf' };
OOPT.label_variables={'Output' 'Consumption' 'Investment' 'Capital Services'  'Wage Rate' 'Hours' 'Interest Rate'  'Inflation' };
plot_comp(OOPT);

OOPT.NN=40;
OOPT.plot_color={'b' '--r' ':c' '--k'}
OOPT.shocks_names={'eb'};
OOPT.tit_shocks={'Risk premium'};
OOPT.type_models={'oo_EHL1' 'oo_EHL2' 'oo_EHL3' 'oo_EHL4'};
OOPT.legend_models={'SW' 'FinCrises' 'PostGFC' 'Longest' }
OOPT.list_endo={'y' 'c' 'inve' 'k' 'w' 'lab' 'r' 'pinf' };
OOPT.label_variables={'Output' 'Consumption' 'Investment' 'Capital Services'  'Wage Rate' 'Hours' 'Interest Rate'  'Inflation' };
plot_comp(OOPT);
% 
% OOPT.NN=40;
% OOPT.plot_color={'b' '--r' ':c' '--k'}
% OOPT.shocks_names={'eg'};
% OOPT.tit_shocks={'Exogenous spending'};
% OOPT.type_models={'oo_EHL1' 'oo_EHL2' 'oo_EHL3' 'oo_EHL4'};
% OOPT.legend_models={'SW' 'FinCrises' 'PostGFC' 'Longest' }
% OOPT.list_endo={'y' 'c' 'inve' 'k' 'w' 'lab' 'r' 'pinf' };
% OOPT.label_variables={'Output' 'Consumption' 'Investment' 'Capital Services'  'Wage Rate' 'Hours' 'Interest Rate'  'Inflation' };
% plot_comp(OOPT);

OOPT.NN=40;
OOPT.plot_color={'b' '--r' ':c' '--k'}
OOPT.shocks_names={'em'};
OOPT.tit_shocks={'MonPol'};
OOPT.type_models={'oo_EHL1' 'oo_EHL2' 'oo_EHL3' 'oo_EHL4'};
OOPT.legend_models={'SW' 'FinCrises' 'PostGFC' 'Longest' }
OOPT.list_endo={'y' 'c' 'inve' 'k' 'w' 'lab' 'r' 'pinf' };
OOPT.label_variables={'Output' 'Consumption' 'Investment' 'Capital Services'  'Wage Rate' 'Hours' 'Interest Rate'  'Inflation' };
plot_comp(OOPT);
% 
% OOPT.NN=40;
% OOPT.plot_color={'b' '--r' ':c' '--k'}
% OOPT.shocks_names={'ew'};
% OOPT.tit_shocks={'Wage Markup'};
% OOPT.type_models={'oo_EHL1' 'oo_EHL2' 'oo_EHL3' 'oo_EHL4'};
% OOPT.legend_models={'SW' 'FinCrises' 'PostGFC' 'Longest' }
% OOPT.list_endo={'y' 'c' 'inve' 'k' 'w' 'lab' 'r' 'pinf' };
% OOPT.label_variables={'Output' 'Consumption' 'Investment' 'Capital Services'  'Wage Rate' 'Hours' 'Interest Rate'  'Inflation' };
% plot_comp(OOPT);
% 
% OOPT.NN=40;
% OOPT.plot_color={'b' '--r' ':c' '--k'}
% OOPT.shocks_names={'epinf'};
% OOPT.tit_shocks={'Price Markup'};
% OOPT.type_models={'oo_EHL1' 'oo_EHL2' 'oo_EHL3' 'oo_EHL4'};
% OOPT.legend_models={'SW' 'FinCrises' 'PostGFC' 'Longest' }
% OOPT.list_endo={'y' 'c' 'inve' 'k' 'w' 'lab' 'r' 'pinf' };
% OOPT.label_variables={'Output' 'Consumption' 'Investment' 'Capital Services'  'Wage Rate' 'Hours' 'Interest Rate'  'Inflation' };
% plot_comp(OOPT);
% 
% OOPT.NN=40;
% OOPT.plot_color={'b' '--r' ':c' '--k'}
% OOPT.shocks_names={'eqs'};
% OOPT.tit_shocks={'Investment-specific'};
% OOPT.type_models={'oo_EHL1' 'oo_EHL2' 'oo_EHL3' 'oo_EHL4'};
% OOPT.legend_models={'SW' 'FinCrises' 'PostGFC' 'Longest' }
% OOPT.list_endo={'y' 'c' 'inve' 'k' 'w' 'lab' 'r' 'pinf' };
% OOPT.label_variables={'Output' 'Consumption' 'Investment' 'Capital Services'  'Wage Rate' 'Hours' 'Interest Rate'  'Inflation' };
% plot_comp(OOPT);