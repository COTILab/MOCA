% This example takes in a hexagonal shape and varies the spacing from 0 to
% a specified amount. The number of channels, brain sensitivity, and
% spatial multiplexing groups are calculated for each spacing. 

clear all

% Lumo modules
probe.module = createModule(6, 18);
y1 = 10; 
probe.module.srcposns = [0,               y1;...
                        y1*cosd(30),    -y1*sind(30);...
                        -y1*cosd(30),   -y1*sind(30);];
probe.module.detposns = [y1*cosd(30),    y1*sind(30);...
                        0,              -y1;
                        -y1*cosd(30),   y1*sind(30);...
                        0,              0]; 
probe.sdrange = [10 40];

% 3-4-5 lumo probe, no space.                     
probe.roi = createROI(150,80); % width and height
probe.spacing = 0;
probe = createLayout(probe); 
probe = toggleModules(probe, [10 11 15], 'off');

figure; plotProbe(probe); plotROI(probe)


%% vary spacing
fig = figure;    
c = 1;
separations = 0:20;

for s=separations
    % clear and reset probe
    clf(fig)
    
    % vary the spacing
    probe.spacing = s;
    probe.roi = createROI(150+(s*2),80);    % 150,160,170,180,190
    probe = createLayout(probe); 
    probe = toggleModules(probe, [10 11 15], 'off');
    
    % Re-characterize and save the results structur
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
    title(strcat('Spacing: ',num2str(s),'mm'))
    pause(.01)
    
    c = c+1;
    
end


%% Create visual plots of exhaustive search

% Channels
figure
plot(separations, channels, '*-')
xlabel('Spacing between modules');
ylabel('Number of channels');
title('Number of channels per combination');

% Inter-module Channels
figure
plot(separations, interchannels, '*-')
xlabel('Spacing between modules');
ylabel('Number of channels');
title('Number of inter-module channels per combination');

% Brain Sensitivity
figure
plot(separations, brainsensitivity, '*-')
xlabel('Spacing between modules');
ylabel('Average Brain Sensitivity');
title('Average Brain Sensitivity per combination');
maxBSval = max(brainsensitivity);
maxBSidx = find(brainsensitivity == maxBSval);

% Number of SMGs
figure
plot(separations, ngroups, '*-')
xlabel('Spacing between modules');
ylabel('Number of Spatial Multiplexing Groups');
title('Number of SMGs per combination');