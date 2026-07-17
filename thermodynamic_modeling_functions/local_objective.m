function res = local_objective(par, T_exp, x_exp, y_exp, P_exp, modelInput)
    valid_idx = (x_exp ~= 0) & (x_exp ~= 1);
    T_exp = T_exp(valid_idx);
    x_exp = x_exp(valid_idx);
    y_exp = y_exp(valid_idx);
    P_exp = P_exp(valid_idx);

    res = [];
    for i = 1:length(T_exp)
        [x_calc, ~] = calcWithModel(T_exp(i), P_exp(i), par, modelInput);
        res = [res; x_calc - x_exp(i)];
    end
end

