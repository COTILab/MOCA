function [] = plotSpatialMultiplexingGroups(probe, groups)
%PLOTSPATIALMULTIPLEXINGGROUPS Summary of this function goes here
%   Detailed explanation goes here

% 13 different colors
colors = {'r','g','b','c','m','y',[0 0.4470 0.7410],'#D95319','#EDB120',...
            '#7E2F8E','#77AC30','#4DBEEE','#A2142F'}; 

% [x y groupid srcid]
hold on

% First, plot all the optodes
plot(probe.srcposns(:,1), probe.srcposns(:,2), 'ro', 'MarkerSize', 10);
plot(probe.detposns(:,1), probe.detposns(:,2), 'bx', 'MarkerSize', 10);

% for every group, plot a sphere of influence over each source
for g=1:size(groups,2)
    srcs_in_this_group_idx = probe.results.groupings(:,3) == groups(g);
    srcs_in_this_group = probe.results.groupings(srcs_in_this_group_idx, 1:2);
    
    % viscircles( coors, radii )
    if(g<=13)
        h(g) = viscircles(srcs_in_this_group(:,1:2), ...
                ones(size(srcs_in_this_group,1),1)*probe.sdrange(2), ...
                'LineStyle', '--',...
                'Color', colors{g});
    elseif(g<=26 && g>13)
        h(g) = viscircles(srcs_in_this_group(:,1:2), ...
                ones(size(srcs_in_this_group,1),1)*probe.sdrange(2), ...
                'LineStyle', ':',...
                'Color', colors{g-13});
    end
    
    LegendLabel{g}= strcat('group ', num2str(groups(g)) );
end

legend(h(1:g), LegendLabel);

axis equal

end

