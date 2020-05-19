addpath('lib')
clear all

%% Design Parameters (cfg)
clear cfg

% Single Module Geometry
nsides = 4;         % number of sides of a module. Can be 3,4, or 6
mdimension = 35;    % length of one side of a module
cfg.modulegeometry = createModule(nsides, mdimension);

% Region-of-interest Geometry

% Optode Layout on a Single Module

% Maximum Source Detector Separation