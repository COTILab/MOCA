% This example creates a square module with optodes. It then uses MOCA's 
% automated createLayout() function to overlay the module over the ROI.
% Once this probe is generated, this demo shows how to toggle individual
% modules on/off, how to translate the probe relative to ROI, and how to
% rotate individual modules. Finally, it produces channel distribution,
% brain sensitivity, and spatial multiplexing group plots

clear all

% Design Parameters (module, roi, SD sep range)
probe.module = createModule(4, 35); % nsides, mdimension
probe.roi = createROI(160,120); % width and height
probe.module.srcposns = [-12.5,12.5; 12.5,-12.5];
probe.module.detposns = [-12.5,4; -4,12.5; 12.5,4];
probe.sdrange = 45;


% Assembly Processes
probe.spacing = 10; 
probe = createLayout(probe); 
% Visualize the current probe
figure; plotProbe(probe); plotROI(probe)
title('Probe prior to manipulation')

% Manually manipulate probe
probe = toggleModules(probe, [2 8], 'off');
probe = translateProbe(probe, [20 40]);
probe = translateProbe(probe, 'center'); % centered probe to ROI
probe = rotateModules(probe, [1 6], -15);
probe = translateModules(probe, [9:12], [0 15]);
% Visualize the changes to the probe
figure; plotProbe(probe); plotROI(probe);
title('Manually manipulated probe')


% Characterize Probe
probe = characterizeProbe(probe);

% Channel Distribution Results
figure; plotChannels(probe, 'hist', 'sd'); 
title('Histogram of channels limited by SDrange')

% Brain Sensitivity Results
figure; 
plotProbe(probe); plotROI(probe); plotBrainSensitivity(probe);
title('All Channel Brain Sensitivity')
figure; 
plotProbe(probe); plotROI(probe); plotBrainSensitivity(probe, 'inter');
title('Inter Channel Brain Sensitivity')
figure; 
plotProbe(probe); plotROI(probe); plotBrainSensitivity(probe, 'intra');
title('Intra Channel Brain Sensitivity')

% Spatial multiplexing groups
ngroups = size(unique(probe.results.groupings(:,5)), 1);
figure; plotProbe(probe); plotROI(probe); 
plotSpatialMultiplexingGroups(probe, [2]);

%%
fig = figure
giftitle = 'examples/loopinggroups.gif';
for i=1:ngroups
    clf(fig)
    
    plotProbe(probe);
    plotROI(probe);
    plotSpatialMultiplexingGroups(probe, [i]);
    
    title(strcat('Group: ',num2str(i),'/',num2str(ngroups)))
    
    xlim([min(probe.srcposns(:,1))-probe.sdrange(2),...
        max(probe.srcposns(:,1))+probe.sdrange(2)]);
    ylim([min(probe.srcposns(:,2))-probe.sdrange(2),...
        max(probe.srcposns(:,2))+probe.sdrange(2)]);
    
    pause(1);
    
    frame = getframe(gcf);
    img =  frame2im(frame);
    [img,cmap] = rgb2ind(img,256);
    if i == 1
        imwrite(img,cmap,giftitle,'gif','LoopCount',Inf,'DelayTime',1);
    else
        imwrite(img,cmap,giftitle,'gif','WriteMode','append','DelayTime',1);
    end
    
end

