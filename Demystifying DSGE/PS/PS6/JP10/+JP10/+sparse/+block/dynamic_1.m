function [y, T] = dynamic_1(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(26)=params(21)*y(11)+params(25)*x(6);
  y(27)=params(22)*y(12)+params(24)*x(7);
  y(28)=params(23)*y(13)+params(26)*x(8);
  y(30)=x(3);
end
