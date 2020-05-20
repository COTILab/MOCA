addpath('lib')

%% Design Parameters (module, roi, SD sep range)
clear all

% Single Module Geometry
% design.module is an Nx2 matrix specifying the xy coordinates of the
% perimeter of the module. The module should be centered at [x,y]=[0,0].
% All values in mm.
module = createModule(4, 40); % nsides, mdimension

% Region-of-interest Geometry
% design.roi is an Nx2 matrix specifying the perimeter of the ROI. All
% values in mm.
probe.roi = createROI(150,90); % width and height

% Optode layout on a single module
% srcpsns and detposns within design.layout must each be Nx2 matrix
% specifying the xy coordinates of the sources (srcposns) and detectors
% (detposns) within the module. All values in mm
module.srcposns = [-12.5,12.5; 12.5,-12.5];
module.detposns = [-12.5,4; 12.5,12.5; 12.5,-4; -12.5,-12.5];

% Maximum Source Detector Separation
% A double specifying the maximum SD separation, inclusive, that channels
% can have. If a 1x2 matrix is defined, then design.maxsdsep(1) is the
% lower end of the SD range. Channels < design.maxsdsep(1) are considered
% short-separation (SS) channels. The default SS channel threshold is 10mm,
% inclusive. Value should be in mm.
probe.sdrange = 40;

%% Visualizing the design structure
figure; plotModule(module);
figure; plotROI(probe);

%% Assembly Processes
probe.spacing = 20;  % not necessary
probe = createLayout(module, probe); %roi, SDrange, spacing);

% Visualize probe
figure; plotProbe(probe)



