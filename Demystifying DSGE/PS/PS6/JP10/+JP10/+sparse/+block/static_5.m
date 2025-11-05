function [y, T, residual, g1] = static_5(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(9, 1);
  residual(1)=(y(7)-y(7)*params(3))-((1-params(5))/params(5)*(1-params(5)*params(2))*(y(2)*params(8)-(1+params(8))*x(1)+params(1)*y(5)+(y(1)-y(1)*params(10))*(1-params(10))/params(9))+(y(7)-y(7)*params(3))*params(2));
  residual(2)=(y(8)-y(8)*params(4))-(y(9)*(1-params(6))/params(6)*(1-params(2)*params(6))+params(2)*(y(8)-y(8)*params(4))+x(5));
  residual(3)=(y(6))-(y(7));
  residual(4)=(y(3)-y(6)-(y(13)-y(12)))-((-(params(11)*y(10)))-x(4));
  residual(5)=(y(1)+y(10))-(y(2)+y(10)/params(2)-params(1)*(y(5)+y(9)));
  residual(6)=(y(3))-(y(3)*params(12)+y(6)*params(13)+y(2)*params(14)+x(2));
  residual(7)=(y(1)-y(1)*params(10))-(y(1)-y(1)*params(10)-(1-params(10))/params(9)*(y(3)-y(6)-x(3)+y(15)));
  residual(8)=(y(1)*(1-params(1)))-(y(2)-params(1)*params(7)*(2-params(1))*y(5)-params(1)*params(7)*y(9)-params(1)*y(11));
  residual(9)=(0)-(y(8)-y(7));
if nargout > 3
    g1_v = NaN(27, 1);
g1_v(1)=(-((1-params(5))/params(5)*(1-params(5)*params(2))*params(8)));
g1_v(2)=(-1);
g1_v(3)=(-params(14));
g1_v(4)=(-1);
g1_v(5)=(-((1-params(6))/params(6)*(1-params(2)*params(6))));
g1_v(6)=params(1);
g1_v(7)=params(1)*params(7);
g1_v(8)=1-params(3)-params(2)*(1-params(3));
g1_v(9)=(-1);
g1_v(10)=1;
g1_v(11)=1;
g1_v(12)=(-1);
g1_v(13)=(-params(13));
g1_v(14)=(-((1-params(10))/params(9)));
g1_v(15)=params(11);
g1_v(16)=1-1/params(2);
g1_v(17)=1;
g1_v(18)=1-params(12);
g1_v(19)=(1-params(10))/params(9);
g1_v(20)=(-((1-params(5))/params(5)*(1-params(5)*params(2))*(1-params(10))*(1-params(10))/params(9)));
g1_v(21)=1;
g1_v(22)=1-params(1);
g1_v(23)=(-(params(1)*(1-params(5))/params(5)*(1-params(5)*params(2))));
g1_v(24)=params(1);
g1_v(25)=params(1)*params(7)*(2-params(1));
g1_v(26)=1-params(4)-params(2)*(1-params(4));
g1_v(27)=(-1);
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 9, 9);
end
end
