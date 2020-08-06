function [probe] = getChannelData(probe)
%GETCHANNELDATA Determine channel distribution of the probe
%   Calculates the SD separations for (1) channels limited by sdrange and
%   (2) without sdrange limits. For when output is limited to sdrange,
%   three additional sub-fields (sschannels, lschannels, exchannels) are
%   also calculated. Else, only channels, intrachannels, and interchannels
%   are outputted. Outputs are Nx5 matrixes, where the columns are 
%   [SDseparation, sourceID, detectorID, moduleIDofSource, moduleIDofdetector]

% first, get only the active modules, srcs, and detectors
[activemodules, activesrcposns, activedetposns] = getActiveMSD(probe);
tmpprobe = probe;
%tmpprobe.modules = activemodules;
%tmpprobe.srcposns = activesrcposns;
%tmpprobe.detposns = activedetposns;
tmpprobe.results.modules = activemodules;
tmpprobe.results.srcposns = activesrcposns;
tmpprobe.results.detposns = activedetposns;



% channels (all, limited to sdrange(2) inclusive) [sep srcid detid srcmodid detmodid]
% intrachannels (channels within modules)
% interchannels (channels with optodes on diff modules)
% sschannels (channels below sdrange(1), exclusive)
% lschannels (channels within sdrange)
% exchannels (excluded channels due to sdrange. channels above sdrange(2))
tmpprobe = getSDSeparations(tmpprobe);
probe.results = tmpprobe.results;






end

