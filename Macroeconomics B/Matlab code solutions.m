%........Question .b......%
format default

clear
syms D R
eqns = [R == ((1-sqrt(1-D*(2*1.02/25)))./(D/25)), R == (sqrt((50*(1-(1.02/1.05)))./(D/1.05)))];
S = solve(eqns,[R D]);
S.R
S.D

clear
syms D R
eqns = [R == ((1-sqrt(1-D*(1.02/10)))./(D/20)), R == (sqrt((40*(1-(1.02/1.05)))./(D/1.05)))];
S = solve(eqns,[R D]);
S.R
S.D

%........Question .c......%
clear
syms D R
eqns = [R == ((1-sqrt(1-D*(1.02/25)))./(D/50)), R == (sqrt((50*(1-(1.02/1.05)))./(D/1.05)))];
S = solve(eqns,[R D]);
S.R
S.D

%........Question .d......%
clear
syms D R
eqns = [R == ((5/4)-sqrt((25/16)-(1.02*D/10)))./(D/20), R == ((1/3.36)+sqrt((1/(3.36^2))-(4*D/33.6)*((1.02/1.05)-1)))./(2*D/33.6)];
S = solve(eqns,[R D]);
S.R
S.D
