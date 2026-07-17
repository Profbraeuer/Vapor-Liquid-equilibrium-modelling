function deltag_ij = fitNRTL(systems,antoine,config)
%FITUNIQUACsep optimization of UNIQUAC-sep binary parameters.

options = optimoptions( ...
    'lsqnonlin', ...
    'Display','iter', ...
    'TolFun',1e-8, ...
    'TolX',1e-8);

%% Loop over prepared binary systems

for s = 1:numel(systems)

    data = systems(s);

    id = data.id;

    %% Pure component parameters

    modelInput = struct();
    modelInput.func = config.func;
    modelInput.name = func2str(config.func);
    modelInput.A = antoine.A(id);
    modelInput.B = antoine.B(id);
    modelInput.C = antoine.C(id);

    %% Fit binary parameter

    k = id(1);
    l = id(2);

    optim_par = lsqnonlin( ...
        @(deltag_ij)local_objective( ...
            deltag_ij,...
            data.T,...
            data.x,...
            data.y,...
            data.P,...
            modelInput),...
        config.deltag_ij_0,...
        config.deltag_ij_lb,...
        config.deltag_ij_ub,...
        options);

    deltag_ij(k,l) = optim_par(1);
    deltag_ij(l,k) = optim_par(2);
end


end