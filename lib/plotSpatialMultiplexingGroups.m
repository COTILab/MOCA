function [] = plotSpatialMultiplexingGroups(probe, groups)
%PLOTSPATIALMULTIPLEXINGGROUPS Summary of this function goes here
%   Detailed explanation goes here

% 13 different colors
colors = {'r','g','b','c','m','y',[0 0.4470 0.7410],...
    [0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],...
    [0.4940 0.1840 0.5560],[0.4660 0.6740 0.1880],...
    [0.3010 0.7450 0.9330],[0.6350 0.0780 0.1840]}; 

% [x y groupid srcid]
hold on


if(isnumeric(groups))
    % First, plot all the optodes
    %plot(probe.srcposns(:,1), probe.srcposns(:,2), 'ro', 'MarkerSize', 10);
    %plot(probe.detposns(:,1), probe.detposns(:,2), 'bx', 'MarkerSize', 10);

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
    

% Plot a gif of all groups
elseif(ischar(groups))
%     if(strcmp(groups, 'all'))
%         ngroups = size(unique(probe.results.groupings(:,3)), 1);
%         
%         % for every group, plot a sphere of influence over each source
%         for g=1:ngroups
%             
%             % First, plot all the optodes
%             plot(probe.srcposns(:,1), probe.srcposns(:,2), 'ro', 'MarkerSize', 10);
%             hold on
%             plot(probe.detposns(:,1), probe.detposns(:,2), 'bx', 'MarkerSize', 10);
% 
%             srcs_in_this_group_idx = probe.results.groupings(:,3) == g;
%             srcs_in_this_group = probe.results.groupings(srcs_in_this_group_idx, 1:2);
% 
%             % viscircles( coors, radii )
%             viscircles(srcs_in_this_group(:,1:2), ...
%                     ones(size(srcs_in_this_group,1),1)*probe.sdrange(2), ...
%                     'LineStyle', '--',...
%                     'Color', colors{1});
%                 
%             title(strcat('Group: ',num2str(g),'/',num2str(ngroups)))
%             axis equal
%             pause(1);
%             hold off
%         end
%     end
end


axis equal

end

