function [residual, T_order, T] = static_resid(y, x, params, T_order, T)
if nargin < 5
    T_order = -1;
    T = NaN(2, 1);
end
[T_order, T] = JP10.sparse.static_resid_tt(y, x, params, T_order, T);
residual = NaN(15, 1);
    residual(1) = (y(1)-y(1)*params(10)) - (y(1)-y(1)*params(10)-T(1)*(y(3)-y(6)-x(3)+y(15)));
    residual(2) = (y(1)*(1-params(1))) - (y(2)-params(1)*params(7)*(2-params(1))*y(5)-params(1)*params(7)*y(9)-params(1)*y(11));
    residual(3) = (0) - (y(8)-y(7));
    residual(4) = (y(4)) - (y(9)+(1-params(1))*y(5));
    residual(5) = (y(7)-y(7)*params(3)) - (T(2)*(y(2)*params(8)-(1+params(8))*x(1)+params(1)*y(5)+(y(1)-y(1)*params(10))*T(1))+(y(7)-y(7)*params(3))*params(2));
    residual(6) = (y(8)-y(8)*params(4)) - (y(9)*(1-params(6))/params(6)*(1-params(2)*params(6))+params(2)*(y(8)-y(8)*params(4))+x(5));
    residual(7) = (y(6)) - (y(7));
    residual(8) = (y(3)-y(6)-(y(13)-y(12))) - ((-(params(11)*y(10)))-x(4));
    residual(9) = (y(1)+y(10)) - (y(2)+y(10)/params(2)-params(1)*(y(5)+y(9)));
    residual(10) = (y(3)) - (y(3)*params(12)+y(6)*params(13)+y(2)*params(14)+x(2));
    residual(11) = (y(11)) - (y(11)*params(21)+params(25)*x(6));
    residual(12) = (y(12)) - (y(12)*params(22)+params(24)*x(7));
    residual(13) = (y(13)) - (y(13)*params(23)+params(26)*x(8));
    residual(14) = (y(14)) - (y(12)+y(14)-y(6));
    residual(15) = (y(15)) - (x(3));
end
