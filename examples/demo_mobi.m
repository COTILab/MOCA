% Basic MOBI functionality


%% Original, "straight line" probe
% 1 - Module geometry - MOBI Module - Blue icons in flowchart inside MOCA
% github
probe.module = createModule("MOBI", 53);
probe.module.srcposns = [16,0; -16,0; 0,11;];
probe.module.detposns = [0,19;0,-19];
probe.spacing = 4; % adding 2mm of silicone in circuit cover
probe.roi = createROI(200,80); % width and height
    

% 2 - Assembly processes
% Probe
probe = createLayout(probe); % assembly processes
triheight = 50*sind(60);
    
%%%%% Probe Layout 6 %%%% - 8 modules total
probe = rotateModules(probe, [1], 120);
%probe = rotateModules(probe, [2], -120);
probe = translateModules(probe, [2], [-4 0]);

% For single row, 3 modules, long channels for SNR
probe.sdrange = 35; %100;
probe = toggleModules(probe, [3,4], 'off');



% 3 - Probe Characterization
probe = characterizeProbe(probe);
figure
moca_plotProbe(probe); 
plotROI(probe)
probe.results




%% New MOCA scripts to only plot modules/channels as fillers for MOCA
% Visualization
figure
axis equal
moca_plotProbe(probe, 'outline'); % plots the module outlines, dashed in gray
moca_plotProbe(probe, 'srcs'); % plots only the srcs
moca_plotProbe(probe, 'dets'); % plots only the dets
moca_plotProbe(probe, 'srcnumbers'); % plots text numbers over optodes
moca_plotProbe(probe, 'detnumbers'); % plots text numbers over optodes
%plotSingleChannel(probe, 1, 2);  % plots a single channel between a source and detector

% Plot all intra channels
% channels = [separation, srcidx, detidx, srcmodidx, detmodidx]
for i=1:size(probe.results.intrachannels,1)
    plotSingleChannel(probe, probe.results.intrachannels(i,2),...
        probe.results.intrachannels(i,3),...
        '-',[0.5 0.5 0.5]);
end
% Plot all inter channels
for i=1:size(probe.results.interchannels,1)
    plotSingleChannel(probe, probe.results.interchannels(i,2),...
        probe.results.interchannels(i,3),...
        '--',[0.5 0.5 0.5]); % LineStyle, Color
end



%% If plots look good, save it
mocaprobe = probe;
save('Single_Row_2module', 'mocaprobe');

% Create SD structure and export
SD = exportOptodes(mocaprobe, 'mocaexport.SD');
