
%% Load database

databaseFile = fullfile(rootDir,"database","VLE_DATA_ternary.json");
database = jsondecode(fileread(databaseFile));
Comp = discoverComponents(databaseFile);
systems = prepareSystems(database,Comp);


selectedSystem = selectSystem(systems);


fprintf("\nSelected system:\n")
fprintf("%s\n",selectedSystem.name)

%% Extract system information

T_exp = selectedSystem.T;
x_exp = selectedSystem.x;
y_exp = selectedSystem.y;
P_exp = selectedSystem.P;

[P_sets, pressureGroup] = groupPressures(P_exp,1000);

[pressureGroup, pressure_id] = selectPressure(P_sets, pressureGroup);

T_exp = T_exp(pressureGroup);
x_exp = x_exp(pressureGroup,:);
y_exp = y_exp(pressureGroup,:);
P_exp = P_exp(pressureGroup);

modelInput = makeModelInput( ...
    modelName,...
    selectedSystem.id,...
    antoine,...
    gE);

%% Plot style
style = plotSettings();
colors = lines(numel(P_sets));
color = colors(pressure_id,:);

%%  Compute and plot
delta_xi = 0.005;

figure;
ax = axes();


p0 = mean(P_exp);
for j = 1:size(x_exp,1)
    x0 = x_exp(j,:);

    % Compute residue curves (forward)
    [x,T] = expl_Euler( ...
        delta_xi,...
        x0,...
        p0,...
        modelInput);
    ternaryPlot(ax,x(:,1),x(:,2),x(:,3),'k-','LineWidth',0.5*style.lineWidth)
end



for j = 1:size(x_exp,1)
    x0 = x_exp(j,:);
    y0 = y_exp(j,:);

    % Compute residue curves (backward)
    [x,T] = expl_Euler( ...
        -delta_xi,...
        x0,...
        p0,...
        modelInput);
    ternaryPlot(ax,x(:,1),x(:,2),x(:,3),'k-','LineWidth',0.5*style.lineWidth)

    % Modelled equilibrium vapor phase composition
    [y_c(j,:),T_c(j),~] = bubble_point( ...
        p0,...
        x0,...
        modelInput);
    ternaryPlot(ax,y_c(:,1),y_c(:,2),y_c(:,3),'k.','LineWidth',3,'MarkerSize',2*style.markerSize)

    % Experimental VLE
    ternaryPlot(ax,x0(:,1),x0(:,2),x0(:,3),'s','Color',color,'LineWidth',2,'MarkerFaceColor',color,'MarkerSize',0.7*style.markerSize,'MarkerEdgeColor','k')
    ternaryPlot(ax,y0(:,1),y0(:,2),y0(:,3),'.','LineWidth',0.5*style.lineWidth,'MarkerSize',2*style.markerSize,'MarkerEdgeColor',color)
    ternaryPlot(ax,[x0(:,1) y0(:,1)],[x0(:,2) y0(:,2)],[x0(:,3) y0(:,3)],'-','Color',color,'LineWidth',0.5*style.lineWidth)
end

% Label plot
Tb = T_Antoine(p0,antoine.A(selectedSystem.id),antoine.B(selectedSystem.id),antoine.C(selectedSystem.id));
labels = string(Comp(selectedSystem.id));

text(0.5,0.95,...
    sprintf("%s\n%.1f K",labels(1),Tb(1)),...
    "FontSize",style.fontSize,...
    "FontWeight","bold",...
    "HorizontalAlignment","center")

text(1.1,-0.02,...
    sprintf("%s\n%.1f K",labels(2),Tb(2)),...
    "FontSize",style.fontSize,...
    "FontWeight","bold",...
    "HorizontalAlignment","center")

text(-0.1,-0.02,...
    sprintf("%s\n%.1f K",labels(3),Tb(3)),...
    "FontSize",style.fontSize,...
    "FontWeight","bold",...
    "HorizontalAlignment","center")

text(0.85,0.8,sprintf("Pressure %.1f kPa\nModel: %s", ...
    p0/1000,...
    formatModelName(modelName)),...
    "Units","normalized",...
    "FontSize",style.fontSize,...
    "HorizontalAlignment","center",...
    "FontWeight","bold");