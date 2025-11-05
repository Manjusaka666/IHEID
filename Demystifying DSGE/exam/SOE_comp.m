%for SOE4Exam model 
% This constructs the comparison of results for Q5
clear;
clc;

filepart = 'E:\Onedrive\Desktop\exam\';


load(fullfile(filepart,'Q4\Output','Q4_results.mat')); % Benchmark
OOPT.MODELS.oo_EHL = oo_;
load(fullfile(filepart,'Q5a\Output','Q5a_results.mat')); % No habit 
OOPT.MODELS.oo_EHL1 = oo_;
load(fullfile(filepart,'Q5b\Output','Q5b_results.mat')); % No indexation
OOPT.MODELS.oo_EHL2 = oo_;
load(fullfile(filepart,'Q5c\Output','Q5c_results.mat')); % No ER in Taylor Rule
OOPT.MODELS.oo_EHL3 = oo_;

OOPT.NN=24;
OOPT.plot_color={'k' '--r' ':b' 'g'}
% OOPT.shocks_names={'e_r'};
% OOPT.tit_shocks={'MonPol Shock'};
OOPT.shocks_names={'e_y_star'};
OOPT.tit_shocks={'Foreign Output Shock'};
OOPT.type_models={'oo_EHL' 'oo_EHL1' 'oo_EHL2' 'oo_EHL3'};
OOPT.legend_models={'Q4','Q5a','Q5b','Q5c'}
OOPT.list_endo={'y' 'c' 'pi' 'r' 'q' 's' 'e' 'pi_h' 'pi_f'};
OOPT.label_variables={'Output' 'Consumption' 'Inflation' 'Nominal Rate' 'RER' 'TOT' 'ER' 'Domestic Inflation' 'Imported Inflation'};
plot_comp(OOPT);

