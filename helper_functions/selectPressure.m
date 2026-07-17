function [pressureGroup, pressure_id] = selectPressure(P_sets, pressureGroup)
%% Select pressure level if multiple exist

    fprintf("\nAvailable pressure levels:\n")
    fprintf("--------------------------\n")

    for i = 1:numel(P_sets)

        fprintf("%3d: %.3f kPa\n", ...
            i, ...
            P_sets(i)/1000)

    end


    pressure_id = input("\nEnter pressure id: ");


    if ~isscalar(pressure_id) || ...
            pressure_id < 1 || ...
            pressure_id > numel(P_sets)

        error("Invalid pressure id.")

    end


    % Keep only selected pressure data

    pressureGroup = pressureGroup == pressure_id;

    P_sets = P_sets(pressure_id);

end