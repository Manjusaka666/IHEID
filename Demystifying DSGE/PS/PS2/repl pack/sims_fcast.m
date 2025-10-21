function  yhat = fcast(y0,By,Bx,xdata,horiz)
%function  yhat = fcast(y0,By,Bx,xdata,horiz)
[lags,nvar]=size(y0);
nx=size(Bx,2);
yhat=zeros(horiz+lags,nvar);
yhat(1:lags,:)=y0;
% By is equations x variables x lags
Bmat=permute(By,[3,2,1]);
Bmat=flipdim(Bmat,1);
Bmat=reshape(Bmat,lags*nvar,nvar);
Bx=Bx;
for it=1:horiz
    ydata=yhat(it:it+lags-1,:);
    yhat(lags+it,:)=sum(Bmat.*repmat(ydata(:),1,nvar))+xdata(lags+it,:)*Bx';
end
yhat=yhat(1+lags:end,:);
