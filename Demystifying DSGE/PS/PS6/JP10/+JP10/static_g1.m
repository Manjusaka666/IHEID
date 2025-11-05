function g1 = static_g1(T, y, x, params, T_flag)
% function g1 = static_g1(T, y, x, params, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%                                              to evaluate the model
%   T_flag    boolean                 boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   g1
%

if T_flag
    T = JP10.static_g1_tt(T, y, x, params);
end
g1 = zeros(15, 15);
g1(1,3)=T(1);
g1(1,6)=(-T(1));
g1(1,15)=T(1);
g1(2,1)=1-params(1);
g1(2,2)=(-1);
g1(2,5)=params(1)*params(7)*(2-params(1));
g1(2,9)=params(1)*params(7);
g1(2,11)=params(1);
g1(3,7)=1;
g1(3,8)=(-1);
g1(4,4)=1;
g1(4,5)=(-(1-params(1)));
g1(4,9)=(-1);
g1(5,1)=(-(T(2)*(1-params(10))*T(1)));
g1(5,2)=(-(T(2)*params(8)));
g1(5,5)=(-(params(1)*T(2)));
g1(5,7)=1-params(3)-params(2)*(1-params(3));
g1(6,8)=1-params(4)-params(2)*(1-params(4));
g1(6,9)=(-((1-params(6))/params(6)*(1-params(2)*params(6))));
g1(7,6)=1;
g1(7,7)=(-1);
g1(8,3)=1;
g1(8,6)=(-1);
g1(8,10)=params(11);
g1(8,12)=1;
g1(8,13)=(-1);
g1(9,1)=1;
g1(9,2)=(-1);
g1(9,5)=params(1);
g1(9,9)=params(1);
g1(9,10)=1-1/params(2);
g1(10,2)=(-params(14));
g1(10,3)=1-params(12);
g1(10,6)=(-params(13));
g1(11,11)=1-params(21);
g1(12,12)=1-params(22);
g1(13,13)=1-params(23);
g1(14,6)=1;
g1(14,12)=(-1);
g1(15,15)=1;

end
