% apply_sw_mode_params.m — Q5 helper for posterior MODE parameters (SW 2007)
% Run after: dynare usmodel_q3.mod noclearall
params = struct();
params.csigma = 1.38;  % σ_c
params.chabb  = 0.71;  % h
params.cprobp = 0.652; % ξ_p
params.cindp  = 0.243; % ι_p
params.csigl  = 1.84;  % σ_l
params.cprobw = 0.706; % ξ_w
params.cindw  = 0.585; % ι_w
params.crr    = 0.878;
params.crpi   = 1.729;
params.crdy   = 0.321;
params.cry    = 0.089;
params.crhoa   = 0.997;
params.crhob   = 0.860;
params.crhog   = 0.950;
params.crhols  = 0.948;
params.crhoqs  = 0.877;
params.crhoms  = 0.500;
params.crhopinf= 0.889;
params.crhow   = 0.954;
names = fieldnames(params);
for i=1:numel(names), set_param_value(names{i}, params.(names{i})); end
disp('Applied posterior-mode parameters (approximate). Now re-run stoch_simul.');