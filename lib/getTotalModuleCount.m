function [probe] = getTotalModuleCount(probe)
%GETTOTALMODULECOUNT Gets the total active modules in a probe
%   Derives an integer value representing the total number of active
%   modules in the particular probe.

activemoduleidx = probe.modules(:,4) == 1;  % indeces of active modules
activemodules = probe.modules(activemoduleidx,:); % logic for sub-matrix

probe.results.modulecount = size(activemodules,1);

end

