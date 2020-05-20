function [probe] = getTotalOptodeCount(probe)
%GETTOTALOPTODECOUNT Summary of this function goes here
%   Detailed explanation goes here

results = probe.results;

results.optodecount.srcs = probe.results.modulecount * size(probe.module.srcposns, 1);
results.optodecount.dets = probe.results.modulecount * size(probe.module.detposns, 1);
results.optodecount.optodes = results.optodecount.srcs + results.optodecount.dets;

probe.results = results;
end

