function [] = plotProbe(probe)
%PLOTPROBE Summary of this function goes here
%   Detailed explanation goes here

% find only the active modules
%activeModuleIdx = probe.modules(:,4) == 1;  % indeces of active modules
%activeModules = probe.modules(activeModuleIdx,:); % logic for sub-matrix

hold on;

modules = probe.modules;

for i = 1:size(modules,1)
    % plot the centroids of each module in the probe
    plot(modules(i,1), modules(i,2), 'g*');

    % plot the module index number
    text(modules(i,1), modules(i,2), num2str(i));
    
    if (modules(i,4) == 1)  % If the module is active
        % plot the shape over each centroid
        peri = translateCoordinates(probe.module.perimeter, modules(i,1:2));
        % peri = orientShape();
        peri_x = [peri(:,1); peri(1,1)];
        peri_y = [peri(:,2); peri(1,2)];
        plot(peri_x, peri_y, 'k-', 'LineWidth', 3);
        
        % Find sources on this module and plot them
        actmodsrcsidx = probe.srcposns(:,3) == i;   % idx of srcs on this module
        actmodsrcs = probe.srcposns(actmodsrcsidx,:);   % srcs on this module
        plot(actmodsrcs(:,1), actmodsrcs(:,2), 'ro', 'MarkerSize', 10);
        
        % Find detectors on this module and plot them
        actmoddetsidx = probe.detposns(:,3) == i;   % idx of dets on this module
        actmoddets = probe.detposns(actmoddetsidx,:);   % dets on this module
        plot(actmoddets(:,1), actmoddets(:,2), 'bx', 'MarkerSize', 10);
        
    end
    
end

axis equal

end

