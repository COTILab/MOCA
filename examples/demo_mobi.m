% Outputs a single row 2 MOBI-module probe


%% Original, "straight line" probe
% Module geometry - MOBI Module
probe.module = createModule("MOBI", 53);
probe.module.srcposns = [16,0; -16,0; 0,11;];
probe.module.detposns = [0,19;0,-19];
probe.spacing = 4; % adding 2mm of silicone in circuit cover
probe.roi = createROI(100,50-(-30)); % width and height
    
% Probe
probe = createLayout(probe); 
triheight = 50*sind(60);
    
%%%%% Probe Layout 6 %%%% - 8 modules total
probe = rotateModules(probe, [1:2], 120);
    
%probe = translateProbe(probe, -1*abs([minx, miny]));
%probe = translateProbe(probe, [13.25 -22.9497]);
probe = translateModules(probe, [2], [-4 0]);

% For single row, 3 modules, long channels for SNR
probe.sdrange = 35; %100;


probe = characterizeProbe(probe);
figure
moca_plotProbe(probe); 
%plotROI(probe)
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

%% Create SD structure and export
SD = exportOptodes(mocaprobe, 'mocaexport.SD');
