function deltau_ij = fitUNIQUACsep(systems,antoine,gE,config)
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
    modelInput.r = gE.r_i(id);
    modelInput.q = gE.q_i(id);


    %% Fit binary parameter

    k = id(1);
    l = id(2);

    optim_par = lsqnonlin( ...
        @(deltau_ij)local_objective( ...
            deltau_ij,...
            data.T,...
            data.x,...
            data.y,...
            data.P,...
            modelInput),...
        config.deltau_ij_0,...
        config.deltau_ij_lb,...
        config.deltau_ij_ub,...
        options);

    deltau_ij(k,l) = optim_par(1);
    deltau_ij(l,k) = optim_par(2);
end


end