function [T_order, T] = static_g1_tt(y, x, params, T_order, T)
if T_order >= 1
    return
end
[T_order, T] = JP10.sparse.static_resid_tt(y, x, params, T_order, T);
T_order = 1;
if size(T, 1) < 2
    T = [T; NaN(2 - size(T, 1), 1)];
end
end
