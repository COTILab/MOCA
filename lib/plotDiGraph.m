function [] = plotDiGraph(probe)
%PLOTDIGRAPH Plots arrows between neighboring modules
%   Detailed explanation goes here

% display the directional graph. If a node is not connected, only a dot
% will be displayed over the module's centroid.
h = plot(probe.G,...
            'XData',probe.modules(:,1),... 
            'YData',probe.modules(:,2),...
            'edgecolor', [.7 .7 .7],... 
            'nodecolor', [.7 .7 .7],...
            'NodeLabel',{});    % plots the directional graph (ie neighboring nodes)

% Highlight a specific path.
if (isfield(probe, 'path'))
    h.NodeLabel = {};
    highlight(h, probe.path, 'edgecolor', [0 .5 0], 'nodecolor', [0 .5 0]); 
    %highlight(h, probe.path(1), 'nodecolor', 'b');
    %highlight(h, probe.path(end), 'nodecolor', 'r');
    highlight(h,[probe.path(1) probe.path(end)])
end
    
end

