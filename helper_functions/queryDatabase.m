function resultTable = queryDatabase(database, varargin)
% queryDatabase(database, 'Pressure', value)
% queryDatabase(database, 'System', 'DMC_EMC')

p = inputParser;
addParameter(p, 'Pressure', []);
addParameter(p, 'System', '');
parse(p, varargin{:});

searchPressure = p.Results.Pressure;
searchSystem   = p.Results.System;

sources = fieldnames(database);

IDCol       = [];
SourceCol   = {};
SystemCol   = {};
SetCol      = {};
PressureCol = [];

idCounter = 1;
for i = 1:length(sources)
    source = sources{i};
    systems = fieldnames(database.(source));

    
    for j = 1:length(systems)
        system = systems{j};
       
        if ~isempty(searchSystem) && ~strcmp(system, searchSystem) 
            continue 
        end
                
        sets = fieldnames(database.(source).(system));
        
        for k = 1:length(sets)
            setName = sets{k};
            data = database.(source).(system).(setName);
            
            if isfield(data, 'p')
                pressure = mean(data.p);
                
                tolerance = 3;
                if ~isempty(searchPressure)
                    if abs(pressure - searchPressure) > tolerance
                        continue
                    end
                end

                IDCol(end+1,1)       = idCounter;
                SourceCol{end+1,1}   = source;
                SystemCol{end+1,1}   = system;
                PressureCol(end+1,1) = pressure;
                SetCol{end+1,1}      = setName;
                idCounter = idCounter + 1;
            end
        end
    end
end

resultTable = table(IDCol, SourceCol, SystemCol, SetCol, PressureCol, ...
    'VariableNames', {'ID','Source','System','Set','Pressure'});

end