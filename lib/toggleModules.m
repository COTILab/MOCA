function [probe] = toggleModules(probe, moduleidx, modulestate)
%TOGGLEMODULES Toggle the active state of a module
%   Toggles the active state of modules. moduleidx can be either an
%   integer, or an array of module indeces. modulestate must be 'on' or
%   'off'. This changes the fourth column of probe.modules.

if (strcmp(modulestate, 'off'))
    state = 0;
elseif (strcmp(modulestate, 'on'))
    state = 1;
end

for i=1:size(moduleidx,2)
    probe.modules(moduleidx(i), 4) = state;
end

end

