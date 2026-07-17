function [P_mean,group] = groupPressures(P,tolerance)
%GROUPPRESSURES Group pressure values within a tolerance.
%
% P          pressure vector
% tolerance  maximum pressure difference [Pa]

P = P(:);

n = numel(P);

group = zeros(n,1);

currentGroup = 1;

group(1) = currentGroup;

for i = 2:n

    if abs(P(i)-mean(P(group==currentGroup))) <= tolerance

        group(i) = currentGroup;

    else

        currentGroup = currentGroup + 1;
        group(i) = currentGroup;

    end

end


% Calculate mean pressure of each group

nGroups = max(group);

P_mean = zeros(nGroups,1);

for i = 1:nGroups

    P_mean(i) = mean(P(group==i));

end

end