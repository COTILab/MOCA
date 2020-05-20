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
        peri = translateShape(probe.module.perimeter, modules(i,1:2));
        % peri = orientShape();
        peri_x = [peri(:,1); peri(1,1)];
        peri_y = [peri(:,2); peri(1,2)];
        plot(peri_x, peri_y, 'k-', 'LineWidth', 3);
    end
    
end

axis equal

end

