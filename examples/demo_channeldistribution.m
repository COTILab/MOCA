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

figure; plotProbe(probe); plotROI(probe); 
plotChannels(probe, 'spat', 'sd', 'col');
title('SD separations by color and line length')

figure; plotProbe(probe); plotROI(probe); 
plotChannels(probe, 'spat', 'sd', 'int');
title('SD separations by intra vs inter')

figure; plotChannels(probe, 'hist', 'sd'); 
title('Histogram of channels limited by SDrange')

figure; plotChannels(probe, 'hist', 'full'); 
title('Histogram of channels, all (not limited)')

%% Individually control module and channel color
% useful for embedding MOCA into visualization software
figure; 

plotProbe(probe, 'outline'); % plots the module outlines, dashed in gray
plotProbe(probe, 'srcs'); % plots only the srcs
plotProbe(probe, 'dets'); % plots only the dets
plotProbe(probe, 'srcnumbers'); % plots text numbers over optodes
plotProbe(probe, 'detnumbers'); % plots text numbers over optodes

% Plot all intra channels
for i=1:size(probe.results.intrachannels,1)
    plotSingleChannel(probe, probe.results.intrachannels(i,2),...
        probe.results.intrachannels(i,3),...
        '-',[0.5 0.5 0.5]);
end
% Plot all inter channels
for i=1:size(probe.results.interchannels,1)
    plotSingleChannel(probe, probe.results.interchannels(i,2),...
        probe.results.interchannels(i,3),...
        'none',[0.5 0.5 0.5]); % LineStyle, Color
end

axis equal
