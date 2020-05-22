addpath('lib')

%% Design Parameters (module, roi, SD sep range)
clear all

% Single Module Geometry
% design.module is an Nx2 matrix specifying the xy coordinates of the
% perimeter of the module. The module should be centered at [x,y]=[0,0].
% All values in mm.
probe.module = createModule(4, 40); % nsides, mdimension

% Region-of-interest Geometry
% design.roi is an Nx2 matrix specifying the perimeter of the ROI. All
% values in mm.
probe.roi = createROI(160,120); % width and height

% Optode layout on a single module
% srcpsns and detposns within design.layout must each be Nx2 matrix
% specifying the xy coordinates of the sources (srcposns) and detectors
% (detposns) within the module. All values in mm
probe.module.srcposns = [-12.5,12.5; 12.5,-12.5];
probe.module.detposns = [-12.5,4; 12.5,12.5; 12.5,-4; -12.5,-12.5];

% Maximum Source Detector Separation
% A double specifying the maximum SD separation, inclusive, that channels
% can have. If a 1x2 matrix is defined, then design.maxsdsep(1) is the
% lower end of the SD range. Channels < design.maxsdsep(1) are considered
% short-separation (SS) channels. The default SS channel threshold is 10mm,
% inclusive. Value should be in mm.
probe.sdrange = 50;

% Visualizing the design structure
figure; plotModule(probe);
figure; plotROI(probe);

%% Assembly Processes
probe.spacing = 10;  % not necessary
probe = createLayout(probe); %roi, SDrange, spacing);

% Adjustments to probe assembly
probe = toggleModules(probe, [7], 'off');
probe = translateProbe(probe, 'center');
probe = rotateModules(probe, [1 4], 45);

figure; plotProbe(probe); plotROI(probe)

%% Probe Characterization
probe = characterizeProbe(probe);

%% Visualize Characterization
% plot channel histogram
figure; plotChannels(probe, 'hist', 'sd'); 
% plot probe + all channels by color/separation
figure; plotProbe(probe); plotROI(probe); plotChannels(probe, 'spat', 'sd', 'int');
% brain sensitivity
figure; plotProbe(probe); plotROI(probe); plotBrainSensitivity(probe, 'all');

%%
figure; plotSpatialMultiplexingGroups(probe, [1 2 3]);

