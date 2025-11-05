function [y, T] = static_6(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(4)=y(9)+(1-params(1))*y(5);
end
