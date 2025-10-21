
% q5_apply_mode_from_mat.m
% ---------------------------------------------------------------
% Q5 (Option B): Apply posterior MODE parameters from the saved MAT file
% and re-create the SW(2007) Figure 2-style IRFs.
%
% Usage (Matlab):
%   dynare usmodel_q3.mod noclearall
%   q5_apply_mode_from_mat
%
% This script expects:
%   - usmodel_q3.mod already parsed (so M_, options_, oo_ exist)
%   - /mnt/data/usmodel_mode.mat containing xparam1 (36x1) in the exact
%     order of the estimated_params block shown in your PS file.
%   - /mnt/data/usmodel_data.mat for the observables (optional load).
%
% It will:
%   (1) Load xparam1
%   (2) Map names -> values
%   (3) set_param_value for structural parameters
%   (4) Update shock std. devs in M_.Sigma_e
%   (5) Recompute derived parameters (same formulas as in the .mod file)
%   (6) Re-run stoch_simul and plot with make_fig2.m
%
% ---------------------------------------------------------------

% --- 0) Safety checks
if ~exist('M_','var') || ~isstruct(M_)
    error('Please run: dynare usmodel_q3.mod noclearall  (first)');
end

% --- 1) Load mode vector (posterior MODE)
modeFile = '/mnt/data/usmodel_mode.mat';
if ~exist(modeFile,'file')
    error('Mode file not found: %s', modeFile);
end
S = load(modeFile);   % expects S.xparam1 (36x1)
if ~isfield(S,'xparam1')
    error('xparam1 not found in %s', modeFile);
end
xparam1 = S.xparam1(:);
if numel(xparam1)~=36
    error('Expected 36-mode parameters, found %d.', numel(xparam1));
end

% (optional) Load observables file (not strictly needed here)
dataFile = '/mnt/data/usmodel_data.mat';
if exist(dataFile,'file')
    try
        D = load(dataFile);
    catch
        % ignore
    end
end

% --- 2) Names in the EXACT order of the estimated_params block (36 entries)
names = {
  'stderr_ea'
  'stderr_eb'
  'stderr_eg'
  'stderr_eqs'
  'stderr_em'
  'stderr_epinf'
  'stderr_ew'
  'crhoa'
  'crhob'
  'crhog'
  'crhoqs'
  'crhoms'
  'crhopinf'
  'crhow'
  'cmap'
  'cmaw'
  'csadjcost'
  'csigma'
  'chabb'
  'cprobw'
  'csigl'
  'cprobp'
  'cindw'
  'cindp'
  'czcap'
  'cfc'
  'crpi'
  'crr'
  'cry'
  'crdy'
  'constepinf'
  'constebeta'
  'constelab'
  'ctrend'
  'cgy'
  'calfa'
};

% Sanity
if numel(names) ~= numel(xparam1)
    error('Mismatch names (%d) vs xparam1 (%d).', numel(names), numel(xparam1));
end

% --- 3) Apply structural parameters & constants
% Note: we treat "stderr_*" separately in the next step.
for i = 1:numel(names)
    nm = names{i};
    val = xparam1(i);
    if startsWith(nm,'stderr_')
        continue; % handle later
    end
    try
        set_param_value(nm, val);
    catch ME
        error('Failed set_param_value(%s, %g): %s', nm, val, ME.message);
    end
end

% --- 4) Update shock std devs in M_.Sigma_e
% Expected exo names: ea eb eg eqs em epinf ew
exo_names = cellstr(M_.exo_names);
sigmas2 = diag(M_.Sigma_e);  % current variances
for i = 1:numel(names)
    nm = names{i};
    if startsWith(nm,'stderr_')
        shock = extractAfter(nm,'stderr_'); % e.g., 'ea'
        idx = find(strcmp(exo_names, shock), 1);
        if isempty(idx)
            error('Shock %s (from %s) not found in M_.exo_names.', shock, nm);
        end
        sd = xparam1(i);
        sigmas2(idx) = sd.^2;
    end
end
M_.Sigma_e = diag(sigmas2);

% --- 5) Recompute "derived from steady state" parameters
% Copy of the formulas from the .mod file (usmodel_q5 snippet):
% (They must be recomputed because set_param_value changed their inputs.)
% REQUIRED inputs: ctou, clandaw, cg, curvp, curvw [fixed in .mod]
%                  calfa, cgamma, cbeta, csigma, cpie, cfc, cgy
% Make sure they exist in the workspace (defined by the .mod).
reqs = {'ctou','clandaw','cg','curvp','curvw','calfa','cgamma','cbeta','csigma','cpie','cfc','cgy'};
missing = reqs(~cellfun(@(x) evalin('base',sprintf('exist(''%s'',''var'')',x)), reqs));
if ~isempty(missing)
    warning('Some required parameters not found in base workspace: %s', strjoin(missing,', '));
end
% Derived parameters
clandap = cfc;
cbetabar = cbeta*cgamma^(-csigma);
cr = cpie/(cbeta*cgamma^(-csigma));
crk = (cbeta^(-1))*(cgamma^csigma) - (1-ctou);
cw = (calfa^calfa*(1-calfa)^(1-calfa)/(clandap*crk^calfa))^(1/(1-calfa));
cikbar = (1-(1-ctou)/cgamma);
cik = (1-(1-ctou)/cgamma)*cgamma;
clk = ((1-calfa)/calfa)*(crk/cw);
cky = cfc*(clk)^(calfa-1);
ciy = cik*cky;
ccy = 1-cg-cik*cky;
crkky = crk*cky;
cwhlc = (1/clandaw)*(1-calfa)/calfa*crk*cky/ccy;
cwly = 1-crk*cky;

% Push them into Dynare parameter space
set_param_value('clandap',clandap);
set_param_value('cbetabar',cbetabar);
set_param_value('cr',cr);
set_param_value('crk',crk);
set_param_value('cw',cw);
set_param_value('cikbar',cikbar);
set_param_value('cik',cik);
set_param_value('clk',clk);
set_param_value('cky',cky);
set_param_value('ciy',ciy);
set_param_value('ccy',ccy);
set_param_value('crkky',crkky);
set_param_value('cwhlc',cwhlc);
set_param_value('cwly',cwly);

% These constants are *also* estimated (we already set constepinf, constelab via xparam1).
% conster depends on cr (which we just updated):
conster = (cr-1)*100;
set_param_value('conster',conster);
% ctrend, constepinf, constelab were set from xparam1 above.

% --- 6) Re-run simulation
options_.irf = 40;
var_list_ = char('y','c','inve','pinf','r','w','k','lab');
info = stoch_simul(var_list_);

% Save results for your plotting
save('usmodel_q5_results.mat','oo_','M_','options_','var_list_');

% --- 7) Reproduce Fig.2-style panels
try
    make_fig2;
catch ME
    warning('Plotting failed: %s. You can call make_fig2 after load usmodel_q5_results.mat', ME.message);
end

disp('Q5 complete: posterior MODE applied from usmodel_mode.mat and IRFs generated.');
