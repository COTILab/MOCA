% This example takes in a hexagonal shape and varies the spacing from 0 to
% a specified amount. The number of channels, brain sensitivity, and
% spatial multiplexing groups are calculated for each spacing. 

clear all

% Lumo modules
probe.module = createModule(6, 18);
y1 = 10; 
probe.module.srcposns = [0,               y1;...
                        y1*cosd(30),    -y1*sind(30);...
                        y1*sind(30),    0;...
                        -y1*cosd(30),   -y1*sind(30);];
probe.module.detposns = [y1*cosd(30),    y1*sind(30);...
                        0,              0]; 
probe.sdrange = [10 40];

% 3-4-5 lumo probe, no space.                     
probe.roi = createROI(150,80); % width and height
probe.spacing = 0;
probe = createLayout(probe); 
probe = toggleModules(probe, [10 11 15], 'off');

figure; plotProbe(probe); %plotROI(probe)

%% Analyze the spacing
spacingAmount = 1:30;
[cfgs] = exhaustSpacing(probe, spacingAmount)


%% Extract metrics and create plots of exhaustive search

for i=1:size(spacingAmount,2)
    % save individual metrics
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
plot(spacingAmount, 100*brainsensitivity, 'b*-', 'LineWidth',2, 'MarkerSize',10)
maxBSval = max(brainsensitivity); maxBSidx = find(brainsensitivity == maxBSval);
plot(maxBSidx, 100*maxBSval, 'r*', 'LineWidth',2, 'MarkerSize',10);

plot(spacingAmount, ngroups, 'c+-', 'LineWidth',2, 'MarkerSize',10);

ylabel({'Average Brain Sensitivity [%]';'Number of SMGs [N]'})
xlabel('Offset staggering [mm]');

% right side
yyaxis right
plot(spacingAmount, channels, 'x-', 'LineWidth',2, 'MarkerSize',10)
ylabel('Number of channels [N]');

legend('Average Brain Sensitivity', 'Max Brain Sensitivity', 'Number of SMGs', 'Number of Channels', 'Location', 'NorthEast')
title('Number of channels, Average Brain Sensitivity, and Spatial Multiplexing Groups')


%% Channels
% figure
% plot(spacingAmount, channels, '*-')
% xlabel('Spacing between modules');
% ylabel('Number of channels');
% title('Number of channels per configuration');
% 
% % Inter-module Channels
% figure
% plot(spacingAmount, interchannels, '*-')
% xlabel('Spacing between modules');
% ylabel('Number of channels');
% title('Number of inter-module channels per configuration');
% 
% % Brain Sensitivity
% figure
% plot(spacingAmount, brainsensitivity, '*-')
% xlabel('Spacing between modules');
% ylabel('Average Brain Sensitivity');
% title('Average Brain Sensitivity per configuration');
% maxBSval = max(brainsensitivity);
% maxBSidx = find(brainsensitivity == maxBSval);
% hold on
% plot(maxBSidx, maxBSval, 'r*');
% 
% % Number of SMGs
% figure
% plot(spacingAmount, ngroups, '*-')
% xlabel('Spacing between modules');
% ylabel('Number of Spatial Multiplexing Groups');
% title('Number of SMGs per configuration');