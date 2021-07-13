% This example creates a square module, tessellates it in a 2x2
% configuration, and performs all permutations of orientation of each
% module. It calculates number of channels, Brain Sensitivity, and nSMGs. 

clear all

% Design Parameters (module, roi, SD sep range)
probe.module = createModule(4, 35); % nsides, mdimension
probe.roi = createROI(70,70);     % width and height
probe.module.srcposns = [-12.5,12.5];
probe.module.detposns = [-12.5,4];
%probe.sdrange = 40;

% Assembly Processes
probe = createLayout(probe); 

% Probe Characterization
probe = characterizeProbe(probe);
figure; plotProbe(probe); plotROI(probe)


%% Study all permutations
[cfgs] = exhaustOrientation(probe)


%% Create visual plots of exhaustive search

% get appropriate individual metrics from all configurations
for i=1:size(cfgs,2) %permutations
    channels(i) = size(cfgs(i).results.channels,1);
    intrachannels(i) = size(cfgs(i).results.intrachannels,1);
    interchannels(i) = size(cfgs(i).results.interchannels,1);
    brainsensitivity(i) = mean( cfgs(i).results.brainsensitivity(:,1) );
    intrabrainsensitivity(i) = mean( cfgs(i).results.intrabrainsensitivity(:,1) );
    interbrainsensitivity(i) = mean( cfgs(i).results.interbrainsensitivity(:,1) );
    ngroups(i) = cfgs(i).results.ngroups;
end

%% plot on single figure
figure
set(gca,'FontSize',20)
hold on

% left side
yyaxis left
plot(1:size(cfgs,2), 100*brainsensitivity, 'b*-', 'LineWidth',2, 'MarkerSize',10)
maxBSval = max(brainsensitivity); maxBSidx = find(brainsensitivity == maxBSval);
plot(maxBSidx, 100*maxBSval, 'r*', 'LineWidth',2, 'MarkerSize',10);

plot(1:size(cfgs,2), ngroups, 'c+-', 'LineWidth',2, 'MarkerSize',10);

ylabel({'Average Brain Sensitivity [%]';'Number of SMGs [N]'})
xlabel('Offset staggering [mm]');

% right side
yyaxis right
plot(1:size(cfgs,2), channels, 'x-', 'LineWidth',2, 'MarkerSize',10)
ylabel('Number of channels [N]');

legend('Average Brain Sensitivity', 'Max Brain Sensitivity', 'Number of SMGs', 'Number of Channels', 'Location', 'NorthWest')
title('Number of channels, Average Brain Sensitivity, and Spatial Multiplexing Groups')

%%
% % Channels
% figure
% plot(1:size(cfgs,2), channels, '*-')
% xlabel('Configuration number');
% ylabel('Number of channels');
% title('Number of channels per combination');
% 
% % Inter-module Channels
% figure
% plot(1:size(cfgs,2), interchannels, '*-')
% xlabel('Configuration number');
% ylabel('Number of channels');
% title('Number of inter-module channels per combination');
% 
% % Brain Sensitivity
% figure
% plot(1:size(cfgs,2), brainsensitivity, '*-')
% xlabel('Configuration number');
% ylabel('Average Brain Sensitivity');
% title('Average Brain Sensitivity per combination');
% maxBSval = max(brainsensitivity);
% maxBSidx = find(brainsensitivity == maxBSval);
% hold on
% plot(maxBSidx, maxBSval, 'r*');
% 
% % Number of SMGs
% figure
% plot(1:size(cfgs,2), ngroups, '*-')
% xlabel('Configuration number');
% ylabel('Number of Spatial Multiplexing Groups');
% title('Number of SMGs per combination');
