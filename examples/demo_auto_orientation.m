% This example creates a square module, tessellates it in a 2x2
% configuration, and performs all permutations of orientation of each
% module. It calculates number of channels, Brain Sensitivity, and nSMGs. 

clear all

% Design Parameters (module, roi, SD sep range)
probe.module = createModule(4, 35); % nsides, mdimension
probe.roi = createROI(70,35);     % width and height
probe.module.srcposns = [-12.5,12.5];
probe.module.detposns = [-12.5,4];
%probe.sdrange = 40;

% Assembly Processes
probe = createLayout(probe); 

% Probe Characterization
probe = characterizeProbe(probe);



%% Number of combinations for this layout.
orientations = [0 90 180 270];
nPossibleOrientations = size(orientations,2);
nModules = probe.results.modulecount;
nCombinations = nPossibleOrientations^nModules;

% create array of orientations
vectors = { orientations, orientations}; %input data: cell array of vectors
n = numel(vectors); % number of vectors
combs = cell(1,n); % pre-define to generate comma-separated list
[combs{end:-1:1}] = ndgrid(vectors{end:-1:1}); % the reverse order in these two
% comma-separated lists is needed to produce the rows of the result matrix 
combs = cat(n+1, combs{:}); %concat the n n-dim arrays along dimension n+1
combs = reshape(combs,[],n); %reshape to obtain desired matrix


%% Run through all combinations
fig = figure;    
    
for c=1:size(combs,1) %permutations
    % clear and reset probe
    clf(fig)
    c
    probe = createLayout(probe); % reset back to basic
    
    % change orientation of modules based on combination
    probe = rotateModules(probe, [1], combs(c,1));
    probe = rotateModules(probe, [2], combs(c,2));
    
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
    plotProbe(probe); plotROI(probe)
    title(strcat('Combination: ',num2str(c),'/',num2str(nCombinations)))
    pause(.1)
end


%% Create visual plots of exhaustive search

% Channels
figure
plot(1:size(combs,1), channels, '*-')
xlabel('Combination number');
ylabel('Number of channels');
title('Number of channels per combination');

% Inter-module Channels
figure
plot(1:size(combs,1), interchannels, '*-')
xlabel('Combination number');
ylabel('Number of channels');
title('Number of inter-module channels per combination');

% Brain Sensitivity
figure
plot(1:size(combs,1), brainsensitivity, '*-')
xlabel('Combination number');
ylabel('Average Brain Sensitivity');
title('Average Brain Sensitivity per combination');

% Number of SMGs
figure
plot(1:size(combs,1), ngroups, '*-')
xlabel('Combination number');
ylabel('Number of Spatial Multiplexing Groups');
title('Number of SMGs per combination');
