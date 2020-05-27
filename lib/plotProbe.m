function [] = plotProbe(probe)
%PLOTPROBE Summary of this function goes here
%   Detailed explanation goes here

optexist = true;    % flag to determine if optodes were defined. 
if( isfield(probe.module, 'srcposns') == false )
    optexist = false;
end

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
        % plot the shape/perimeter over each centroid
        modulexy = modules(i, 1:2); % current xy of centroid
        moduleangle = modules(i, 3); % current angle
        
        % rotate the module
        rperimeter = rotateCoordinates(probe.module.perimeter, moduleangle);
        trperimeter = translateCoordinates(rperimeter, modulexy); % rotated AND translated perimeter
                
        peri_x = [trperimeter(:,1); trperimeter(1,1)];
        peri_y = [trperimeter(:,2); trperimeter(1,2)];
        plot(peri_x, peri_y, 'k-', 'LineWidth', 3);
        
        % if the optodes were defined, plot them as well
        if (optexist)
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
    
end

axis equal

end

