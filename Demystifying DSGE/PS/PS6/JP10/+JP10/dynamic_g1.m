function g1 = dynamic_g1(T, y, x, params, steady_state, it_, T_flag)
% function g1 = dynamic_g1(T, y, x, params, steady_state, it_, T_flag)
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
%   g1
%

if T_flag
    T = JP10.dynamic_g1_tt(T, y, x, params, steady_state, it_);
end
g1 = zeros(15, 42);
g1(1,1)=(-params(10));
g1(1,13)=1+params(10);
g1(1,28)=(-1);
g1(1,15)=T(1);
g1(1,30)=(-T(1));
g1(1,37)=(-T(1));
g1(1,34)=T(1);
g1(2,13)=1-params(1);
g1(2,14)=(-1);
g1(2,17)=params(1)*params(7)*(2-params(1));
g1(2,21)=params(1)*params(7);
g1(2,23)=params(1);
g1(3,5)=(-1);
g1(3,17)=1;
g1(3,19)=1;
g1(3,20)=(-1);
g1(4,16)=1;
g1(4,17)=(-(1-params(1)));
g1(4,21)=(-1);
g1(5,1)=(-(T(2)*T(1)*(-params(10))));
g1(5,13)=(-(T(1)*T(2)));
g1(5,14)=(-(T(2)*params(8)));
g1(5,17)=(-(params(1)*T(2)));
g1(5,6)=(-params(3));
g1(5,19)=1-params(2)*(-params(3));
g1(5,31)=(-params(2));
g1(5,35)=(-(T(2)*(-(1+params(8)))));
g1(6,7)=(-params(4));
g1(6,20)=1-params(2)*(-params(4));
g1(6,32)=(-params(2));
g1(6,21)=(-((1-params(6))/params(6)*(1-params(2)*params(6))));
g1(6,39)=(-1);
g1(7,5)=params(1);
g1(7,17)=(-params(1));
g1(7,18)=1;
g1(7,19)=(-1);
g1(8,15)=1;
g1(8,16)=1;
g1(8,29)=(-1);
g1(8,30)=(-1);
g1(8,22)=params(11);
g1(8,33)=1;
g1(8,25)=(-1);
g1(8,38)=1;
g1(9,13)=1;
g1(9,14)=(-1);
g1(9,17)=params(1);
g1(9,21)=params(1);
g1(9,8)=(-(1/params(2)));
g1(9,22)=1;
g1(10,2)=params(15);
g1(10,14)=(-(params(14)+params(15)));
g1(10,3)=(-params(12));
g1(10,15)=1;
g1(10,18)=(-params(13));
g1(10,36)=(-1);
g1(11,9)=(-params(21));
g1(11,23)=1;
g1(11,40)=(-params(25));
g1(12,10)=(-params(22));
g1(12,24)=1;
g1(12,41)=(-params(24));
g1(13,11)=(-params(23));
g1(13,25)=1;
g1(13,42)=(-params(26));
g1(14,4)=(-1);
g1(14,16)=1;
g1(14,18)=1;
g1(14,24)=(-1);
g1(14,12)=(-1);
g1(14,26)=1;
g1(15,37)=(-1);
g1(15,27)=1;

end
