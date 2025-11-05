function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(2, 1);
end
[T_order, T] = JP10.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(15, 1);
    residual(1) = (y(16)-params(10)*y(1)) - (y(31)-y(16)*params(10)-T(1)*(y(18)-y(36)-x(3)+y(45)));
    residual(2) = (y(16)*(1-params(1))) - (y(17)-params(1)*params(7)*(2-params(1))*y(20)-params(1)*params(7)*y(24)-params(1)*y(26));
    residual(3) = (y(20)-y(5)) - (y(23)-y(22));
    residual(4) = (y(19)) - (y(24)+(1-params(1))*y(20));
    residual(5) = (y(22)-params(3)*y(7)) - (T(2)*(y(17)*params(8)-(1+params(8))*x(1)+params(1)*y(20)+(y(16)-params(10)*y(1))*T(1))+params(2)*(y(37)-y(22)*params(3)));
    residual(6) = (y(23)-params(4)*y(8)) - (y(24)*(1-params(6))/params(6)*(1-params(2)*params(6))+params(2)*(y(38)-y(23)*params(4))+x(5));
    residual(7) = (y(21)) - (y(22)+params(1)*(y(20)-y(5)));
    residual(8) = (y(18)-y(36)-(y(28)-y(42))) - (y(34)-y(19)-params(11)*y(25)-x(4));
    residual(9) = (y(16)+y(25)) - (y(17)+y(10)/params(2)-params(1)*(y(20)+y(24)));
    residual(10) = (y(18)) - (params(12)*y(3)+y(21)*params(13)+y(17)*params(14)+params(15)*(y(17)-y(2))+x(2));
    residual(11) = (y(26)) - (params(21)*y(11)+params(25)*x(6));
    residual(12) = (y(27)) - (params(22)*y(12)+params(24)*x(7));
    residual(13) = (y(28)) - (params(23)*y(13)+params(26)*x(8));
    residual(14) = (y(29)) - (y(27)+y(14)-(y(19)-y(4))-y(21));
    residual(15) = (y(30)) - (x(3));
end
