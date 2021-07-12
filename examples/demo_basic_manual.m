% This example shows how to NOT use MOCA assembly functions to create a
% probe. Design parameters and probe are set manually, and
% characterizeProbe() is still used to determine metrics

clear all

% Design Parameters 
% Manually define the perimeter, src/det posns, and roi
probe.module.perimeter = [-17.5000   17.5000;
                           17.5000   17.5000;
                           17.5000  -17.5000;
                          -17.5000  -17.5000];

probe.roi = [160 0; 0 0; 0 80; 60 80; 60 40; 120 60];  

probe.module.srcposns = [-12.5,12.5];
probe.module.detposns = [-12.5,4];
probe.sdrange = 40;

% Assembly Processes
% manually add the coordinates of the module centers and optodes in the
% probe
% [x y angle activeFlag]
probe.modules = [17.5000   17.5000         0    1.0000;
   52.5000   17.5000         0    1.0000;
   87.5000   17.5000         0    1.0000;
  122.5000   17.5000         0    1.0000;
   17.5000   52.5000         0    1.0000;
   52.5000   52.5000         0    1.0000];
%[x y moduleID sourceID]
probe.srcposns =      [5    30     1     1;
    40    30     2     2;
    75    30     3     3;
   110    30     4     4;
     5    65     5     5;
    40    65     6     6;];
%[x y moduleID detectorID]
probe.detposns =     [5.0000   21.5000    1.0000    1.0000;
   40.0000   21.5000    2.0000    2.0000;
   75.0000   21.5000    3.0000    3.0000;
  110.0000   21.5000    4.0000    4.0000;
    5.0000   56.5000    5.0000    5.0000
   40.0000   56.5000    6.0000    6.0000];


% Probe Characterization
% Can still characterize the probe using MOCA's function. 
probe = characterizeProbe(probe);

% Visualize probe
figure; plotProbe(probe); plotROI(probe)
figure; plotChannels(probe, 'hist', 'sd'); 

%% Alternatively, use the automated processes and remove excess modules
clear all

% Design parameters
probe.module = createModule(4, 35); % nsides, mdimension
probe.roi = [130 0; 0 0; 0 80; 60 80; 60 40; 120 60];  
probe.module.srcposns = [-12.5,12.5];
probe.module.detposns = [-12.5,4];
probe.sdrange = 40;

% Assembly processes
probe.spacing = 0;
probe = createLayout(probe); 
probe = toggleModules(probe, [7:15], 'off');

% Probe Characterization
probe = characterizeProbe(probe);

% Visualize probe
figure; plotProbe(probe); plotROI(probe)
figure; plotChannels(probe, 'hist', 'sd'); 
