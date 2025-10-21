%% Cai4PS4_Q2_compare.m
% Q2 (SW 1965Q1–2004Q4): WITH vs WITHOUT 'sobs'
% - Load two Dynare result files (absolute paths provided below)
% - Compare IRFs across key shocks using your plot_comp(OOPT)
% - Save each shock's panel as a standalone PDF
% - Also build a single multi-page PDF that appends all shocks in order
%
% NOTE:
% - No variance decomposition is computed or exported here (Dynare already produced the .tex table).
% - Requires plot_comp.m on the MATLAB path.

clear; clc;

%% --------- Absolute paths to your two .mat results ----------
file_withSOBS = 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS4\Cai_4PS4\Output\Cai_4PS4_results.mat';          % WITH sobs
file_noSOBS   = 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS4\Cai_4PS4_Q2v2\Output\Cai_4PS4_Q2v2_results.mat'; % WITHOUT sobs

outdir = 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS4\Q2_compare_outputs';
if ~exist(outdir,'dir'), mkdir(outdir); end

%% --------- Load results (no workspace pollution) ----------
S_with = load(file_withSOBS);
S_none = load(file_noSOBS);

req = {'oo_','M_','options_'};
for k = 1:numel(req)
    assert(isfield(S_with, req{k}),  'Missing %s in WITH-sobs file.',   req{k});
    assert(isfield(S_none, req{k}),  'Missing %s in NO-sobs file.',     req{k});
end
fprintf('Loaded WITH:    %s\n', file_withSOBS);
fprintf('Loaded WITHOUT: %s\n', file_noSOBS);

%% --------- Build OOPT for plot_comp ----------
OOPT = struct();
OOPT.NN            = 40;                         % IRF horizon (quarters)
OOPT.plot_color    = {'b','--r'};                % with=blue, without=red dashed
OOPT.type_models   = {'oo_withSOBS','oo_noSOBS'};
OOPT.legend_models = {'With sobs','Without sobs'};
OOPT.MODELS = struct();
OOPT.MODELS.oo_withSOBS = S_with.oo_;
OOPT.MODELS.oo_noSOBS   = S_none.oo_;

% Variables/panels to show
OOPT.list_endo = {'y','c','inve','k','w','lab','r','pinf'};
OOPT.label_variables = {'Output','Consumption','Investment','Capital Services', ...
                        'Wage Rate','Hours','Interest Rate','Inflation'};

% Shocks to compare for Q2
shock_blocks = {
    {'ea'},     {'TFP'};
    {'eb'},     {'Risk premium'};
    {'eg'},     {'Exogenous spending'};
    {'em'},     {'MonPol'};
    {'ew'},     {'Wage Markup'};
    {'epinf'},  {'Price Markup'};
    {'eqs'},    {'Investment-specific'};
};

% A consolidated multi-page PDF (all shocks appended)
combined_pdf = fullfile(outdir, 'IRFs_Q2.pdf');
if exist(combined_pdf, 'file'); delete(combined_pdf); end

%% --------- Plot & save (PDF) ----------
for i = 1:size(shock_blocks,1)
    OOPT.shocks_names = shock_blocks{i,1};
    OOPT.tit_shocks   = shock_blocks{i,2};
    safe_title = regexprep(OOPT.tit_shocks{1}, '\s+', '_');

    % Draw panel via your utility
    try
        f = figure('Color','w'); %#ok<LFIG>
        plot_comp(OOPT);
        drawnow;

        % Per-shock standalone PDF
        single_pdf = fullfile(outdir, sprintf('IRF_%s_sobs_vs_nosobs.pdf', safe_title));
        saved = false;
        try
            exportgraphics(gcf, single_pdf, 'ContentType','vector','BackgroundColor','white');
            saved = true;
        catch
            % Fallback for older MATLAB
            try
                set(gcf, 'PaperPositionMode','auto');
                print(gcf, single_pdf, '-dpdf', '-painters');
                saved = true;
            catch
            end
        end
        if ~saved
            warning('Failed to save PDF: %s', single_pdf);
        end

        % Append to combined multi-page PDF (R2020a+)
        try
            exportgraphics(gcf, combined_pdf, 'ContentType','vector','BackgroundColor','white', 'Append', true);
        catch
            % If append not supported, silently skip
        end

    catch ME
        warning('plot_comp failed for shocks %s: %s', strjoin(OOPT.shocks_names,','), ME.message);
    end

    % Close to keep things tidy
    try, close(f); end %#ok<TRYNC>
end

fprintf('\n[Q2] PDFs written to: %s\n', outdir);
fprintf(' - Individual: IRF_<Shock>_sobs_vs_nosobs.pdf\n');
fprintf(' - Combined:   IRFs_Q2.pdf\n');