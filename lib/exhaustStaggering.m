function [cfgs] = exhaustStaggering(probe, modulesToStagger, staggerAmount)
%EXHAUSTSTAGGERING Exhaustively analyze staggering a probe
%   Given a probe and a staggering vector, this script will shift selected
%   modules by the staggering amount and re-analyze the probe. This is done
%   for every shift inside staggerAmount. The number of channel, average
%   brain sensitivity, and number of spatial multiplexing groups for each
%   configuration is outputted. modulesToStagger and staggerAmount should
%   each be row vectors

fig = figure

for c=1:size(staggerAmount,2)
    offset = staggerAmount(c);
    
    % reset layout
    clf(fig)
    probe = createLayout(probe); 
    
    % vary the staggering
    probe = translateModules(probe, modulesToStagger, [offset 0]);
    
    % Re-characterize and save the results structure
    probe = characterizeProbe(probe);
    cfgs(c).results = probe.results;
    
    % visual display
    plotProbe(probe); 
    title(strcat('Staggering: ',num2str(offset),'mm'))
    pause(.01)
    
end



end

