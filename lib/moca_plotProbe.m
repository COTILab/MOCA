function [] = moca_plotProbe(probe, experiment)
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

if (nargin==1)
    for i = 1:size(modules,1)
        % plot the centroids of each module in the probe
        %plot(modules(i,1), modules(i,2), 'g*');

        % plot the module index number
        %text(modules(i,1), modules(i,2), num2str(i));

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
                plot(actmodsrcs(:,1), actmodsrcs(:,2), 'r.', 'MarkerSize', 30, 'LineWidth', 4);

                % Find detectors on this module and plot them
                actmoddetsidx = probe.detposns(:,3) == i;   % idx of dets on this module
                actmoddets = probe.detposns(actmoddetsidx,:);   % dets on this module
                plot(actmoddets(:,1), actmoddets(:,2), 'bx', 'MarkerSize', 10, 'LineWidth', 4);
            end

        end

    end
    
    axis equal
    
% two input arguments. details for plotting in MOBI visualization
else
    
    %if we want the module outlines
    if(strcmp(experiment, 'outline'))
        for i = 1:size(modules,1)
            if (modules(i,4) == 1)  % If the module is active
                % plot the shape/perimeter over each centroid
                modulexy = modules(i, 1:2); % current xy of centroid
                moduleangle = modules(i, 3); % current angle
                % rotate the module
                rperimeter = rotateCoordinates(probe.module.perimeter, moduleangle);
                trperimeter = translateCoordinates(rperimeter, modulexy); % rotated AND translated perimeter
                peri_x = [trperimeter(:,1); trperimeter(1,1)];
                peri_y = [trperimeter(:,2); trperimeter(1,2)];
                fill(peri_x,peri_y,[0.95 0.95 0.95])
                %plot(peri_x, peri_y, 'k--', 'LineWidth', 1, 'Color',[.75 .75 .75]);
            end
        end
    
    % if we want sources plotted
    elseif(strcmp(experiment, 'srcs'))
        for i = 1:size(modules,1)
            if (modules(i,4) == 1)  % If the module is active
                % Find sources on this module and plot them
                actmodsrcsidx = probe.srcposns(:,3) == i;   % idx of srcs on this module
                actmodsrcs = probe.srcposns(actmodsrcsidx,:);   % srcs on this module
                plot(actmodsrcs(:,1), actmodsrcs(:,2), 'ro', 'MarkerSize', 5);
            end
        end
    
    % if we want global source numbers plotted
    elseif(strcmp(experiment, 'srcnumbers'))
        for i = 1:size(modules,1)
            if (modules(i,4) == 1)  % If the module is active
                % Find sources on this module and plot them
                actmodsrcsidx = probe.srcposns(:,3) == i;   % idx of srcs on this module
                actmodsrcs = probe.srcposns(actmodsrcsidx,:);   % srcs on this module
                text(actmodsrcs(:,1), actmodsrcs(:,2), num2str(actmodsrcs(:,4))); % x,y,modID,globalSrcID
            end
        end
    
    % If we want detectors plotted
    elseif(strcmp(experiment, 'dets'))
        for i = 1:size(modules,1)
            if (modules(i,4) == 1)  % If the module is active                
                % Find detectors on this module and plot them
                actmoddetsidx = probe.detposns(:,3) == i;   % idx of dets on this module
                actmoddets = probe.detposns(actmoddetsidx,:);   % dets on this module
                plot(actmoddets(:,1), actmoddets(:,2), 'bx', 'MarkerSize', 5);
            end
        end
    
    % if we want global detector numbers plotted
    elseif(strcmp(experiment, 'detnumbers'))
        for i = 1:size(modules,1)
            if (modules(i,4) == 1)  % If the module is active
                % Find detectors on this module and plot them
                actmoddetsidx = probe.detposns(:,3) == i;   % idx of dets on this module
                actmoddets = probe.detposns(actmoddetsidx,:);   % dets on this module
                text(actmoddets(:,1), actmoddets(:,2), num2str(actmoddets(:,4)));
            end
        end
        
    %
    end

end


end

