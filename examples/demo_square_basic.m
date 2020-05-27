% This example creates a square module and tessellates it over a
% rectangular ROI. Since only the minimum number of design parameters are
% defined (module geometry and ROI geometry), the only characterization
% that can be outputed in the number of modules. 

% Design Parameters (module, roi, SD sep range)
probe.module = createModule(4, 35); % nsides, mdimension
probe.roi = createROI(160,120);     % width and height

% Assembly Processes
probe = createLayout(probe); 

% Probe Characterization
probe = characterizeProbe(probe);
probe.results.modulecount

% Visualize probe
figure; plotProbe(probe); plotROI(probe)




%% Adjustments to probe assembly
%probe = toggleModules(probe, [8 12 16 20], 'off');
%probe = translateProbe(probe, 'center');
%probe = rotateModules(probe, [11], 45);
%probe = rotateModules(probe, [7], 15);

