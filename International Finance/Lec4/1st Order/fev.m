function [sigy,sigx] = fev(gx,hx,varshock,J)
%[sigy,sigx] = fev(gx,hx,varshock,J)
% Computes the forecasting-error variance matrix of x(t) at horizon J, that is 
%sigx=var[x(t+J)-E_tx(t+J)]
%and the forecasting-error variance matrix of 
%y(t), that is sigy=var(y(t+J)-E_ty(t+J)]
% where x(t) evolves as
% x(t+1) = hx x(t) + e(t+1)
%and y(t) evolves according to 
% y(t) = gx x(t)
%where Ee(t)e(t)'=varshock
%The parameter J can be any integer
%(c) Stephanie Schmitt-Grohe and Martin Uribe, August 18, 2007. 


if nargin<3
J=8;
end


sigx = hx*0;

for j=1:J
sigx = hx*sigx*hx' + varshock;
end

sigy = gx*sigx*gx';