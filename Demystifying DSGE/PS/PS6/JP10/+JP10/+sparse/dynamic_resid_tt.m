function [T_order, T] = dynamic_resid_tt(y, x, params, steady_state, T_order, T)
if T_order >= 0
    return
end
T_order = 0;
if size(T, 1) < 2
    T = [T; NaN(2 - size(T, 1), 1)];
end
T(1) = (1-params(10))/params(9);
T(2) = (1-params(5))/params(5)*(1-params(5)*params(2));
end
