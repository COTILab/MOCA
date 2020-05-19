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

% Plot the optodes if both sources and detectors exist
if ( isfield(design.module, 'srcposns') && isfield(design.module, 'detposns'))
    plot(design.module.srcposns(:,1), design.module.srcposns(:,2), 'ro', 'MarkerSize',10);
    plot(design.module.detposns(:,1), design.module.detposns(:,2), 'bx', 'MarkerSize',10);
    legend('Geometry','Source','Detector');
    
% Plot the sources if only sources exist
elseif (isfield(design.module, 'srcposns'))
    plot(design.module.srcposns(:,1), design.module.srcposns(:,2), 'ro', 'MarkerSize',10);
    legend('Geometry','Source');
    
% Plot the detectors if only detectors exist
elseif (isfield(design.module, 'detposns'))
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

