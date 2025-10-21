% %% Use SW Models

% % Q3
% load 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS3\SW2007_PS3_2025\Output\SW2007_PS3_2025_results.mat';
% Q4
% load 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS3\SW2007_PS3_2025_Q4\Output\SW2007_PS3_2025_Q4_results.mat';
% % Q5
% load 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS3\SW2007_PS3_2025_Q5\Output\SW2007_PS3_2025_Q5_results.mat';
% % Q6_Kimball
% load 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS3\SW2007_PS3_2025_Q6\Output\SW2007_PS3_2025_Q6_results.mat';
% % Q6_DS
% load 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS3\SW2007_PS3_2025_Q6_DS\Output\SW2007_PS3_2025_Q6_results.mat';
% % Q7
% load 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS3\SW2007_PS3_2025_Q7\Output\SW2007_PS3_2025_Q7_results.mat';
% % Q8_A
% load 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS3\SW2007_PS3_2025_Q8_A\Output\SW2007_PS3_2025_Q8_A_results.mat';
% % Q8_B
% load 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS3\SW2007_PS3_2025_Q8_B\Output\SW2007_PS3_2025_Q8_B_results.mat';
% % Q9
load 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS3\SW2007_PS3_2025_Q9_2\Output\SW2007_PS3_2025_Q9_2_results.mat';
oo_EHL = oo_;
periods = 40 ; % This number has to be identical to that used in producing the IRFs in the models above

%% === Figure: IRFs to "Demand" shocks (risk premium, exog. spending, investment-specific) ===
% Mapping of shocks to Dynare names:
%   Risk premium  -> 'eb'
%   Exog spending -> 'eg'
%   Investment-specific -> 'eqs'

%% ========================== Common setup ==========================
% Variables to show in each 2x2 panel (SW2007-style)
vars      = {'y','lab','pinf','r'};                         % output, hours, inflation, interest rate
varTitles = {'output','hours','inflation','interest rate'}; % subplot titles

% Output directory and filenames
outDir = 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS3';
if ~exist(outDir,'dir'); mkdir(outDir); end

%% ==================== Figure: Demand shocks (SW Fig. 2) ====================
% Shocks and labeling
codes_demand  = {'eb','eg','eqs'};                          % risk premium, exog spending, investment-specific
labels_demand = {'Risk premium','Exog spending','Investment shock'};

% Line styles (bold solid for risk premium, thin solid for exog spending, dashed for investment)
styles_demand = {'-','-','--'};
widths_demand = [1.8, 1.0, 1.5];

% Safe horizon based on available IRFs
T_dem = safeHorizon(vars, codes_demand, oo_EHL, periods);

% Plot and export
h_dem = makeIRFfigure(vars, varTitles, codes_demand, labels_demand, ...
                      styles_demand, widths_demand, T_dem, oo_EHL, ...
                      'The estimated mean impulse responses to "Demand" shocks');
exportgraphics(h_dem, fullfile(outDir, 'Q9_demand.pdf'), 'ContentType','vector');

%% =========== Figure: Wage mark-up shock (SW Fig. 3 naming style) ===========
% Single shock: wage mark-up (ew)
codes_wage   = {'ew'};
labels_wage  = {'Wage mark-up shock'};
styles_wage  = {'-'};
widths_wage  = [1.5];

T_wage = safeHorizon(vars, codes_wage, oo_EHL, periods);

h_wage = makeIRFfigure(vars, varTitles, codes_wage, labels_wage, ...
                       styles_wage, widths_wage, T_wage, oo_EHL, ...
                       'The estimated impulse response to a wage mark-up shock');
exportgraphics(h_wage, fullfile(outDir, 'Q9_wage.pdf'), 'ContentType','vector');

%% ======== Figure: Monetary policy shock (SW Fig. 6 naming style) ==========
% Single shock: monetary policy (em)
codes_mpol   = {'em'};
labels_mpol  = {'Monetary policy shock'};
styles_mpol  = {'-'};
widths_mpol  = [1.5];

T_mpol = safeHorizon(vars, codes_mpol, oo_EHL, periods);

h_mpol = makeIRFfigure(vars, varTitles, codes_mpol, labels_mpol, ...
                       styles_mpol, widths_mpol, T_mpol, oo_EHL, ...
                       'The impulse responses to a monetary policy shock');
exportgraphics(h_mpol, fullfile(outDir, 'Q9_monetary.pdf'), 'ContentType','vector');

%% ======================== Local helper functions ===========================
function T = safeHorizon(vars, shocks, oo_struct, periods)
    % Compute a safe horizon T (<= periods) based on the available IRFs.
    % Throws an error if no matching IRFs exist for the selected variables/shocks.
    T = periods;
    foundAny = false;
    for v = 1:numel(vars)
        for s = 1:numel(shocks)
            fld = [vars{v} '_' shocks{s}];
            if isfield(oo_struct.irfs, fld)
                foundAny = true;
                T = min(T, numel(oo_struct.irfs.(fld)));
            end
        end
    end
    if ~foundAny
        error('No matching IRFs found for the selected variables/shocks.');
    end
    if T < 1
        error('IRFs exist but contain no usable observations.');
    end
end

function h = makeIRFfigure(vars, varTitles, shockCodes, shockLabels, lineStyles, lineWidths, T, oo_struct, figTitle)
    % Generic 2x2 IRF panel plotter with SW2007-style titling
    h = figure('NumberTitle','off','Name',figTitle);
    for v = 1:numel(vars)
        subplot(2,2,v); hold on;
        for s = 1:numel(shockCodes)
            fld = [vars{v} '_' shockCodes{s}];
            if isfield(oo_struct.irfs, fld)
                series = oo_struct.irfs.(fld)(1:T);
                plot(0:T-1, series, lineStyles{s}, 'LineWidth', lineWidths(s));
            else
                warning('Missing IRF: %s', fld);
            end
        end
        yline(0,'k-'); grid on; box on;
        title(varTitles{v}, 'Interpreter','none');
        xlabel('quarters', 'Interpreter','none');
        ylabel('Deviation (percent)', 'Interpreter','none');
        xlim([0 T-1]);
        set(gca,'FontSize',12);
    end
    % Show legend (single-shock legends are okay for clarity)
    lg = legend(shockLabels,'Location','East'); set(lg,'Interpreter','none');
end


% Variables to plot (one per subplot)
% vars      = {'y','lab','pinf','r'};                            % output, hours, inflation, interest rate
% varTitles = {'output','hours','inflation','interest rate'};    % subplot titles
% 
% % Shocks to compare (each shock is a line in every subplot)
% shockCodes  = {'eb','eg','eqs'};
% shockLabels = {'Risk premium','Exog spending','Investment shock'};
% 
% % Line styles to match the paper note:
% %   bold solid (risk premium), thin solid (exog spending), dashed (investment)
% lineStyles = {'-','-','--'};
% lineWidths = [1.0, 1.0, 1.5];
% 
% % Determine a safe horizon T from available IRFs (do not exceed 'periods')
% T = periods;
% for v = 1:numel(vars)
%     for s = 1:numel(shockCodes)
%         fld = [vars{v} '_' shockCodes{s}];
%         if isfield(oo_EHL.irfs, fld)
%             T = min(T, numel(oo_EHL.irfs.(fld)));
%         end
%     end
% end
% if T < 1
%     error('No matching IRFs found for the selected variables/shocks.');
% end
% 
% % Create figure
% figure('NumberTitle','off','Name','Estimated mean IRFs to "Demand" shocks');
% 
% for v = 1:numel(vars)
%     subplot(2,2,v); hold on;
%     for s = 1:numel(shockCodes)
%         fld = [vars{v} '_' shockCodes{s}];
%         if isfield(oo_EHL.irfs, fld)
%             series = oo_EHL.irfs.(fld)(1:T);
%             plot(0:T-1, series, lineStyles{s}, 'LineWidth', lineWidths(s));
%         else
%             warning('Missing IRF: %s', fld);
%         end
%     end
%     yline(0,'k-'); grid on; box on;
%     title(varTitles{v}, 'Interpreter','none');
%     xlabel('quarters', 'Interpreter','none');                 % clear x-axis label
%     ylabel('Deviation (percent)', 'Interpreter','none');     % clear y-axis label
%     xlim([0 T-1]);
%     set(gca,'FontSize',12);
% end
% 
% % Legend (applies to all panels)
% lg = legend(shockLabels,'Location','East');
% set(lg,'Interpreter','none');
% 
% % Export PDF (keep your existing path variable 'outPDF')
% outPDF = fullfile('E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS3','Q9_2.pdf');
% exportgraphics(gcf, outPDF, 'ContentType','vector');


% X = zeros(7,periods); % Hours
% X(1,:)	=	oo_EHL.irfs.lab_ea	;
% X(2,:)	=	oo_EHL.irfs.lab_eb	;
% X(3,:)	=	oo_EHL.irfs.lab_eg	;
% X(4,:)	=	oo_EHL.irfs.lab_em	;
% X(5,:)	=	oo_EHL.irfs.lab_ew	;
% X(6,:)	=	oo_EHL.irfs.lab_epinf	;
% X(7,:)	=	oo_EHL.irfs.lab_eqs	;

% Y = zeros(7,periods); % Output
% Y(1,:)	=	oo_EHL.irfs.y_ea	;
% Y(2,:)	=	oo_EHL.irfs.y_eb	;
% Y(3,:)	=	oo_EHL.irfs.y_eg	;
% Y(4,:)	=	oo_EHL.irfs.y_em	;
% Y(5,:)	=	oo_EHL.irfs.y_ew	;
% Y(6,:)	=	oo_EHL.irfs.y_epinf	;
% Y(7,:)	=	oo_EHL.irfs.y_eqs	;

% Z = zeros(7,periods); % Inflation
% Z(1,:)	=	oo_EHL.irfs.pinf_ea	;
% Z(2,:)	=	oo_EHL.irfs.pinf_eb	;
% Z(3,:)	=	oo_EHL.irfs.pinf_eg	;
% Z(4,:)	=	oo_EHL.irfs.pinf_em	;
% Z(5,:)	=	oo_EHL.irfs.pinf_ew	;
% Z(6,:)	=	oo_EHL.irfs.pinf_epinf	;
% Z(7,:)	=	oo_EHL.irfs.pinf_eqs	;

% W = zeros(7,periods); % Interest rate
% W(1,:)	=	oo_EHL.irfs.r_ea	;
% W(2,:)	=	oo_EHL.irfs.r_eb	;
% W(3,:)	=	oo_EHL.irfs.r_eg	;
% W(4,:)	=	oo_EHL.irfs.r_em	;
% W(5,:)	=	oo_EHL.irfs.r_ew	;
% W(6,:)	=	oo_EHL.irfs.r_epinf	;
% W(7,:)	=	oo_EHL.irfs.r_eqs	;

% % === 新增：Consumption 与 Investment 的 IRFs 收集 ===
% C = zeros(7,periods); % Consumption
% C(1,:) = oo_EHL.irfs.c_ea;
% C(2,:) = oo_EHL.irfs.c_eb;
% C(3,:) = oo_EHL.irfs.c_eg;
% C(4,:) = oo_EHL.irfs.c_em;
% C(5,:) = oo_EHL.irfs.c_ew;
% C(6,:) = oo_EHL.irfs.c_epinf;
% C(7,:) = oo_EHL.irfs.c_eqs;

% I = zeros(7,periods); % Investment
% I(1,:) = oo_EHL.irfs.inve_ea;
% I(2,:) = oo_EHL.irfs.inve_eb;
% I(3,:) = oo_EHL.irfs.inve_eg;
% I(4,:) = oo_EHL.irfs.inve_em;
% I(5,:) = oo_EHL.irfs.inve_ew;
% I(6,:) = oo_EHL.irfs.inve_epinf;
% I(7,:) = oo_EHL.irfs.inve_eqs;

% %titles = ['RiskPremium';'ExogSpending';'InvestSpecific'];

% %'RiskPremium '; % 2
% %'ExogSpending'; % 3
% %'InvestSpecif'; % 7

% titles(1,:) ='Output      '; % Y
% titles(2,:) ='Hours       '; % X
% titles(3,:) ='Inflation   '; % Z
% titles(4,:) ='InterestRate'; % W

% % === 七个冲击的名字（课堂顺序） ===
% shockNames = {'TFP','Risk premium','Exog spending', ...
%               'Monetary policy','Wage markup', ...
%               'Price markup','InvestSpecific'};

% figure('NumberTitle','off','Name','IRFs per shock: Y vs C vs Inv');
%     % 1) ea
%     subplot(4,2,1)
%     plot(1:1:periods, Y(1,:),'-b', 1:1:periods, C(1,:),'-r', 1:1:periods, I(1,:),'-k','LineWidth',1.5)
%     title(shockNames{1});

%     % 2) eb
%     subplot(4,2,2)
%     plot(1:1:periods, Y(2,:),'-b', 1:1:periods, C(2,:),'-r', 1:1:periods, I(2,:),'-k','LineWidth',1.5)
%     title(shockNames{2});

%     % 3) eg
%     subplot(4,2,3)
%     plot(1:1:periods, Y(3,:),'-b', 1:1:periods, C(3,:),'-r', 1:1:periods, I(3,:),'-k','LineWidth',1.5)
%     title(shockNames{3});

%     % 4) em
%     subplot(4,2,4)
%     plot(1:1:periods, Y(4,:),'-b', 1:1:periods, C(4,:),'-r', 1:1:periods, I(4,:),'-k','LineWidth',1.5)
%     title(shockNames{4});

%     % 5) ew
%     subplot(4,2,5)
%     plot(1:1:periods, Y(5,:),'-b', 1:1:periods, C(5,:),'-r', 1:1:periods, I(5,:),'-k','LineWidth',1.5)
%     title(shockNames{5});

%     % 6) epinf
%     subplot(4,2,6)
%     plot(1:1:periods, Y(6,:),'-b', 1:1:periods, C(6,:),'-r', 1:1:periods, I(6,:),'-k','LineWidth',1.5)
%     title(shockNames{6});

%     % 7) eqs
%     subplot(4,2,7)
%     plot(1:1:periods, Y(7,:),'-b', 1:1:periods, C(7,:),'-r',  1:1:periods, I(7,:),'-k','LineWidth',1.5)
%     title(shockNames{7});

% ll = legend('Y','C','Inv');
% set(ll,'Location','East');

% % Export PDF
% outPDF = fullfile('E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS3','Q8.pdf');
% % Change the file name above as needed
% exportgraphics(gcf, outPDF, 'ContentType','vector');