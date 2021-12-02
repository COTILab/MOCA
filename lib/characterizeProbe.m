function [probe] = characterizeProbe(probe)
%CHARACTERIZEPROBE Derives characterization metrics of a probe
%   This function takes in design parameters and assembly processes to
%   produce quantitative metrics that characterize the probe. The number of
%   characterizations depends on the number of inputted parameters. When
%   fully defined, this results in total module count, total optode count,
%   channel distribution, brain sensitivity, and assignment of sources into
%   spatial multiplexing groups. 

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
if (isfield(probe, 'smg_addl_radius'))  % if it extra radius for SMGs exists
    % do nothing
else                                    % it doesn't exist
    probe.smg_addl_radius = 0;
end

% Run the characterizations based on defined inputs
if (moduleexists && roiexists)
    probe = getTotalModuleCount(probe);
    if (optodesexists)
        probe = getTotalOptodeCount(probe);
        probe = getChannelData(probe);
        probe.results.SD = exportOptodes(probe);
        if (sdrangeexists)
            probe = getBrainSensitivity(probe);
            probe = getSpatialMultiplexingGroups(probe);
            [globalmatrix, localmatrix] = getSMGMatrix(probe,'num');
            probe.results.globalgroupmatrix = globalmatrix;
            probe.results.localgroupmatrix = localmatrix;
        end
    end
else
    disp('Incorrect design parameters');
end


end

