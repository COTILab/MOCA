function [probe] = characterizeProbe(probe)
%CHARACTERIZEPROBE Summary of this function goes here
%   Detailed explanation goes here

moduleexists = false; 
roiexists = false;
optodesexists = false;
sdrangeexists = false;

% identify which inputs were defined
if (isfield(probe, 'module'))
    moduleexists = true;
end
if (isfield(probe, 'roi'))
    roiexists = true;
end
if (isfield(probe.module, 'srcposns') && isfield(probe.module, 'detposns'))
    optodesexists = true;
end
if (isfield(probe, 'sdrange'))
    if (size(probe.sdrange) == 1)
        probe.sdrange = [10, probe.sdrange];
    end
    sdrangeexists = true;
end

% Run the characterizations based on defined inputs
if (moduleexists && roiexists)
    probe = getTotalModuleCount(probe);
    if (optodesexists)
        probe = getTotalOptodeCount(probe);
        probe = getChannelData(probe);
        if (sdrangeexists)
            probe = getBrainSensitivity(probe);
            probe = getSpatialMultiplexingGroups(probe);
        end
    end
else
    disp('Incorrect design parameters');
end


end

