function [cfgs] = exhaustSpacing(probe, spacingAmount)
%EXHAUSTIVESPACING Varies spacing between modules, exhaustively
%   Varies the spacing between modules by the amount specified in the row
%   vector spacingAmount. Each new configuration is then analyzed. This
%   results in a cfgs structure with the number of channels, average brain
%   sensitivity, and number of spatial multiplexing groups for each
%   configuration.

% TODO
%  toggleModules

% find dimensions for scaling ROI for layout isn't changed with spacing
switch probe.module.shape
    case 'square'
        modwidth = probe.module.dimension;
        modheight = probe.module.dimension;
    case 'triangle'
        modwidth = probe.module.dimension;
        modheight = probe.module.dimension*sqrt(3)/2;
    case 'hexagon'
        modwidth = 2*probe.module.dimension*cosd(30); % 150,160,170,180,190
        modheight = 1.5*probe.module.dimension;
    otherwise
        modwidth = probe.module.dimension;
        modheight = probe.module.dimension;
end
probewidth = modwidth*probe.n_modules_x;
roiWidthAdj = probewidth-probe.maxroiwidth;
probeheight = modheight*probe.n_modules_y;
roiHeightAdj = probeheight-probe.maxroiheight;
           
% determine if any modules are off. Keep them off. 
offModules = find(probe.modules(:,4)==0)';

fig = figure;    

for s=1:size(spacingAmount,2)
    % clear and reset probe
    clf(fig)
    
    % vary the spacing
    probe.spacing = spacingAmount(s);
    xroi = ((modwidth+spacingAmount(s)) * (probe.n_modules_x-1)) + modwidth - roiWidthAdj;
    yroi = ((modheight+spacingAmount(s))* (probe.n_modules_y-1)) + modheight - roiHeightAdj;
    probe.roi = createROI(xroi,yroi);  
    
    % re-create the layout
    probe = createLayout(probe); 
    probe = toggleModules(probe, offModules, 'off');
    
    % Re-characterize and save the results structur
    probe = characterizeProbe(probe);
    cfgs(s).results = probe.results;
    
    % visual display
    plotProbe(probe); plotROI(probe)
    title(strcat('Spacing: ',num2str(spacingAmount(s)),'mm'))
    pause(.01)
    
end

end

