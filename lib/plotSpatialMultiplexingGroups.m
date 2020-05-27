function [] = plotSpatialMultiplexingGroups(probe, groups)
%PLOTSPATIALMULTIPLEXINGGROUPS Spatially plot spatial multiplexing groups
%   Plots circles of radius sdrange(2) over sources of a particular group.
%   groups can be either a single integer specifying the group number, or a
%   vector of group numbers. When multiple groups are plotted, each group
%   is plotted in a different color.

% 13 different colors
colors = {'r','g','b','c','m','y',[0 0.4470 0.7410],...
    [0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],...
    [0.4940 0.1840 0.5560],[0.4660 0.6740 0.1880],...
    [0.3010 0.7450 0.9330],[0.6350 0.0780 0.1840]}; 

hold on

% for every group, plot a sphere of influence over each source
for g=1:size(groups,2)
    srcs_in_this_group_idx = probe.results.groupings(:,5) == groups(g);
    srcs_in_this_group = probe.results.groupings(srcs_in_this_group_idx, 1:2);

    % viscircles( coors, radii )
    if(g<=13)
        plot(srcs_in_this_group(:,1), srcs_in_this_group(:,2),...
                'ro', 'MarkerSize', 10,...
                'MarkerFaceColor',colors{g});
        h(g) = viscircles(srcs_in_this_group(:,1:2), ...
                ones(size(srcs_in_this_group,1),1)*probe.sdrange(2), ...
                'LineStyle', '--',...
                'Color', colors{g});
    elseif(g<=26 && g>13)
        plot(srcs_in_this_group(:,1), srcs_in_this_group(:,2),...
                'ro', 'MarkerSize', 10,...
                'MarkerFaceColor',colors{g-13});    % 13 diff colors
        h(g) = viscircles(srcs_in_this_group(:,1:2), ...
                ones(size(srcs_in_this_group,1),1)*probe.sdrange(2), ...
                'LineStyle', ':',...
                'Color', colors{g-13}); % 13 diff colors
    end

    LegendLabel{g}= strcat('group ', num2str(groups(g)) );
end

legend(h(1:g), LegendLabel);
axis equal

end

