% run dynare usmodel.mod
% calls mgnldnsty, mgnldnsty_fcast, sims_fcast
% ======================= initialise data % ===============================
load(options_.datafile);
dataset = [ ];

for i=1:size(options_.varobs,1)
    dataset = [dataset eval(deblank(options_.varobs(i,:)))];
end    


% ======================= marginal likelihood =============================
% VAR with training period: starting from 55 onwards
disp('VAR(1) train - start 55')
% ======================= initialise priors % =============================
    T0       = 40;
    maxnlags =  4;
    tau      =  0;
    d        =  0;
    lambda   =  0;    
    mu       =  0;
    omega    =  0;
    breaks   = [];
    train    = T0 ;%[];
    flat     = 0;

mnprior=[];
vprior=[];

% ======================= marg log dens % ====:============================


options_.first_obs_control =  options_.first_obs -T0  ;
options_.nobs_control      =  options_.nobs           ;
for lag = 1:maxnlags
    ydata = dataset(options_.first_obs_control+options_.presample-lag:options_.first_obs+options_.nobs-1,:);
    w=mgnldnsty(ydata,lag,ones(size(ydata,1),1),breaks,lambda,mu,mnprior,vprior,train,flat);
    disp(' ')
    fprintf('The marginal log density of the BVAR(%g) model is equal to %10.4f \n',lag,w);
    disp(' ')
end



% ======================= Forecast ========================================
% VAR without training period: starting from 65 onwards
disp('VAR(1) NO training - First difference - start 65')
% ======================= initialise data % ===============================
load(options_.datafile);
dataset = [ ];

for i=1:size(options_.varobs,1)
    dataset = [dataset eval(deblank(options_.varobs(i,:)))];
end    
% ======================= initialise priors % =============================
    T0       = 40;
    maxnlags =  4;
    tau      =  0;
    d        =  0;
    lambda   =  0;    
    mu       =  0;
    omega    =  0;
    breaks   = [];
    train    = T0 ;%[];
    flat     = 0;

mnprior=[];
vprior=[];

% ======================= marg log dens % ====:============================

options_.first_obs_control =  options_.first_obs ;
options_.nobs_control      =  options_.nobs      ;
for lag = 1:maxnlags
    ydata = dataset(options_.first_obs_control+options_.presample-lag:options_.first_obs+options_.nobs-1,:);
    w=mgnldnsty(ydata,lag,ones(size(ydata,1),1),breaks,lambda,mu,mnprior,vprior,train,flat);
    disp(' ')
    fprintf('The marginal log density of the BVAR(%g) model is equal to %10.4f \n',lag,w);
    disp(' ')
end

% =============================== start forecast ==========================
lag=1;
ydata = dataset(options_.first_obs_control+options_.presample-lag:options_.first_obs+options_.nobs-1,:);
forhor = 12;
forper = 60;
nobs = 7;
gend = size(ydata,1);
% ==================================================================================
% VAR n lags - URestr VAR - only cte 
% ==================================================================================
yhatmat=zeros(forhor,nobs,forper);
fcast_errormat=zeros(forhor,nobs,forper);
for i=gend-forper:gend
nhat=min(forhor,gend+1-i);
[w,yhat,fcast_error]=mgnldnsty_fcast(ydata,lag,ones(size(ydata,1),1),breaks,lambda,mu,mnprior,vprior,train,flat,i,nhat) ;
yhatmat(1:nhat,:,i-gend+forper+1)=yhat;
fcast_errormat(1:nhat,:,i-gend+forper+1)=fcast_error;
end
% =========================================================================
for jj = 1:forper;
    for ii=[1 2 3 6];
        for kk=2:forhor;
            fcast_errormat(kk,ii,jj)=fcast_errormat(kk-1,ii,jj)+fcast_errormat(kk,ii,jj);
        end;
    end;
end;
% =========================================================================
fcast_error1=zeros(forper,nobs);
for i=1:forper
fcast_error1(i,:)=fcast_errormat(1,:,i);
end
(mean(fcast_error1.^2)).^.5
(mean(fcast_error1(1:end-10,:).^2)).^.5

fcast_error2=zeros(forper-1,nobs);
for i=1:forper-1
fcast_error2(i,:)=fcast_errormat(2,:,i);
end
(mean(fcast_error2.^2)).^.5
(mean(fcast_error2(1:end-10,:).^2)).^.5

fcast_error4=zeros(forper-3,nobs);
for i=1:forper-3
fcast_error4(i,:)=fcast_errormat(4,:,i);
end
(mean(fcast_error4.^2)).^.5
(mean(fcast_error4(1:end-10,:).^2)).^.5

fcast_error8=zeros(forper-7,nobs);
for i=1:forper-7
fcast_error8(i,:)=fcast_errormat(8,:,i);
end
(mean(fcast_error8.^2)).^.5
(mean(fcast_error8(1:end-10,:).^2)).^.5

fcast_error12=zeros(forper-11,nobs);
for i=1:forper-11
fcast_error12(i,:)=fcast_errormat(12,:,i);
end
(mean(fcast_error12.^2)).^.5
(mean(fcast_error12(1:end-10,:).^2)).^.5

cvc1=log(det(cov(fcast_error1)));
cvc2=log(det(cov(fcast_error2)));
cvc4=log(det(cov(fcast_error4)));
cvc8=log(det(cov(fcast_error8)));
cvc12=log(det(cov(fcast_error12)));

cvu1=log(det(fcast_error1'*fcast_error1/(size(fcast_error1,1)-0)));
cvu2=log(det(fcast_error2'*fcast_error2/(size(fcast_error2,1)-0)));
cvu4=log(det(fcast_error4'*fcast_error4/(size(fcast_error4,1)-0)));
cvu8=log(det(fcast_error8'*fcast_error8/(size(fcast_error8,1)-0)));
cvu12=log(det(fcast_error12'*fcast_error12/(size(fcast_error12,1)-0)));

disp([ cvc1 cvc2 cvc4 cvc8 cvc12]);
disp([ cvu1 cvu2 cvu4 cvu8 cvu12]);



% ======================= Marginal likelihood =============================
% BVAR with explicit train: starting from 55 onwards
% stdev based on presample regression
disp('BVAR(4) with training (stdev presample) - start 55')
% ======================= initialise priors % =============================
load(options_.datafile);
dataset = [ ];

for i=1:size(options_.varobs,1)
    dataset = [dataset eval(deblank(options_.varobs(i,:)))];
end    
dataset(:,1)=cumsum(dataset(:,1));
dataset(:,2)=cumsum(dataset(:,2));
dataset(:,3)=cumsum(dataset(:,3));
dataset(:,6)=cumsum(dataset(:,6));
% ======================= initialise priors % =============================
    T0       = 40;
    maxnlags =  5;
    tau      =  10;
    d        =  1;
    lambda   =  5;    
    mu       =  2;
    omega    =  1;
    breaks   = [];
    train    = T0;
    flat     = 0;

mnprior.tight = tau;
mnprior.decay = d;

zdata=dataset;
yyprior = zdata(31:31+40,:);
yykprior = [ zdata(30:30+40,:) ];
yypriornobs = rows(yyprior);

ccprior = inv(yykprior'*yykprior)*yykprior'*yyprior;
errorAprior = yyprior-yykprior*ccprior;
sigprior=(errorAprior)'*errorAprior/(yypriornobs);
sigbvar_hat=sqrt(diag((errorAprior)'*errorAprior/(yypriornobs)))

vprior.sig=sigbvar_hat';       
vprior.w=1                        

% ======================= marg log dens % ====:============================

options_.first_obs_control =  options_.first_obs -T0 ;
options_.nobs_control      =  options_.nobs          ;
for lag = 1:maxnlags
    ydata = dataset(options_.first_obs_control+options_.presample-lag:options_.first_obs+options_.nobs-1,:);
    w=mgnldnsty(ydata,lag,ones(size(ydata,1),1),breaks,lambda,mu,mnprior,vprior,train+lag,flat);
    disp(' ')
    fprintf('The marginal log density of the BVAR(%g) model is equal to %10.4f \n',lag,w);
    disp(' ')
end




% ======================= forecast ========================================
% BVAR with explicit train: starting from 65 onwards
disp('BVAR(4) expl train (stdev presample) - start 65')
% ======================= initialise data % ===============================
load(options_.datafile);
dataset = [ ];

for i=1:size(options_.varobs,1)
    dataset = [dataset eval(deblank(options_.varobs(i,:)))];
end    
dataset(:,1)=cumsum(dataset(:,1));
dataset(:,2)=cumsum(dataset(:,2));
dataset(:,3)=cumsum(dataset(:,3));
dataset(:,6)=cumsum(dataset(:,6));
% ======================= initialise priors % =============================
    T0       = 40;
    maxnlags =  5;
    tau      =  10;
    d        =  1;
    lambda   =  5;    
    mu       =  2;
    omega    =  1;
    breaks   = [];
    train    = T0;
    flat     = 0;

mnprior.tight = tau;
mnprior.decay = d;
zdata=dataset;
yyprior = zdata(31:31+40,:);
yykprior = [ zdata(30:30+40,:) ];
yypriornobs = rows(yyprior);

ccprior = inv(yykprior'*yykprior)*yykprior'*yyprior;
errorAprior = yyprior-yykprior*ccprior;
sigprior=(errorAprior)'*errorAprior/(yypriornobs);
sigbvar_hat=sqrt(diag((errorAprior)'*errorAprior/(yypriornobs)))

vprior.sig=sigbvar_hat';     
vprior.w=1                   

% ======================= marg log dens % ====:============================

options_.first_obs_control =  options_.first_obs ;
options_.nobs_control      =  options_.nobs      ;
for lag = 1:maxnlags
    ydata = dataset(options_.first_obs_control+options_.presample-lag:options_.first_obs+options_.nobs-1,:);
    w=mgnldnsty(ydata,lag,ones(size(ydata,1),1),breaks,lambda,mu,mnprior,vprior,train+lag,flat);
    disp(' ')
    fprintf('The marginal log density of the BVAR(%g) model is equal to %10.4f \n',lag,w);
    disp(' ')
end

% =============================== start forecast ==========================
lag=4;
ydata = dataset(options_.first_obs_control+options_.presample-lag:options_.first_obs+options_.nobs-1,:);
forhor = 12;
forper = 60;
nobs = 7;
gend = size(ydata,1);
% ==================================================================================
% VAR n lags - URestr VAR - only cte 
% ==================================================================================
yhatmat=zeros(forhor,nobs,forper);
fcast_errormat=zeros(forhor,nobs,forper);
for i=gend-forper:gend
nhat=min(forhor,gend+1-i);
[w,yhat,fcast_error]=mgnldnsty_fcast(ydata,lag,ones(size(ydata,1),1),breaks,lambda,mu,mnprior,vprior,train+lag,flat,i,nhat) ;
yhatmat(1:nhat,:,i-gend+forper+1)=yhat;
fcast_errormat(1:nhat,:,i-gend+forper+1)=fcast_error;
end

% =========================================================================
fcast_error1=zeros(forper,nobs);
for i=1:forper
fcast_error1(i,:)=fcast_errormat(1,:,i);
end
(mean(fcast_error1.^2)).^.5
(mean(fcast_error1(1:end-10,:).^2)).^.5

fcast_error2=zeros(forper-1,nobs);
for i=1:forper-1
fcast_error2(i,:)=fcast_errormat(2,:,i);
end
(mean(fcast_error2.^2)).^.5
(mean(fcast_error2(1:end-10,:).^2)).^.5

fcast_error4=zeros(forper-3,nobs);
for i=1:forper-3
fcast_error4(i,:)=fcast_errormat(4,:,i);
end
(mean(fcast_error4.^2)).^.5
(mean(fcast_error4(1:end-10,:).^2)).^.5

fcast_error8=zeros(forper-7,nobs);
for i=1:forper-7
fcast_error8(i,:)=fcast_errormat(8,:,i);
end
(mean(fcast_error8.^2)).^.5
(mean(fcast_error8(1:end-10,:).^2)).^.5

fcast_error12=zeros(forper-11,nobs);
for i=1:forper-11
fcast_error12(i,:)=fcast_errormat(12,:,i);
end
(mean(fcast_error12.^2)).^.5
(mean(fcast_error12(1:end-10,:).^2)).^.5

cvc1=log(det(cov(fcast_error1)));
cvc2=log(det(cov(fcast_error2)));
cvc4=log(det(cov(fcast_error4)));
cvc8=log(det(cov(fcast_error8)));
cvc12=log(det(cov(fcast_error12)));

cvu1=log(det(fcast_error1'*fcast_error1/(size(fcast_error1,1)-0)));
cvu2=log(det(fcast_error2'*fcast_error2/(size(fcast_error2,1)-0)));
cvu4=log(det(fcast_error4'*fcast_error4/(size(fcast_error4,1)-0)));
cvu8=log(det(fcast_error8'*fcast_error8/(size(fcast_error8,1)-0)));
cvu12=log(det(fcast_error12'*fcast_error12/(size(fcast_error12,1)-0)));

disp([ cvc1 cvc2 cvc4 cvc8 cvc12]);
disp([ cvu1 cvu2 cvu4 cvu8 cvu12]);












