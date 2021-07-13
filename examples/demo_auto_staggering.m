% this script takes in a M3BA module and varies it's staggering until the
% modules are adjacent to their original neighbors. The number of channels,
% brain sensitivity, and spatial multiplexing groups are saved

clear all

probe.module = createModule(4, 42);
y1 = 10; pos = 14;
probe.module.srcposns = [pos, pos; -pos, -pos];
probe.module.detposns = [-pos, pos; pos, -pos]; 

probe.roi = createROI(40,120); % width and height
probe.spacing = 0;
probe.sdrange = [10 40];
probe = createLayout(probe); 

probe = characterizeProbe(probe);

figure
plotProbe(probe);

%%
fig = figure
c = 1;
t_offsets = 0:5:40;

for t=t_offsets
    % reset layout
    clf(fig)
    probe = createLayout(probe); 
    
    % vary the staggering
    probe = translateModules(probe, [2], [t 0]);
    
    % Re-characterize and save the results structure
    probe = characterizeProbe(probe);
    output(c).results = probe.results;
    
    % save individual metrics
    channels(c) = size(output(c).results.channels,1);
    intrachannels(c) = size(output(c).results.intrachannels,1);
    interchannels(c) = size(output(c).results.interchannels,1);
    brainsensitivity(c) = mean( output(c).results.brainsensitivity(:,1) );
    intrabrainsensitivity(c) = mean( output(c).results.intrabrainsensitivity(:,1) );
    interbrainsensitivity(c) = mean( output(c).results.interbrainsensitivity(:,1) );
    ngroups(c) = output(c).results.ngroups;
    
    % visual display
    plotProbe(probe); 
    title(strcat('Staggering: ',num2str(t),'mm'))
    pause(.01)
    c= c+1;
    
end

%% Create visual plots of exhaustive search

% Channels
figure
plot(t_offsets, channels, '*-')
xlabel('Offset staggering [mm]');
ylabel('Number of channels');
title('Number of channels per staggering amount');

% Inter-module Channels
figure
plot(t_offsets, interchannels, '*-')
xlabel('Offset staggering [mm]');
ylabel('Number of channels');
title('Number of inter-module channels per staggering amount');

% Brain Sensitivity
figure
plot(t_offsets, brainsensitivity, '*-')
xlabel('Offset staggering [mm]');
ylabel('Average Brain Sensitivity');
title('Average Brain Sensitivity per staggering amount');
maxBSval = max(brainsensitivity);
maxBSidx = find(brainsensitivity == maxBSval);

% Number of SMGs
figure
plot(t_offsets, ngroups, '*-')
xlabel('Offset staggering [mm]');
ylabel('Number of Spatial Multiplexing Groups');
title('Number of SMGs per combination');