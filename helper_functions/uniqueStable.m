function values = uniqueStable(values)
    if isempty(values)
        values = {};
        return
    end

    values = cellstr(values(:));
    out = {};
    for i = 1:numel(values)
        if ~any(strcmp(out, values{i}))
            out{end+1,1} = values{i};
        end
    end
    values = out;
end