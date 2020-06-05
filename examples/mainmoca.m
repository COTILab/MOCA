
clear all

probe.module = createModule(3, 50);

% all shapes have the same layout, ROI, and SD range 
probe.roi = createROI(200,60);
probe.sdrange = [10 30];
probe.module.srcposns = [0,12; -12,0];
probe.module.detposns = [0,-12; 12,0];
probe.spacing = 10;

probe = createLayout(probe); 
%probe = translateProbe(probe, 'center');
figure; plotProbe(probe); plotROI(probe);

%%
probe = characterizeProbe(probe);
squareprobe = probe;



%% Design Parameters (module, roi, SD sep range)
clear all

% Lumo
% probe.module = createModule(6, 18);
% y1 = 10; 
% probe.module.srcposns = [0,               y1;...
%                         y1*cosd(30),    -y1*sind(30);...
%                         -y1*cosd(30),   -y1*sind(30);];
% probe.module.detposns = [y1*cosd(30),    y1*sind(30);...
%                         0,              -y1;
%                         -y1*cosd(30),   y1*sind(30);...
%                         0,              0]; 

                    
% Wyser2017
% https://www.spiedigitallibrary.org/journals/neurophotonics/volume-4/issue-04/041413/Wearable-and-modular-functional-near-infrared-spectroscopy-instrument-with-multidistance/10.1117/1.NPh.4.4.041413.full
% dim = 9/cosd(30); OR 20.5/2 = 10.25mm
probe.module = createModule(6, 10.25);
probe.module.srcposns = [0, 7.5/2];
% probe.module.srcposns = [-4, 7.5/2;... 
%                         -1.33, 7.5/2;...
%                         1.33, 7.5/2;...
%                         4, 7.5/2];
probe.module.detposns = [0, -7.5/2];


% % Funane2017
% % https://doi.org/10.1117/1.NPh.5.1.011007
% % dim = 24/2 = 12mm
% probe.module = createModule(6, 12);
% probe.module.srcposns = [0, 0];
% probe.module.detposns = [0, 0];


probe.roi = createROI(100,80); % width and height
probe.sdrange = [10 30];

% Visualizing the design structure
%figure; plotModule(probe);
%figure; plotROI(probe);

% Assembly Processes
probe.spacing = 5;
probe = createLayout(probe); 
probe = translateProbe(probe, 'center');

% lumo
%probe = toggleModules(probe, [1 9], 'off');

figure; plotProbe(probe); plotROI(probe)

%
% % Adjustments to probe assembly
% probe = toggleModules(probe, [2 8 9], 'off');
% probe = translateProbe(probe, 'center');
% probe = rotateModules(probe, [7 5 6], 15);
% probe = translateModules(probe, [1 5], [-20 0]);
% figure; plotProbe(probe); plotROI(probe); 
% 
% probe = reorientModules(probe);
% figure; plotProbe(probe); plotROI(probe); plotDiGraph(probe);

% Probe Characterization
probe = characterizeProbe(probe);

% Visualize Characterization - channel distribution
% plot channel histogram
figure; 
plotChannels(probe, 'hist', 'sd'); 

% Brain Sensitivity
% figure; 
% plotProbe(probe); 
% plotROI(probe); 
% plotBrainSensitivity(probe, 'all');

bs = mean(probe.results.brainsensitivity(:,1))
intrabs = mean(probe.results.intrabrainsensitivity(:,1))
interbs = mean(probe.results.interbrainsensitivity(:,1))

% spatial multiplexing groups
ngroups = size(unique(probe.results.groupings(:,5)), 1)
% figure; plotProbe(probe); plotROI(probe); plotSpatialMultiplexingGroups(probe, [1:ngroups]);








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
    
    pause(.25);
    
%     frame = getframe(gcf);
%     img =  frame2im(frame);
%     [img,cmap] = rgb2ind(img,256);
%     if i == 1
%         imwrite(img,cmap,'animation.gif','gif','LoopCount',Inf,'DelayTime',1);
%     else
%         imwrite(img,cmap,'animation.gif','gif','WriteMode','append','DelayTime',1);
%     end
    
end

