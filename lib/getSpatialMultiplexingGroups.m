function [probe] = getSpatialMultiplexingGroups(probe)
%GETSPATIALMULTIPLEXINGGROUPS Assign active sources to spatial groups
%   Results in a Nx5 matrix, where N is number of active sources and the 
%   five columns refer to 
%   [sourceX, sourceY, moduleID, sourceID, SpatialMultiplexingGroupID].
%   Each source within a group is at least 2*sdrange(2) away from all other
%   sources in the group. 


activemoduleidx = probe.modules(:,4) == 1;  % indeces of active modules
activemodules = probe.modules(activemoduleidx,:); % logic for sub-matrix

assigned_srcs = probe.srcposns;  % [x y modid srcid]
for m=1:size(probe.modules(:,4),1)
    if (probe.modules(m,4)==0) % if probe is inactive
        inactivesrcidx = assigned_srcs(:,3) ~= m;
        assigned_srcs = assigned_srcs(inactivesrcidx,:);
    end
end

assigned_srcs(:,5) = zeros(size(assigned_srcs,1), 1); % [x y modid srcid groupid]

groupn = 1;
group_flag = 0;  % =1 when all srcs have been given a group

while (group_flag == 0)
    group_assignments = assigned_srcs(:,5);
    fsog = find(group_assignments==0, 1, 'first');  % idx of first source in current group
    assigned_srcs(fsog,5) = groupn; % assign a group to this source
    
    for srcn = fsog:size(assigned_srcs,1)
        % idx of all srcs in this current group
        srcs_in_this_group_idx = assigned_srcs(:,5) == groupn; 
        srcs_in_this_group = assigned_srcs(srcs_in_this_group_idx, :); % [x y groupid srcid]
        all_srcs = assigned_srcs(:,1:2);    % coordinatess of all sources in the probe
        
        % get distance between the next candidate source and all currently assigned sources in this group
        distances = sqrt(...    
            (srcs_in_this_group(:,1) - all_srcs(srcn,1)).^2 + ...
            (srcs_in_this_group(:,2) - all_srcs(srcn,2)) .^ 2);
        % If the candidate src is far away enough AND isn't current
        % assigned a group, assign it to this group
        if (min(distances)>2*probe.sdrange(2) && assigned_srcs(srcn,5)==0)
            assigned_srcs(srcn,5) = groupn;
        end
    end
    
    % update flag
    % get group_assignment with no repetitions
    groups = unique(group_assignments); % typically gives [0 1 2 3...]
    % if all srcs are assigned, groups will be [1 2 3...] 
    group_flag = groups(1); % if the first value is not zero, then we gucci
    
    groupn = groupn + 1;
    
end

probe.results.groups = assigned_srcs; % [x y modid srcid groupid]
probe.results.ngroups = size(unique(probe.results.groupings(:,5)), 1);


end

