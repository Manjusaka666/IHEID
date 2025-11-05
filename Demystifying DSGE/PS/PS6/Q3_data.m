%%
% make_AU_data.m
root = 'E:\IHEID Economics\IHEID\Demystifying DSGE\PS\PS6\jp-data\';
T = readtable(fullfile(root, 'Australian_Data.txt'), 'FileType', 'text', 'Delimiter', '\t');

% Map to observables used in the mod file
y_us = T.USYDEVQTR; % US output growth (already rate/dev)
pi_us = T.USCPILD400; % US CPI inflation (annualized)
i_us = T.USFFR; % US policy/FFR
y_au = T.AU_GDPRDEVQTR; % AU output growth
pi_au = T.AU_CPILD400; % AU CPI inflation (annualized)
i_au = T.AU_BB90; % AU interest rate
q_au = T.AUREERCPINEW; % AU real exchange rate
s_au = T.AU_GMTOTLD; % AU Terms of Trade

D = table(y_au, pi_au, i_au, q_au, s_au, y_us, pi_us, i_us);
writetable(D, fullfile(root, 'JP_Australian_Data.csv'));
