function [p, dpdT] = p_Antoine(T,A,B,C)
    lgp =  A - B./(T + C);
    p = 10.^lgp;
    dpdT = p .* log(10) .* B ./ (T + C).^2;
end