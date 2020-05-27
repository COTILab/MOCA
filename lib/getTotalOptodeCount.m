function [probe] = getTotalOptodeCount(probe)
%GETTOTALOPTODECOUNT Derive total number of optodes (regardless of active)
%   Determines the total number of sources and detectors of all modules,
%   regardless of their active state. Returns an integer value for srcs,
%   dets, and optodes = srcs+dets.

results = probe.results;

results.optodecount.srcs = probe.results.modulecount * size(probe.module.srcposns, 1);
results.optodecount.dets = probe.results.modulecount * size(probe.module.detposns, 1);
results.optodecount.optodes = results.optodecount.srcs + results.optodecount.dets;

probe.results = results;
end

