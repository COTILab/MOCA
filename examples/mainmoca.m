addpath('lib')

%% Design Parameters (module, roi, SD sep range)
clear all

probe.module = createModule(4, 35); % nsides, mdimension

probe.roi = createROI(160,120); % width and height
%probe.roi = [160 0; 0 0; 0 160; 120 160; 120 130; 60 80; 60 40; 120 60]; 

probe.module.srcposns = [-12.5,12.5; 12.5,-12.5];
probe.module.detposns = [-12.5,4; 12.5,12.5; 12.5,-4; -12.5,-12.5];

probe.sdrange = 100;

% Visualizing the design structure
figure; plotModule(probe);
figure; plotROI(probe);

%% Assembly Processes
probe.spacing = 10; 
probe = createLayout(probe); 

figure; plotProbe(probe); plotROI(probe)

% Adjustments to probe assembly
probe = toggleModules(probe, [8 12 16], 'off');
probe = translateProbe(probe, 'center');
probe = rotateModules(probe, [11], 45);
probe = rotateModules(probe, [7], 15);

figure; plotProbe(probe); plotROI(probe)
%% Probe Characterization
probe = characterizeProbe(probe);

%% Visualize Characterization
% plot channel histogram
figure; 
plotChannels(probe, 'hist', 'sd'); 
% plot probe + all channels by color/separation
figure; 
plotProbe(probe); 
plotROI(probe); 
plotChannels(probe, 'spat', 'sd', 'int');
% brain sensitivity
figure; 
plotProbe(probe); 
plotROI(probe); 
plotBrainSensitivity(probe, 'all');
% spatial multiplexing groups
figure; plotProbe(probe); plotROI(probe); plotSpatialMultiplexingGroups(probe, [1:20]);

%% Spatial Multiplexing groups gif
fig = figure
ngroups = size(unique(probe.results.groupings(:,5)), 1);
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
    
%     frame = getframe(gcf);
%     img =  frame2im(frame);
%     [img,cmap] = rgb2ind(img,256);
%     if i == 1
%         imwrite(img,cmap,'animation.gif','gif','LoopCount',Inf,'DelayTime',1);
%     else
%         imwrite(img,cmap,'animation.gif','gif','WriteMode','append','DelayTime',1);
%     end
    
end

