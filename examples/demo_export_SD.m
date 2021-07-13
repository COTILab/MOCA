% This script takes all the sources and detectors of a probe designed in
% MOCA and exports them as an .SD file for use in AtlasViewerGUI

clear all

% Create a layout
% Design Parameters (module, roi, SD sep range)
probe.module = createModule(4, 35); % nsides, mdimension
probe.roi = createROI(70,70);     % width and height
probe.module.srcposns = [-12.5,12.5; -12.5,-12.5; 12.5,0];
probe.module.detposns = [-10.5,4; 0,2];
probe.sdrange = 30;

% Assembly Processes
probe = createLayout(probe); 

% Probe Characterization
probe = characterizeProbe(probe);

figure; plotProbe(probe); plotROI(probe)
figure; plotProbe(probe); plotROI(probe); 
plotChannels(probe, 'spat', 'sd', 'int');
title('SD separations by intra vs inter')


% Create SD structure and export
SD = exportOptodes(probe, 'examples/mocaexport.SD');

