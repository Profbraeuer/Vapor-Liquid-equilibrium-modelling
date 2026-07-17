function [x, y, gamma] = binary_Tp_flash(T, P, par, modelFunc, varargin)

tol     = 1e-8;
maxIter = 100;

x = 0.5;                          % Initial liquid composition

A = varargin{1};
B = varargin{2};
C = varargin{3};

% Saturation pressures at T
Psat = p_Antoine(T, A, B, C);

modelName = func2str(modelFunc);

for iter = 1:maxIter

    xi = [x, 1-x];

    % Activity coefficients
    switch modelName

        case 'nrtl'
            delta_g = [0 par(1); par(2) 0];
            gamma = modelFunc(T, xi, delta_g);

        case 'uniquac_sep'
            tau = [0 par(1); par(2) 0];
            r = varargin{4}; q = varargin{5};
            gamma = modelFunc(T, xi, tau, r,q);

        case 'uniquac_gl'
            r = varargin{4}; q = varargin{5};  beta = varargin{6};

            % Saturation temperatures
            Tsat = T_Antoine(P, A, B, C);

            % Enthalpy of vaporization (Clausius-Clapeyron)
            Hvap = 8.314 * log(10) .* B .* Tsat.^2 ./ (C + Tsat).^2;
            
            gamma = modelFunc( ...
                T, xi, {par; beta}, ...
                r, q, Hvap, Tsat);

        otherwise
            error('Unknown activity coefficient model.')

    end

    % Vapor composition
    yVec = xi .* gamma .* Psat;
    yVec = yVec / sum(yVec);

    % Update liquid composition
    xNew = P * yVec(1) / (gamma(1) * Psat(1));

    % Convergence check
    if abs(xNew - x) < tol
        break
    end

    x = xNew;

end

y = yVec(1);                      % Vapor mole fraction of component 1

end