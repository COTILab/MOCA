function [] = plotBrainSensitivity(probe, channeltype)
%PLOTBRAINSENSITIVITY Plot spatial brain sensitivity 
%   Generate a spatial plot of channels color-coded by their brain
%   sensitivity.  Can plot all channels, intra module channels, or inter
%   module channels only with the channeltype input. Channeltype can be
%   'all', 'intra', or 'inter'. If no channeltype is inputted, defaults to
%   'all'.

% determine which channels to plot.
if (nargin == 2)
    switch channeltype
        case 'all'
            bs = probe.results.brainsensitivity;
        case 'intra'
            bs = probe.results.intrabrainsensitivity;
        case 'inter'
            bs = probe.results.interbrainsensitivity;
        otherwise
    end
elseif(nargin == 1)
    bs = probe.results.brainsensitivity;
end

% determine colormap based on max and min
c = bs(:,1);
srcidx = bs(:,2);
detidx = bs(:,3);
ran=range(probe.results.brainsensitivity(:,1));   % range of data
min_val=min(probe.results.brainsensitivity(:,1)); % minimum value of data
max_val=max(probe.results.brainsensitivity(:,1)); % maximum value of data
y=floor(((c-min_val)/ran)*63)+1;    % 2^6, scale for 6 bit colors
col=zeros(length(c),3);     % an rgb value for each channel
p=colormap;

% Begin plotting
hold on

for i=1:length(c)
    a=y(i);
    col(i,:)=p(a,:);
    plot([probe.srcposns(srcidx(i),1), probe.detposns(detidx(i),1)],...
            [probe.srcposns(srcidx(i),2), probe.detposns(detidx(i),2)],...
            'Color',col(i,:),...
            'LineWidth',2);
    axis equal;
    h = colorbar;
    ylabel(h, 'Brain Sensitivity [%]');
    caxis([min_val max_val]);
end



end

