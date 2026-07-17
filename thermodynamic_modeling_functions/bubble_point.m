function [y,T,gamma] = bubble_point(P, x, modelInput) 
%CALCVLE_PX Bubble point calculation at constant pressure.
%
% Inputs:
%   P            pressure [Pa]
%   x            liquid mole fraction 1xn
%   modelInput   parameter structure
%
% Outputs:
%   y            vapor mole fraction 1xn
%   T            bubble temperature [K]
%   gamma        activity coefficients


%% Parameters

A = modelInput.antoine.A(:);
B = modelInput.antoine.B(:);
C = modelInput.antoine.C(:);


model = modelInput.model_name;


%% Initial temperature

T = mean(T_Antoine(P,A,B,C));


error = inf;


%% Newton iteration

while error > 1e-8


    %% Liquid composition
    if length(x) == 1
        x_vec = [x,1-x];
    else
        x_vec = x;
    end


    %% Activity coefficients

    switch model


        case "uniquac_gl"

            beta = modelInput.uniquac_gl.beta_i;
            r = modelInput.uniquac_gl.r_i;
            q = modelInput.uniquac_gl.q_i;
            cij = modelInput.uniquac_gl.c_ij;

            % Saturation temperatures
            Tsat = T_Antoine(P, A, B, C);
            % Enthalpy of vaporization (Clausius-Clapeyron)
            Hvap = 8.314 * log(10) .* B .* Tsat.^2 ./ (C + Tsat).^2;

            gamma = uniquac_gl( ...
                T,...
                x_vec,...
                {cij,beta},...
                r,...
                q, ...
                Hvap,...
                Tsat);

        case "uniquac_sep"

            r = modelInput.uniquac_sep.r_i;
            q = modelInput.uniquac_sep.q_i;
            deltau_ij = modelInput.uniquac_sep.deltau_ij;


            gamma = uniquac_sep( ...
                T,...
                x_vec,...
                deltau_ij,...
                r,...
                q);


        case "nrtl"

            deltag_ij = modelInput.nrtl.deltag_ij;

            gamma = nrtl( ...
                T,...
                x_vec,...
                deltag_ij);

        otherwise

            error("Unknown activity model: %s",model)

    end



    %% Saturation pressures

    psat = p_Antoine(T,A,B,C);

    psat = psat(:).';



    %% Bubble point equation

    F = ...
        P - sum(x_vec .* gamma .* psat);



    %% derivative

    dpsat_dT = ...
        psat(:) .* log(10).*B(:) ./ (C(:)+T).^2;


    dFdT = ...
        -sum(x_vec(:) .* gamma(:) .* dpsat_dT);



    %% Newton step

    dT = F/dFdT;

    T = T - dT;


    error = abs(F);


end



%% Vapor composition

    y_vec = ...
        x_vec .* gamma .* psat / P;

    if length(x) == 1
        y = y_vec(1);
    else
        y = y_vec;
    end

end