function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
% function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T             [#temp variables by 1]     double   vector of temporary terms to be filled by function
%   y             [#dynamic variables by 1]  double   vector of endogenous variables in the order stored
%                                                     in M_.lead_lag_incidence; see the Manual
%   x             [nperiods by M_.exo_nbr]   double   matrix of exogenous variables (in declaration order)
%                                                     for all simulation periods
%   steady_state  [M_.endo_nbr by 1]         double   vector of steady state values
%   params        [M_.param_nbr by 1]        double   vector of parameter values in declaration order
%   it_           scalar                     double   time period for exogenous variables for which
%                                                     to evaluate the model
%   T_flag        boolean                    boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   residual
%

if T_flag
    T = JP10.dynamic_resid_tt(T, y, x, params, steady_state, it_);
end
residual = zeros(15, 1);
    residual(1) = (y(13)-params(10)*y(1)) - (y(28)-y(13)*params(10)-T(1)*(y(15)-y(30)-x(it_, 3)+y(34)));
    residual(2) = (y(13)*(1-params(1))) - (y(14)-params(1)*params(7)*(2-params(1))*y(17)-params(1)*params(7)*y(21)-params(1)*y(23));
    residual(3) = (y(17)-y(5)) - (y(20)-y(19));
    residual(4) = (y(16)) - (y(21)+(1-params(1))*y(17));
    residual(5) = (y(19)-params(3)*y(6)) - (T(2)*(y(14)*params(8)-(1+params(8))*x(it_, 1)+params(1)*y(17)+(y(13)-params(10)*y(1))*T(1))+params(2)*(y(31)-y(19)*params(3)));
    residual(6) = (y(20)-params(4)*y(7)) - (y(21)*(1-params(6))/params(6)*(1-params(2)*params(6))+params(2)*(y(32)-y(20)*params(4))+x(it_, 5));
    residual(7) = (y(18)) - (y(19)+params(1)*(y(17)-y(5)));
    residual(8) = (y(15)-y(30)-(y(25)-y(33))) - (y(29)-y(16)-params(11)*y(22)-x(it_, 4));
    residual(9) = (y(13)+y(22)) - (y(14)+y(8)/params(2)-params(1)*(y(17)+y(21)));
    residual(10) = (y(15)) - (params(12)*y(3)+y(18)*params(13)+y(14)*params(14)+params(15)*(y(14)-y(2))+x(it_, 2));
    residual(11) = (y(23)) - (params(21)*y(9)+params(25)*x(it_, 6));
    residual(12) = (y(24)) - (params(22)*y(10)+params(24)*x(it_, 7));
    residual(13) = (y(25)) - (params(23)*y(11)+params(26)*x(it_, 8));
    residual(14) = (y(26)) - (y(24)+y(12)-(y(16)-y(4))-y(18));
    residual(15) = (y(27)) - (x(it_, 3));

end
