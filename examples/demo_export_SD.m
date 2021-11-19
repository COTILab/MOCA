% This script takes all the sources and detectors of a probe designed in
% MOCA and exports them as an .SD file for use in AtlasViewerGUI

clear all

% Create a layout
% Design Parameters (module, roi, SD sep range)
probe.module = createModule(4, 50); % nsides, mdimension
probe.roi = createROI(100,100);     % width and height
probe.module.srcposns = [-20.5,20.5; -20.5,-20.5; 20.5,0];
probe.module.detposns = [-17.5,6; 0,5];
probe.sdrange = 40;

% Assembly Processes
probe = createLayout(probe); 

% Probe Characterization
probe = characterizeProbe(probe);

figure; plotProbe(probe); plotROI(probe)
plotChannels(probe, 'spat', 'sd', 'int');
title('SD separations by intra vs inter')


% Create SD structure and export
SD = exportOptodes(probe, 'examples/mocaexport.SD');

