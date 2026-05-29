
close all

var y_obs pi_obs r_obs;
varobs y_obs pi_obs r_obs;

bvar_density(datafile=mydata,
presample=15, prefilter=1, first_obs=1
,xls_range=B1:D183, noconstant) 4;
bvar_irf(4,'SquareRoot');