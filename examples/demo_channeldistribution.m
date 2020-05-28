% This example shows the various wasys plotChannels can be used. 

clear all

% Design Parameters (module, roi)
probe.module = createModule(4, 30); % nsides, mdimension
probe.roi = createROI(100,90);      % width and height
probe.module.srcposns = [-12.5,12.5; 12.5,-12.5];
probe.module.detposns = [-12.5,4; -4,12.5; 12.5,4];
probe.sdrange = 40;


% Assembly Processes
probe.spacing = 5;
probe = createLayout(probe); 
figure; plotProbe(probe); plotROI(probe)


% Probe Characterization
probe = characterizeProbe(probe);


%% Visualize Characterization - Histograms
%         Plot    | Range     | Breakdown
%         type    | type      | type
%         -------------------------------
%         'hist'* | 'sd'*     | 
%                 | 'full'    | 
%         -------------------------------
%         'spat'  | 'sd'*     | 'col'*
%                 |           | 'int'
%                 -----------------------
%                 | 'full'    | 'col'*
%                 |           | 'int'

figure; plotChannels(probe, 'hist', 'sd'); 
title('Histogram of channels limited by SDrange')

figure; plotChannels(probe, 'hist', 'full'); 
title('Histogram of channels, all (not limited)')

figure; plotProbe(probe); plotROI(probe); 
plotChannels(probe, 'spat', 'sd', 'col');
title('SD separations by color and line length')

figure; plotProbe(probe); plotROI(probe); 
plotChannels(probe, 'spat', 'sd', 'int');
title('SD separations by intra vs inter')