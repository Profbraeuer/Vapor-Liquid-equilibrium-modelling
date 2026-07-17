function Comp = discoverComponents(vleDatabaseFile)
    Comp = {};

    if  exist(vleDatabaseFile, 'file')
        vle = jsondecode(fileread(vleDatabaseFile));
        systemNames = collectSystemNames(vle);
        Comp = inferComponentsFromSystemNames(systemNames);
    end

    Comp = uniqueStable(Comp);
end

