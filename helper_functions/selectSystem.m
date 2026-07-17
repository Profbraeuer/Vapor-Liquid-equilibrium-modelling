function selectedSystem = selectSystem(systems)

for i = 1:numel(systems)
    fprintf('%3d: %s\n', i, systems(i).name);
end

system_id = input("Enter system id: ");

if system_id < 1 || system_id > numel(systems) || ~isscalar(system_id)
    error("Invalid system id.");
end

s = systems(system_id).name;
s = string(s);

%% Selected system
selectedSystem = systems(system_id);
disp('Selected system:')
disp(selectedSystem.name)

end