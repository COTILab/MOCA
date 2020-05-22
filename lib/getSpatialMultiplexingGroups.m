function [probe] = getSpatialMultiplexingGroups(probe)
%GETSPATIALMULTIPLEXINGGROUPS Summary of this function goes here
%   Results in a Nx4 matrix, where N is number of sources and the four 
%   columns refer to [x y groupid srcid].


assigned_srcs = probe.srcposns;  % [x y groupid srcid]
assigned_srcs(:,3) = zeros(size(probe.srcposns,1), 1);

groupn = 1;
group_flag = 0;  % =1 when all srcs have been given a group

while (group_flag == 0)
    group_assignments = assigned_srcs(:,3);
    fsog = find(group_assignments==0, 1, 'first');  % idx of first source in current group
    assigned_srcs(fsog,3) = groupn; % assign a group to this source
    
    for srcn = fsog:size(assigned_srcs,1)
        % idx of all srcs in this current group
        srcs_in_this_group_idx = assigned_srcs(:,3) == groupn; 
        srcs_in_this_group = assigned_srcs(srcs_in_this_group_idx, :); % [x y groupid srcid]
        all_srcs = assigned_srcs(:,1:2);    % coordinatess of all sources in the probe
        
        % get distance between the next candidate source and all currently assigned sources in this group
        distances = sqrt(...    
            (srcs_in_this_group(:,1) - all_srcs(srcn,1)).^2 + ...
            (srcs_in_this_group(:,2) - all_srcs(srcn,2)) .^ 2);
        % If the candidate src is far away enough AND isn't current
        % assigned a group, assign it to this group
        if (min(distances)>2*probe.sdrange(2) && assigned_srcs(srcn,3)==0)
            assigned_srcs(srcn,3) = groupn;
        end
    end
    
    % update flag
    % get group_assignment with no repetitions
    groups = unique(group_assignments); % typically gives [0 1 2 3...]
    % if all srcs are assigned, groups will be [1 2 3...] 
    group_flag = groups(1); % if the first value is not zero, then we gucci
    
    groupn = groupn + 1;
    
end

probe.results.groupings = assigned_srcs; % [x y groupid srcid]


end

