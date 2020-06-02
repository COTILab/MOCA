
%% Design Parameters (module, roi, SD sep range)
clear all

% Lumo
probe.module = createModule(6, 18);
y1 = 10; 
probe.module.srcposns = [0,               y1;...
                        y1*cosd(30),    -y1*sind(30);...
                        -y1*cosd(30),   -y1*sind(30);];
probe.module.detposns = [y1*cosd(30),    y1*sind(30);...
                        0,              -y1;
                        -y1*cosd(30),   y1*sind(30);...
                        0,              0]; 

                    
%figure; plotModule(probe);
probe.roi = createROI(100,85); % width and height
probe.sdrange = [10 40];

% Visualizing the design structure
%figure; plotModule(probe);
%figure; plotROI(probe);

%% Assembly Processes
probe.spacing = 5;
probe = createLayout(probe); 
figure; plotProbe(probe); plotROI(probe)

%%
% Adjustments to probe assembly
probe = toggleModules(probe, [2 8 9], 'off');
probe = translateProbe(probe, 'center');
probe = rotateModules(probe, [7 5 6], 15);
probe = translateModules(probe, [1 5], [-20 0]);
figure; plotProbe(probe); plotROI(probe); 

probe = reorientModules(probe);
figure; plotProbe(probe); plotROI(probe); plotDiGraph(probe);

%% Probe Characterization
probe = characterizeProbe(probe);

%% Visualize Characterization - channel distribution
% plot channel histogram
figure; 
plotChannels(probe, 'hist', 'sd'); 
% plot probe + all channels by color/separation
figure; 
plotProbe(probe); 
plotROI(probe); 
plotChannels(probe, 'spat', 'sd', 'int');

%% brain sensitivity
figure; 
plotProbe(probe); 
plotROI(probe); 
plotBrainSensitivity(probe, 'all');

%% spatial multiplexing groups
ngroups = size(unique(probe.results.groupings(:,5)), 1);
figure; plotProbe(probe); plotROI(probe); plotSpatialMultiplexingGroups(probe, [1:ngroups]);

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

