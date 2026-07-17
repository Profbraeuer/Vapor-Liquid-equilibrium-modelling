function res = global_objective(beta,systems,modelInput)
%GLOBAL_OBJECTIVE Residual vector for global beta optimization.

A = modelInput.antoine.A;
B = modelInput.antoine.B;
C = modelInput.antoine.C;

r = modelInput.uniquac_gl.r_i;
q = modelInput.uniquac_gl.q_i;

cij = modelInput.uniquac_gl.c_ij;

residuals = cell(numel(systems),1);

for s = 1:numel(systems)

    id = systems(s).id;


    input.name = "uniquac_gl";
    input.A = A(id);
    input.B = B(id);
    input.C = C(id);
    input.r = r(id);
    input.q = q(id);
    input.beta_i = beta(id);
    input.cij = cij(id(1),id(2));

    n = numel(systems(s).T);

    err = zeros(n,1);

    for k = 1:n

        xCalc = calcWithModel( ...
            systems(s).T(k),...
            systems(s).P(k),...
            input.cij,...
            input);

        err(k) = xCalc-systems(s).x(k);

    end

    residuals{s} = err;

end

res = vertcat(residuals{:});

end