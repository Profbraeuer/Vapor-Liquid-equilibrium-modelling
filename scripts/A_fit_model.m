skip = false;

switch modelName

        
        case "uniquac_gl"

            answer = input( ...
            "UNIQUAC-gl fitting may take several minutes. Continue? (0/1): ");


            if answer

            [beta,cij] = fitUNIQUACgl( ...
                systems,...
                antoine,...
                gE,...
                config);


            gE.beta_i = beta;
            gE.c_ij = cij;

             else
                skip = true;
                fprintf("UNIQUAC-gl fitting skipped.\n")

            end


          case "uniquac_sep"

            deltau_ij = fitUNIQUACsep( ...
                systems,...
                antoine,...
                gE,...
                config);

            gE.deltau_ij = deltau_ij;

        case "nrtl"

            deltag_ij = fitNRTL( ...
                systems,...
                antoine,...
                config);

            gE.deltag_ij = deltag_ij;

        otherwise

            error("Unknown model: %s",modelName)

end


% Save
if ~skip && input("Overwrite existing model parameters? (0/1): ")

    model_parameters.(modelName) = gE;
    save(fullfile(rootDir,'database','model_parameters.mat'), ...
     'model_parameters');
end