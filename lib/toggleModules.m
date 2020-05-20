function [probe] = toggleModules(probe, moduleidx, modulestate)
%TOGGLEMODULES Summary of this function goes here
%   Detailed explanation goes here

if (strcmp(modulestate, 'off'))
    state = 0;
elseif (strcmp(modulestate, 'on'))
    state = 1;
end

for i=1:size(moduleidx,2)
    probe.modules(moduleidx(i), 4) = state;
end

end

