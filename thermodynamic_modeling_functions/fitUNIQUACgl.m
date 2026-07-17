function [beta,c_ij] = fitUNIQUACgl(systems,antoine,gE,config)
%FITUNIQUAC Alternating optimization of UNIQUAC-gl parameters.
%
%   Step 1: Fit binary interaction parameters c_ij (fixed beta_i)
%   Step 2: Fit global beta_i parameters (fixed c_ij)
%   Repeat until convergence.


% fitUNIQUAC()
%    |
%    +--> fitBinaryParameters()
%    |          |
%    |          +--> local_objective()
%    |                      |
%    |                      +--> calcWithModel() --> pT_flash calculations
%    |
%    +--> fitGlobalParameters()
%               |
%               +--> global_objective()
%                          |
%                          +--> calcWithModel() --> pT_flash calculations



%% Initial values

beta = config.beta_i_0;
c_ij = config.c_ij_0;

tolerance = 1e-4;
delta = inf;
resnorm = inf;

options = optimoptions( ...
    'lsqnonlin', ...
    'Display','iter', ...
    'TolFun',1e-8, ...
    'TolX',1e-8);



%% Alternating optimization

while delta > tolerance

    %% Step 1: Fit c_ij

    c_ij = fitUNIQUACglBinaryParameters( ...
        systems,...
        antoine,...
        gE,...
        beta,...
        c_ij,...
        config,...
        options);

    %% Step 2: Fit beta_i

    previousResnorm = resnorm;

    [beta,resnorm] = fitUNIQUACglGlobalParameters( ...
        systems,...
        antoine,...
        gE,...
        beta,...
        c_ij,...
        config,...
        options);

    delta = abs(resnorm - previousResnorm);
end

fprintf('\n Global optimization converged.\n');

end