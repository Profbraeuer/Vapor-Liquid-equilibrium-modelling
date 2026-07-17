function modelInput = makeModelInput( ...
    modelName,...
    comp_id,...
    antoine,...
    parameters)


modelInput = struct();


modelInput.model_name = modelName;


%% Antoine

modelInput.antoine.A = antoine.A(comp_id);
modelInput.antoine.B = antoine.B(comp_id);
modelInput.antoine.C = antoine.C(comp_id);


%% Model parameters

switch modelName


    case "uniquac_gl"

        modelInput.uniquac_gl = parameters;

        modelInput.uniquac_gl.r_i = ...
            parameters.r_i(comp_id);

        modelInput.uniquac_gl.q_i = ...
            parameters.q_i(comp_id);

        modelInput.uniquac_gl.beta_i = ...
            parameters.beta_i(comp_id);

        C = parameters.c_ij(comp_id, comp_id);
        modelInput.uniquac_gl.c_ij = C(triu(true(size(C)),1)).'; %vector

    case "uniquac_sep"

        modelInput.uniquac_sep.r_i = ...
            parameters.r_i(comp_id);

        modelInput.uniquac_sep.q_i = ...
            parameters.q_i(comp_id);

        n = numel(comp_id);
        modelInput.uniquac_sep.deltau_ij = zeros(n);
            
            for i = 1:n
                for j = 1:n
                    if i ~= j
                        modelInput.uniquac_sep.deltau_ij(i,j) = ...
                            parameters.deltau_ij(comp_id(i),comp_id(j));
                    end
                end
            end

    case "nrtl"

        n = numel(comp_id);
        modelInput.nrtl.deltag_ij = zeros(n);
        
        for i = 1:n
            for j = 1:n
                if i ~= j
                    modelInput.nrtl.deltag_ij(i,j) = ...
                        parameters.deltag_ij(comp_id(i),comp_id(j));
                end
            end
        end

    otherwise

        error("Unknown model %s",modelName)

end

end