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

% plot the perimeter. 
plot(perimeter_coors(:,1), perimeter_coors(:,2), 'k','LineWidth',2); 
axis equal

% plot the optodes
% if (plot_optodes_bool)
%     plot(srcs(:,1), srcs(:,2), 'ro', 'MarkerSize',10);
%     plot(dets(:,1), dets(:,2), 'bx', 'MarkerSize',10);
%     legend('Shape','Source','Detector','Location','NorthWest'); %,'Outline')
% else
%     legend(['Dimension=' num2str(module.dimension)], 'Location', 'NorthWest');
% end

% title
title('Design of Module')
xlabel('Position [mm]')
ylabel('Position [mm]')
axis equal

end

