%for JP2010 model 
%Comparing IRF under different calibration
clear;
clc;

filepart = 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS6\';


load(fullfile(filepart,'JP2010_Q6\Output','JP2010_Q6_results.mat'));
OOPT.MODELS.oo_EHL = oo_;
load(fullfile(filepart,'JP2010_Q5\Output','JP2010_Q5_results.mat'));
OOPT.MODELS.oo_EHL1 = oo_;
% load(fullfile(filepart,'JP2010_Q8a\Output','JP2010_Q8a_results.mat'));
% OOPT.MODELS.oo_EHL1 = oo_;
% load(fullfile(filepart,'JP2010_Q8b\Output','JP2010_Q8b_results.mat'));
% OOPT.MODELS.oo_EHL2 = oo_;
% load(fullfile(filepart,'JP2010_Q7a\Output','JP2010_Q7a_results.mat'));
% OOPT.MODELS.oo_EHL1 = oo_;
% load(fullfile(filepart,'JP2010_Q7b\Output','JP2010_Q7b_results.mat'));
% OOPT.MODELS.oo_EHL2 = oo_;
% load(fullfile(filepart,'JP2010_Q9\Output','JP2010_Q9_results.mat'));
% OOPT.MODELS.oo_EHL1 = oo_;
% load(fullfile(filepart,'JP2010_Q9b\Output','JP2010_Q9b_results.mat'));
% OOPT.MODELS.oo_EHL2 = oo_;

% load 'J:\...Q3\Output\JP2010_Q3_results';
% OOPT.MODELS.oo_EHL = oo_;
% load 'J:\...Q6a\Output\JP2010_Q4_results';
% OOPT.MODELS.oo_EHL1 = oo_;
% load 'J:\...Q6a\Output\JP2010_Q6a_results';
% OOPT.MODELS.oo_EHL2 = oo_;
% load 'J:\...Q6b\Output\JP2010_Q6b_results';
% OOPT.MODELS.oo_EHL3 = oo_;

OOPT.NN=20;
OOPT.plot_color={'b' '--k'}
% 'g' 'r'
OOPT.shocks_names={'epsilon_i'};
OOPT.tit_shocks={'MonPol Shock'};
OOPT.type_models={'oo_EHL' 'oo_EHL1'};
%'oo_EHL3' 'oo_EHL2'
OOPT.legend_models={'Q6','Q5'}
% ,'v4','Q7b'
OOPT.list_endo={'y' 'c' 'i' 'pi' 'pi_h' 'pi_f' 'de' 'nfa' 'mc'};
OOPT.label_variables={'Output' 'Consumption' 'Investment' 'Inflation' 'Home inflation' 'Foreign inflation' 'Exchange rate Growth' 'Net Foreign Assets' 'Marginal cost'};
plot_comp(OOPT);

