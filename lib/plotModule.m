function [] = plotModule(design, flag)
%PLOTMODULE Plot the module in a figure
%   Plots the perimeter of the defined module. If no optodes are defined,
%   only the perimeter is plotted, else, the optodes are also plotted. If
%   the flag 'nooptodes' is included, only the perimeter is plotted.

% plot_optodes_bool = 1; 
% 
% if (nargin==1)
%     srcs = module.srcs;
%     dets = module.dets;
%     perimeter = module.perimeter;
% else
%     srcs = all_srcs;
%     dets = all_dets;
%     perimeter = all_peri;
% end

hold on

% Add the first xy coordinate to the matrix
first_xycoor = design.module.perimeter(1,:);  
perimeter_coors = [design.module.perimeter; first_xycoor];

% Plot the perimeter. 
plot(perimeter_coors(:,1), perimeter_coors(:,2), 'k','LineWidth',2); 
axis equal

% Plot the optodes if they exist
if (isfield(design, 'layout'))
    plot(design.layout.srcposns(:,1), design.layout.srcposns(:,2), 'ro', 'MarkerSize',10);
    plot(design.layout.detposns(:,1), design.layout.detposns(:,2), 'bx', 'MarkerSize',10);
    legend('Geometry','Source','Detector');
else
    legend('Geometry');
end

% title
title('Design of Module')
xlabel('Position [mm]')
ylabel('Position [mm]')
axis equal

end

