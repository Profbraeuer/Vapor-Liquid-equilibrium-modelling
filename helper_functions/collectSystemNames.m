function systemNames = collectSystemNames(database)
    systemNames = {};
    sources = fieldnames(database);
    for i = 1:numel(sources)
        sourceData = database.(sources{i});
        if isstruct(sourceData)
            names = fieldnames(sourceData);
            systemNames = [systemNames; names(:)];
        end
    end
    systemNames = uniqueStable(systemNames);
end

