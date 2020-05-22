function [] = plotBrainSensitivity(probe)
%PLOTBRAINSENSITIVITY Summary of this function goes here
%   Detailed explanation goes here

c = probe.results.brainsensitivity(:,1);    % data to be plotted
srcidx = probe.results.brainsensitivity(:,2);
detidx = probe.results.brainsensitivity(:,3);
ran=range(c);   % range of data
min_val=min(c); % minimum value of data
max_val=max(c); % maximum value of data
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

