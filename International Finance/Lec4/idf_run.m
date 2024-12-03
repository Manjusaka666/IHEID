%IDF_RUN.M
%Compute numerically a first-order approximation, second moments, and impulse responses  
%implied by  the Small Open Economy Model With An Internal Discount Factor  in chapter 4 
%of ``Open Economy Macroeconomics,'' by Martin Uribe and Stephanie Schmitt-Grohe, 2013.

clear all

idf_ss

idf_num_eval %this .m script was created by running idf_model.m 


%The linearized equilibrium system is of the form
%y_t=gx x_t
%x_t+1 = hx x_t + ETASHOCK epsilon_t+1
[gx, hx, exitflag] = gx_hx(nfy, nfx, nfyp, nfxp);


nx = size(hx,1); %number of states

%Variance/Covariance matrix of innovation to state vector x_t
varshock = nETASHOCK*nETASHOCK';

%Position of variables in the control vector
nc = 1; %consumption
nivv = 2; %investment
noutput = 3; %output
nh = 4; %hours
ntb = 8; %trade balance
ntby = 9; %trade-balance-to-output ratio
nca = 10; %current account
ncay = 11; %current-account-to-output ratio
%Position of variables in the state vector

nd = 1; %debt
nk = 2; %capital
na = 3;%tech shock

%standard deviations
 [sigy0,sigx0]=mom(gx,hx,varshock);
stds = sqrt(diag(sigy0));

%correlations with output
corr_xy = sigy0(:,noutput)./stds(noutput)./stds;

%serial correlations
 [sigy1,sigx1]=mom(gx,hx,varshock,1);
scorr = diag(sigy1)./diag(sigy0);

%make a table containing second moments
num_table = [stds*100  scorr corr_xy];

%From this table, select variables of interest (output, c, ivv, h, tby, cay)
disp('In This table:')
disp('Rows: y,c,i, h, tb/y,ca/y')
disp('Columns: std, serial corr.,  corr with y')
num_table1 = num_table([noutput nc nivv nh ntby  ncay],:);

disp(num_table1)




%Compute Impulse Responses
T = 11; %number of periods for impulse responses
%Give a unit innovation to TFP
x0 = zeros(nx,1);
x0(end) = 0.01;
%Compute Impulse Response
[IR IRy IRx]=ir(gx,hx,x0,T);

%Plot Impulse responses
t=(0:T-1)';
clf 
subplot(3,2,1)
hold on 
plot(t,IR(:,noutput)*100)
title('Output')

subplot(3,2,2)
hold on 
plot(t,IR(:,nc)*100)
title('Consumption')

subplot(3,2,3)
hold on 
plot(t,IR(:,nivv)*100)
title('Investment')

subplot(3,2,4)
hold on 
plot(t,IR(:,nh)*100)
title('Hours')

subplot(3,2,5)
hold on 
plot(t,IR(:,ntby)*100)
title('Trade Balance / Output')

subplot(3,2,6)
hold on 
plot(t,IR(:,ncay)*100)
title('Current Account/Output')
shg