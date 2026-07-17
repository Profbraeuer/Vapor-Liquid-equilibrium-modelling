function Comp = inferComponentsFromSystemNames(systemNames)

    Comp = {};

    for i = 1:numel(systemNames)

        % Split system name into components
        parts = strsplit(systemNames{i}, '_');

        % Accept binary, ternary, etc.
        if numel(parts) >= 2
            Comp = [Comp; parts(:)];
        end

    end

    % Remove duplicates but keep order
    Comp = uniqueStable(Comp);

end