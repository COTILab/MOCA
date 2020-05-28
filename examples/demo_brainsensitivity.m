% This example demos options for plotBrainSensitivity(). If plotted
% alongside plotProbe() and plotROI(), the probe, it's optodes, and a
% spatial brain sensitivity plot can show areas of high channel density

clear all

%% Design Parameters (module, roi)
probe.module = createModule(4, 30); % nsides, mdimension

probe.roi = createROI(100,90);      % width and height

probe.module.srcposns = [-12.5,12.5; 12.5,-12.5];
probe.module.detposns = [-12.5,4; -4,12.5; 12.5,4];

probe.sdrange = 40;

%% Assembly Processes
probe.spacing = 5;
probe = createLayout(probe); 

figure; plotProbe(probe); plotROI(probe)

%% Probe Characterization
probe = characterizeProbe(probe);

%% Visualize Characterization
% Plot spatial brain sensitivity of all channels within sdrange
figure; 
plotProbe(probe); 
plotROI(probe); 
plotBrainSensitivity(probe);
title('All Channel Brain Sensitivity')

% Plot spatial brain sensitivity of INTER channels within sdrange
figure; 
plotProbe(probe); 
plotROI(probe); 
plotBrainSensitivity(probe, 'inter');
title('Inter Channel Brain Sensitivity')

% Plot spatial brain sensitivity of INTRA channels within sdrange
figure; 
plotProbe(probe); 
plotROI(probe); 
plotBrainSensitivity(probe, 'intra');
title('Intra Channel Brain Sensitivity')


