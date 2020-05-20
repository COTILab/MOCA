function [probe] = getTotalModuleCount(probe)
%GETTOTALMODULECOUNT Summary of this function goes here
%   Detailed explanation goes here

activemoduleidx = probe.modules(:,4) == 1;  % indeces of active modules
activemodules = probe.modules(activemoduleidx,:); % logic for sub-matrix
probe.results.modulecount = size(activemodules,1);

end

