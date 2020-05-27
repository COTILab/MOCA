% This example creates a square module with optodes. It then uses MOCA's 
% automated createLayout() function to overlay the module over the ROI.
% Once this probe is generated, this demo shows how to toggle individual
% modules on/off, how to translate the probe relative to ROI, and how to
% rotate individual modules. 



% Design Parameters (module, roi, SD sep range)
probe.module = createModule(4, 35); % nsides, mdimension
probe.roi = createROI(160,120);     % width and height
probe.module.srcposns = [-12.5,12.5; 12.5,-12.5];
probe.module.detposns = [-12.5,4; 12.5,12.5; 12.5,-4];

% Assembly Processes
probe.spacing = 10; 
probe = createLayout(probe); 

% Visualize the current probe
figure; plotProbe(probe); plotROI(probe)

% Toggle individual modules on and off
probe = toggleModules(probe, [2 8], 'off');

% Translate the entire probe relative to ROI
probe = translateProbe(probe, [20 40]);
probe = translateProbe(probe, 'center'); % centered probe to ROI

% Rotate individual modules
probe = rotateModules(probe, [1 9], 45);
probe = rotateModules(probe, [7], -15);

% Translate individual modules
probe = translateModules(probe, [1], [-10 -10]);

% Visualize the changes to the probe
figure; plotProbe(probe); plotROI(probe);
plotDiGraph(probe);


%% Probe Characterization
probe = characterizeProbe(probe);

% Visualize Characterization - plot channel histogram
% note: since sdrange wasn't defined, it shows all channels, regardless of
% SD separation
figure; 
plotChannels(probe, 'hist', 'sd'); 

% Visualize Characterization - plot probe + all channels by intra/inter
figure; 
plotProbe(probe); 
plotROI(probe); 
plotChannels(probe, 'spat', 'sd', 'int');




