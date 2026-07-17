function [gamma, gE] = nrtl(T, x, delta_g,varargin)

    
    R = 8.314;      % J/mol/K
    n = length(x);
    alpha = 0.3;

    alpha = alpha * (ones(n) - eye(n)); % nxn

    tau = delta_g ./ (R*T);      % n x n
    G = exp(-alpha .* tau);     % n x n

    ln_gamma = zeros(1,n);

    for i = 1:n
        
        part1 = 0;
        for j = 1:n
            part1 = part1 + x(j) * G(j,i) / sum(x .* G(:,i)') * tau(j,i);
        end

        part2 = 0;
        for j = 1:n
            denom_j = sum(x .* G(:,j)');
            sum_k = sum(x .* tau(:,j)' .* G(:,j)');
            part2 = part2 + x(j) * G(i,j) / denom_j * (tau(i,j) - sum_k / denom_j);
        end

        ln_gamma(i) = part1 + part2;
    end

    gamma = exp(ln_gamma);
    gE = R*T*sum(x .* ln_gamma);
end