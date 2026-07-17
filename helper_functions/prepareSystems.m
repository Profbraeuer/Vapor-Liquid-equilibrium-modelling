function systems = prepareSystems(database,Comp)
%PREPAREVLESYSTEMS Collect experimental VLE data for all systems.
%
% Supports binary and ternary systems.
%
% x and y are stored as:
% binary:   Nx2
% ternary:  Nx3

%% Find all possible systems from database

systemNames = collectSystemNames(database);


systems = struct( ...
    'id',{}, ...
    'name',{}, ...
    'T',{}, ...
    'x',{}, ...
    'y',{}, ...
    'P',{});


count = 0;


%% Loop over database systems

for s = 1:numel(systemNames)


    systemName = systemNames{s};


    % Components of this system

    parts = strsplit(systemName,"_");


    nComp = numel(parts);


    % Only binary and ternary

    if nComp < 2 || nComp > 3
        continue
    end



    % Component IDs

    id = zeros(1,nComp);

    for i = 1:nComp

        idx = find(strcmp(Comp,parts{i}));

        if isempty(idx)
            error("Component %s not found",parts{i})
        end

        id(i)=idx;

    end



    %% Search experimental data

    Tab = queryDatabase(database,...
        "System",systemName);


    if isempty(Tab)
        continue
    end


    Tab = Tab(strcmp(Tab.Source,"Experiments"),:);


    if isempty(Tab)
        continue
    end



    %% Collect data

    T = [];
    x = [];
    y = [];
    P = [];


    for j = 1:height(Tab)


        data = database.(Tab.Source{j})...
                       .(Tab.System{j})...
                       .(Tab.Set{j});


        T = [T; data.T(:)];


        %------------------------------------------
        % Liquid composition
        %------------------------------------------

        if isfield(data,'x1')

            x = [x; ...
                [data.x1(:),...
                 data.x2(:),...
                 data.x3(:)]];

        else

            x = [x; data.x];

        end



        %------------------------------------------
        % Vapor composition
        %------------------------------------------

        if isfield(data,'y1')

            y = [y; ...
                [data.y1(:),...
                 data.y2(:),...
                 data.y3(:)]];

        else

            y = [y; data.y];

        end



        P = [P; data.p(:)*1000];


    end



    %% Remove pure component points

    valid = all(x>0 & x<1,2);



    %% Save system

    count = count+1;


    systems(count).id = id;

    systems(count).name = systemName;

    systems(count).T = T(valid);

    systems(count).x = x(valid,:);

    systems(count).y = y(valid,:);

    systems(count).P = P(valid);


end

end