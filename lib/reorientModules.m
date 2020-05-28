function [probe] = reorientModules(probe)
%REORIENTMODULES Finds a path between digraph and orients modules to it
%   Finds a path between all modules using the digraph. It then reorients
%   all modules to align with the path. Orientation does not take into
%   account the current module's orientation. Rather, it finds the
%   orientation relative to the originally defined module.

% find the lowest and highest active module id
k = find(probe.modules(:,4));
minmodidx = min(k);
maxmodidx = max(k);

% all paths from minmodule to max module
allsimplepaths = pathBetweenNodes(probe.A, minmodidx, maxmodidx, false); % (adj, src, snk, verbose)

% extract only the longest paths
val = cellfun(@(x) numel(x),allsimplepaths);
paths = allsimplepaths(val==max(val));

% now loop through the first path, and orient the modules
path = paths{1};
for i = 1:size(path,2)
    % Find angle to Rotate
    if (i==size(path,2))
        rotate_amount = 0;
    else
        xynext = probe.modules(path(i+1), 1:2);
        xycurr = probe.modules(path(i), 1:2);
        angle_nodes = rad2deg(atan2(xynext(1,2)-xycurr(1,2),...
                                    xynext(1,1)-xycurr(1,1)) ); % from horizontal, of pair of nodes
        rotate_amount = (angle_nodes - 90); % ccw = positive
    end
    probe = rotateModules(probe, path(i), rotate_amount);
end

probe.path = path;
end

