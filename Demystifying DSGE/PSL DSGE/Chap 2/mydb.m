
%% Getting US output through db.nomics
% quarterly real output
[my_mat,~,T] = call_dbnomics('OECD/QNA/USA.B1_GS1.LNBQRSA.Q');

% selecting the 2nd column to select GDP
gross_y = my_mat (:,2);
% Taking in logs
ln_y =  log(gross_y);


% computing the slope of the growth of output
% Using OLS
X = [ones(length(ln_y),1) (1:length(ln_y))'];
OLS= X\ln_y; % OLS regression
trend_y = X*OLS;
gamma = 1+OLS(2);



% deviation from the trend
ln_gap = ln_y-trend_y;
% demeaning // removing the steady state
y = ln_gap-mean(ln_gap);

% Plotting log(GDP) + trend
figure;
plot(T,ln_y,T,trend_y)
title('Real GDP 1940-now')
% Plotting GDP % variation around its trend
figure;
plot(T,y)
title('Real GDP variations around the trend')


save mydata.mat y T;
