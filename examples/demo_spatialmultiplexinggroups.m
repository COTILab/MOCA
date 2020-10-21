% This example shows how to visualize the spatial multiplexing groups
% derived from characterizing a probe. The number of groups is dependent on
% many parameters, including the number of sources in a module, their
% layout within a module, the SDrange, and the tessellation and orientation
% of each module. Here, we plot statically each group of sources overlayed
% on the probe. We also show how to generate a gif that cycles through all
% groupings of a particular probe.

clear all

%% Design Parameters (module, roi)
probe.module = createModule(4, 25); % nsides, mdimension

probe.roi = createROI(120,120);      % width and height

probe.module.srcposns = [-10.5,10.5; 10.5,-10.5];
probe.module.detposns = [-10.5,4; 10.5,10.5];

probe.sdrange = 40;

%% Assembly Processes
probe.spacing = 20;
probe = createLayout(probe); 

probe = translateProbe(probe, 'center');

figure; plotProbe(probe); plotROI(probe)

%% Probe Characterization
probe = characterizeProbe(probe);


%% Visualize Characterization - static groups
figure; 
plotProbe(probe); 
plotROI(probe); 
plotSpatialMultiplexingGroups(probe, [2,4,6]);


%% Visualize Characterization - cycle through groupings. Save a .gif
fig = figure
giftitle = 'examples/loopinggroups.gif';
ngroups = probe.results.ngroups;
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
%     if i == 1
%         imwrite(img,cmap,giftitle,'gif','LoopCount',Inf,'DelayTime',1);
%     else
%         imwrite(img,cmap,giftitle,'gif','WriteMode','append','DelayTime',1);
%     end
    
end
