% run_both_SW2007.m
clear; clc;

% -------- Part A: 1966Q2–1979Q2 ------------
dynare SW2007_PS3_2025_Q8 -DMODECOMPUTE=5 -DFIRST_OBS=6 -DNOBS=53 noclearall

% 快照 A
ooA_           = oo_;
M_A            = M_;
options_A      = options_;
estim_params_A = estim_params_;
bayestopt_A    = bayestopt_;
if exist('dataset_','var'), dataset_A = dataset_; else, dataset_A = []; end

if ~exist('Results/PartA','dir'), mkdir('Results/PartA'); end
save('Results/PartA/Workspace_A.mat','ooA_','M_A','options_A','estim_params_A','bayestopt_A','dataset_A');

% -------- Part B: 1984Q1–2004Q4 ------------
dynare SW2007_PS3_2025_Q8 -DMODECOMPUTE=1 -DFIRST_OBS=77 -DNOBS=84 noclearall

% 快照 B
ooB_           = oo_;
M_B            = M_;
options_B      = options_;
estim_params_B = estim_params_;
bayestopt_B    = bayestopt_;
if exist('dataset_','var'), dataset_B = dataset_; else, dataset_B = []; end

if ~exist('Results/PartB','dir'), mkdir('Results/PartB'); end
save('Results/PartB/Workspace_B.mat','ooB_','M_B','options_B','estim_params_B','bayestopt_B','dataset_B');

% -------- 画图（与你的 plot_comp 匹配） ------------
OOPT = struct();
OOPT.type_models  = {'ooA_','ooB_'};
OOPT.MODELS.ooA_  = ooA_;
OOPT.MODELS.ooB_  = ooB_;
OOPT.list_endo    = {'pinf','y','inve','r','w','lab'};   % 与 oo?.irfs 的字段一致
OOPT.shocks_names = {'em','ea','eqs','epinf'};           % 货币、TFP、投资技、价格加成
OOPT.NN = 40;
OOPT.legend_models   = {'1966–79 (A)','1984–2004 (B)'};
OOPT.label_variables = {'Inflation','Output','Investment','i (nominal)','w (real)','Hours'};
OOPT.tit_shocks      = {'Monetary','TFP','Inv.-spec tech','Price markup'};
OOPT.plot_color      = {'b','k'};
plot_comp(OOPT);
