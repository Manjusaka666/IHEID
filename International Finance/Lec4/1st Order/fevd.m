function [fevdy,fevdx]=fevd(gx, hx, ETA, J)
%function [fevdy,fevdx]=fevd(gx, hx, ETA, J)
% Computes the forecasting-error variance decomposition of y(t) and x(t)  at forecasting horizon J. The (n_x by 1) vector x(t) and (n_y by 1) vector y(t) evolve according to
% x(t+1) = hx x(t) + ETA* e(t+1)
% y(t) = gx x(t)
%where the (n_e by 1) vector e(t) ~N(0,I), and the (n_x by n_e) matrix ETA governs the volatility of the system.
%Output: 
%fevdx is a matrix of size n_e by n_x.
%fevdy is a matrix of size n_e by n_y. 
% fevdy(i,k) is the share of the variance of the J-period ahead forecasting error variance of element  k of vector y_t attributable to element i vector e(t) 
%fevdx(i,k)=var [x(k, t+J)-E_t x(k, t+J)| ETA(:,m)=0 for all m neq i ]/var [x(k, t+J)-E_t x(k, t+J)]
%fevdy(i,k)=var [y(k, t+J)-E_t y(k, t+J)| ETA(:,m)=0 for all m neq i ]/var [y(k, t+J)-E_t y(k, t+J)]
%The forecasting horizon  J is a postive integer
%(c) Stephanie Schmitt-Grohe and Martin Uribe, June 23, 2009. 


ne = size(ETA,2);
nx = size(hx,1);
ny= size(gx,1);

[fevy,fevx]= fev(gx,hx,ETA*ETA',J);
fevy = diag(fevy)';
fevx = diag(fevx)';


for i=1:ne
ETAi = ETA*0;
ETAi(:, i) = ETA(:,i);
[sigy,sigx] = fev(gx,hx,ETAi*ETAi',J);
fevdx(i,1:nx)= diag(sigx)'./fevx;
fevdy(i,1:ny)= diag(sigy)'./fevy;
end