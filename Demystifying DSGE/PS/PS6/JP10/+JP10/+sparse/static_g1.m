function [g1, T_order, T] = static_g1(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T_order, T)
if nargin < 8
    T_order = -1;
    T = NaN(2, 1);
end
[T_order, T] = JP10.sparse.static_g1_tt(y, x, params, T_order, T);
g1_v = NaN(40, 1);
g1_v(1)=1-params(1);
g1_v(2)=(-(T(2)*(1-params(10))*T(1)));
g1_v(3)=1;
g1_v(4)=(-1);
g1_v(5)=(-(T(2)*params(8)));
g1_v(6)=(-1);
g1_v(7)=(-params(14));
g1_v(8)=T(1);
g1_v(9)=1;
g1_v(10)=1-params(12);
g1_v(11)=1;
g1_v(12)=params(1)*params(7)*(2-params(1));
g1_v(13)=(-(1-params(1)));
g1_v(14)=(-(params(1)*T(2)));
g1_v(15)=params(1);
g1_v(16)=(-T(1));
g1_v(17)=1;
g1_v(18)=(-1);
g1_v(19)=(-params(13));
g1_v(20)=1;
g1_v(21)=1;
g1_v(22)=1-params(3)-params(2)*(1-params(3));
g1_v(23)=(-1);
g1_v(24)=(-1);
g1_v(25)=1-params(4)-params(2)*(1-params(4));
g1_v(26)=params(1)*params(7);
g1_v(27)=(-1);
g1_v(28)=(-((1-params(6))/params(6)*(1-params(2)*params(6))));
g1_v(29)=params(1);
g1_v(30)=params(11);
g1_v(31)=1-1/params(2);
g1_v(32)=params(1);
g1_v(33)=1-params(21);
g1_v(34)=1;
g1_v(35)=1-params(22);
g1_v(36)=(-1);
g1_v(37)=(-1);
g1_v(38)=1-params(23);
g1_v(39)=T(1);
g1_v(40)=1;
if ~isoctave && matlab_ver_less_than('9.8')
    sparse_rowval = double(sparse_rowval);
    sparse_colval = double(sparse_colval);
end
g1 = sparse(sparse_rowval, sparse_colval, g1_v, 15, 15);
end
