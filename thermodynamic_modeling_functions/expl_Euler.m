function [x,T] = expl_Euler(delta_xi, x0, p, modelInput)
%EXPL_EULER Explicit Euler integration of residue curve
%
% Inputs:
%   delta_xi    step size
%   x0          initial liquid composition
%   p           pressure
%   modelInput  model structure containing all parameters
%
% Outputs:
%   x           liquid composition trajectory
%   T           temperature trajectory


%% Initialization

tol = 1e-6;
max_iter = 8000;

x = x0(:).';     % ensure row vector

T = zeros(max_iter,1);

eps = inf;
iter = 0;


%% Euler integration

while eps > tol && iter < max_iter


    % Bubble point calculation

    [y,T(iter+1),~] = bubble_point( ...
        p,...
        x(end,:),...
        modelInput);


    % Euler step

    x_new = x(end,:) + ...
        (y - x(end,:))*delta_xi;


    x(end+1,:) = x_new;

    % Termination criterion
    %
    % Stop at:
    % - azeotrope: x = y
    % - pure vapor component

    eps = min( ...
        sqrt(sum((x_new-y).^2)),...
        min(y));


    iter = iter + 1;

end


%% Remove unused entries

T = T(1:iter);


if iter >= max_iter
    warning("Residue curve integration reached maximum iterations.")
end

end