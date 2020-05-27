function [probe] = getAdjMatrix(probe, add_module)
%GETADJMATRIX Calculate the module/node pairs of directional graph
%   Detailed explanation goes here


s=0;
t=0;

if (strcmp(probe.module.shape, 'square') || (isfield(probe.module, 'shape')==false))
    for row=1:probe.n_modules_y     % all rows
        nodes = ((row-1)*probe.n_modules_x)+1:1:row*probe.n_modules_x; % All nodes in a single row 
        
        % within a row of nodes
        s = [s,nodes(1)];   t = [t,nodes(1)+1];     % first node
        s = [s,nodes(end)]; t = [t,nodes(end)-1];   % last node
        for n=nodes(2):nodes(end-1)                 % all nodes in between one row
            s = [s,n]; t = [t,n-1];
            s = [s,n]; t = [t,n+1];
        end
        
        % between two rows
        for n=nodes(1):nodes(end)
            if(row==1)                          % if first row
                s = [s,n]; t = [t,n+probe.n_modules_x];
            elseif (row == probe.n_modules_y)  % if last row
                s = [s,n]; t = [t,n-probe.n_modules_x];
            else                                % any row in between
                s = [s,n]; t = [t,n+probe.n_modules_x];
                s = [s,n]; t = [t,n-probe.n_modules_x];
            end
        end
    end
    s = s(2:end);
    t = t(2:end);
end


% Remove any inactive modules
nodepairs = [s',t'];    % two column s,t
for m = 1:size(probe.modules(:,4), 2)
    if (probe.modules(m,4)==0)  % module is inactive
        sidx = nodepairs(:,1)==m;
        tidx = nodepairs(:,2)==m;
        inactivemodidx = or(idx1,idx2);
        activemodidx = not(inactivemodidx);
        nodepairs = nodepairs(activemodidx,:);
    end
end



probe.nodepairs = nodepairs;
probe.G = digraph(nodepairs(:,1), nodepairs(:,2));
probe.A = adjacency(probe.G);

end

