% this script takes in a M3BA module and varies it's staggering until the
% modules are adjacent to their original neighbors. The number of channels,
% brain sensitivity, and spatial multiplexing groups are saved

clear all

probe.module = createModule(4, 42);
y1 = 10; pos = 14;
probe.module.srcposns = [pos, pos; -pos, -pos; -pos, 0; 0,pos];
probe.module.detposns = [-pos, pos; pos, -pos]; 

probe.roi = createROI(80,120); % width and height
probe.spacing = 0;
probe.sdrange = [10 40];
probe = createLayout(probe); 

probe = characterizeProbe(probe);

figure
moca_plotProbe(probe);

%% Analyze staggering
modulesToStagger = [3,4];
staggerAmount = [1:42];

[cfgs] = exhaustStaggering(probe, modulesToStagger, staggerAmount)


%% save individual metrics and plot
for i = 1:size(cfgs,2)
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
plot(staggerAmount, 100*brainsensitivity, 'b*-', 'LineWidth',2, 'MarkerSize',10)
maxBSval = max(brainsensitivity); maxBSidx = find(brainsensitivity == maxBSval);
plot(maxBSidx, 100*maxBSval, 'r*', 'LineWidth',2, 'MarkerSize',10);

plot(staggerAmount, ngroups, 'c+-', 'LineWidth',2, 'MarkerSize',10);

ylabel({'Average Brain Sensitivity [%]';'Number of SMGs [N]'})
xlabel('Offset staggering [mm]');

% right side
yyaxis right
plot(staggerAmount, channels, 'x-', 'LineWidth',2, 'MarkerSize',10)
ylabel('Number of channels [N]');

legend('Average Brain Sensitivity', 'Max Brain Sensitivity', 'Number of SMGs', 'Number of Channels', 'Location', 'NorthEast')
title('Number of channels, Average Brain Sensitivity, and Spatial Multiplexing Groups')


%%
% % Channels
% figure
% plot(staggerAmount, channels, '*-')
% xlabel('Offset staggering [mm]');
% ylabel('Number of channels');
% title('Number of channels per staggering amount');
% 
% % Inter-module Channels
% figure
% plot(staggerAmount, interchannels, '*-')
% xlabel('Offset staggering [mm]');
% ylabel('Number of channels');
% title('Number of inter-module channels per staggering amount');
% 
% % Brain Sensitivity
% figure
% plot(staggerAmount, brainsensitivity, '*-')
% xlabel('Offset staggering [mm]');
% ylabel('Average Brain Sensitivity');
% title('Average Brain Sensitivity per staggering amount');
% maxBSval = max(brainsensitivity);
% maxBSidx = find(brainsensitivity == maxBSval)-1;
% hold on
% plot(maxBSidx, maxBSval, 'r*');
% 
% % Number of SMGs
% figure
% plot(staggerAmount, ngroups, '*-')
% xlabel('Offset staggering [mm]');
% ylabel('Number of Spatial Multiplexing Groups');
% title('Number of SMGs per combination');