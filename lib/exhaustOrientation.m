function [cfgs] = exhaustOrientation(probe)
%EXHAUSTORIENTATION Exhaustively analyze all possible module orientations
%   Takes in a probe and exhaustively changes each module orientation. Does
%   this for all possible combinations of modules. The number of possible
%   configurations is A^B, where A is the number of orientations (or sides)
%   or a module, and B is the number of modules. For example, a 2x3 probe
%   of squares has 4^6=4096 unique possible ways in which to orient each of
%   the modules. This script displays the probe and the re-oriented modules
%   to the user. It saves the number of channels, average brain
%   sensitivity, and the number of spatial multiplexing groups for each
%   configuration. Yeah, it's exhaustive. 


% setup based on module shape and quantity
switch probe.module.shape
    case 'square'
        nOrientations = 4;
    case 'triangle'
        nOrientations = 3;
    case 'hexagon'
        nOrientations = 6;
    otherwise
        nOrientations = size(probe.module.perimeter,1);
end
degrees = 360/nOrientations;
orientations = [degrees:degrees:360] - degrees;
nModules = probe.results.modulecount;
nConfigurations = nOrientations^nModules;


% create an array of orientations
for v=1:nModules
    vectors{v} = orientations;
end
nVectors = numel(vectors);          % number of vectors
combinations = cell(1,nVectors);           % pre-define to generate comma-separated list
[combinations{end:-1:1}] = ndgrid(vectors{end:-1:1}); % the reverse order in these two
% comma-separated lists is needed to produce the rows of the result matrix 
combinations = cat(nVectors+1, combinations{:});  % concat the n n-dim arrays along dimension n+1
combinations = reshape(combinations,[],nVectors); % reshape to obtain desired matrix


% Run through all combinations
fig = figure;    
giftitle = 'images/exhaustOrientation.gif';
    
for c=1:size(combinations,1) %permutations
    % clear and reset probe
    clf(fig)
    probe = createLayout(probe); % reset back to basic
    
    % change orientation of modules based on combination
    for m=1:nModules
        probe = rotateModules(probe, [m], combinations(c,m));
    end
    
    % Re-characterize and save the results structur
    probe = characterizeProbe(probe);
    cfgs(c).results = probe.results;
    
    
    % visual display
    plotProbe(probe); plotROI(probe)
    title(strcat('Config: ',num2str(c),'/',num2str(nConfigurations)))
    pause(.01)
    
%     % save gif
%     frame = getframe(gcf);
%     img =  frame2im(frame);
%     [img,cmap] = rgb2ind(img,256);
%     if c == 1
%         imwrite(img,cmap,giftitle,'gif','LoopCount',Inf,'DelayTime',.01);
%     else
%         imwrite(img,cmap,giftitle,'gif','WriteMode','append','DelayTime',.01);
%     end
end



end

