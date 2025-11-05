%% CK08_Fig2_2025.m
% Replicate CK (2008) Figure 2 using the EB run
% - Single model (EB)
% - Orthogonalized TFP shock (inno_z)
% - 4 panels: y, u, w, Pi
% - 20-month horizon (as in the TeX binder Fig. 2)

clear; clc;

%% Paths and data
filepart = 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS5';

% Load the EB model results (Dynare .mat produced by CK08_simEB.mod)
load(fullfile(filepart,'CK08_simEB','Output','CK08_simEB_results.mat'));   % provides oo_, M_, options_
OOPT.MODELS.oo_EB = oo_;    % keep the same container pattern as Fig 1 script

load(fullfile(filepart,'CK08_simRTM_q3','Output','CK08_simRTM_q3_results.mat'));   % provides oo_, M_, options_
OOPT.MODELS.oo_RTM = oo_;

%% Figure options (tailored to Fig. 2)
OOPT.NN            = 20;                             % 20 months horizon (Fig. 2)
OOPT.plot_color    = {'k','--r'};                          % single model (black)
OOPT.shocks_names  = {'inno_eta'};                   % Bargaining power shock ε_eta (binder Table 3)
OOPT.tit_shocks    = {'RTM vs. Bargaining power shock'};     % title label for the shock
OOPT.type_models   = {'oo_RTM','oo_EB'};                      % one model only
OOPT.legend_models = {'RTM','EB'};                         % legend label

% Panel variables and labels — match Fig. 2 order and titles
OOPT.list_endo       = {'y','u','w','Pi'};           % output, unemployment, real wage/hour, inflation
OOPT.label_variables = {'Output','Unemployment Rate','Real Wage per Hour','Inflation'};

%% Plot (reuse your existing multi-panel routine)
plot_comp(OOPT);    % Assumes plot_comp.m is on your MATLAB path

%% (Optional) Save figure with a descriptive name
% saveas(gcf, fullfile(filepart, 'CK08_Fig2_EB_TFP.pdf'));
% saveas(gcf, fullfile(filepart, 'Q3_Fig2_EB_TFP.png'));
