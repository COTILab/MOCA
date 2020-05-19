addpath('lib')
clear all

%% Design Parameters (cfg)
clear all

% Single Module Geometry
% design.module is an Nx2 matrix spcifying the perimeter of the module
design.module = createModule(4, 35); % nsides, mdimension

% Region-of-interest Geometry
% design.roi is an Nx2 matrix specifying the perimeter of the ROI.
design.roi = createROI(100, 60); % width and height


