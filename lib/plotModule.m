function [] = plotModule(probe)
%PLOTMODULE Plot the module in a figure
%   Plots the perimeter of the defined module. If no optodes are defined,
%   only the perimeter is plotted, else, the optodes are also plotted. 

module = probe.module;
hold on

% Plot the perimeter
first_xycoor = module.perimeter(1,:);    % Add the first xy coordinate to the matrix 
perimeter_coors = [module.perimeter; first_xycoor]; 
plot(perimeter_coors(:,1), perimeter_coors(:,2), 'k','LineWidth',2); 
axis equal


% Check if optodes (sources and detectors exist). Create flags.
if (isfield(module, 'srcposns'))
    srcsExist = true;
else
    srcsExist = false;
end
if (isfield(module, 'detposns'))
    detsExist = true;
else
    detsExist = false;
end


% Check that all optodes are inside the perimeter of the module 
if ( srcsExist )
    srcsINboolean = inpolygon(module.srcposns(:,1),...
            module.srcposns(:,2),...
            module.perimeter(:,1),...
            module.perimeter(:,2) );
    if( unique(srcsINboolean)==1 )
        srcsAreInPerimeter = true;
    else
        srcsAreInPerimeter = false;
        disp('Some sources may be outside the module perimeter');
    end
end
if ( detsExist )
    detsINboolean = inpolygon(module.detposns(:,1),...
            module.detposns(:,2),...
            module.perimeter(:,1),...
            module.perimeter(:,2) );
    if( unique(detsINboolean)==1 )
        detsAreInPerimeter = true;
    else
        detsAreInPerimeter = false;
        disp('Some detectors may be outside the module perimeter');
    end
end
    

% Plot the optodes if both sources and detectors exist AND are in range
if(srcsExist && detsExist)
    plot(module.srcposns(:,1), module.srcposns(:,2), 'ro', 'MarkerSize',10);
    plot(module.detposns(:,1), module.detposns(:,2), 'bx', 'MarkerSize',10);
    legend('Geometry','Source','Detector');
    title('Module Geometry and Optodes')
% Plot the sources if only sources exist
elseif (srcsExist)
    plot(module.srcposns(:,1), module.srcposns(:,2), 'ro', 'MarkerSize',10);
    legend('Geometry','Source');
    title('Module Geometry and Sources')
% Plot the detectors if only detectors exist
elseif (detsExist)
    plot(module.detposns(:,1), module.detposns(:,2), 'bx', 'MarkerSize',10);
    legend('Geometry','Detector');
    title('Module Geometry and Detectors')
% Plot just the geometry if optodes were not defined
else
    legend('Geometry')
    title('Module Geometry')
end


% Labels
xlabel('Position [mm]')
ylabel('Position [mm]')
axis equal

end

