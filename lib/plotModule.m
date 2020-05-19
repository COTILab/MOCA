function [] = plotModule(design)
%PLOTMODULE Plot the module in a figure
%   Plots the perimeter of the defined module. If no optodes are defined,
%   only the perimeter is plotted, else, the optodes are also plotted. 

figure
hold on

% Plot the perimeter
first_xycoor = design.module.perimeter(1,:);    % Add the first xy coordinate to the matrix 
perimeter_coors = [design.module.perimeter; first_xycoor]; 
plot(perimeter_coors(:,1), perimeter_coors(:,2), 'k','LineWidth',2); 
axis equal


% Check if optodes (sources and detectors exist). Create flags.
if (isfield(design.module, 'srcposns'))
    srcsExist = true;
else
    srcsExist = false;
end
if (isfield(design.module, 'detposns'))
    detsExist = true;
else
    detsExist = false;
end


% Check that all optodes are inside the perimeter of the module 
if ( srcsExist )
    srcsINboolean = inpolygon(design.module.srcposns(:,1),...
            design.module.srcposns(:,2),...
            design.module.perimeter(:,1),...
            design.module.perimeter(:,2) );
    if( unique(srcsINboolean)==1 )
        srcsAreInPerimeter = true;
    else
        srcsAreInPerimeter = false;
        disp('Some sources may be outside the module perimeter');
    end
end
if ( detsExist )
    detsINboolean = inpolygon(design.module.detposns(:,1),...
            design.module.detposns(:,2),...
            design.module.perimeter(:,1),...
            design.module.perimeter(:,2) );
    if( unique(detsINboolean)==1 )
        detsAreInPerimeter = true;
    else
        detsAreInPerimeter = false;
        disp('Some detectors may be outside the module perimeter');
    end
end
    

% Plot the optodes if both sources and detectors exist AND are in range
if(srcsExist && detsExist)
    plot(design.module.srcposns(:,1), design.module.srcposns(:,2), 'ro', 'MarkerSize',10);
    plot(design.module.detposns(:,1), design.module.detposns(:,2), 'bx', 'MarkerSize',10);
    legend('Geometry','Source','Detector');
% Plot the sources if only sources exist
elseif (srcsExist)
    plot(design.module.srcposns(:,1), design.module.srcposns(:,2), 'ro', 'MarkerSize',10);
    legend('Geometry','Source');
% Plot the detectors if only detectors exist
elseif (detsExist)
    plot(design.module.detposns(:,1), design.module.detposns(:,2), 'bx', 'MarkerSize',10);
    legend('Geometry','Detector');
% Plot just the geometry if optodes were not defined
else
    legend('Geometry')
end


% Title the plot
title('Design of Module')
xlabel('Position [mm]')
ylabel('Position [mm]')
axis equal

end

