function [] = plotProbe(design, probe)
%PLOTPROBE Summary of this function goes here
%   Detailed explanation goes here

figure
hold on;

for i = 1:size(probe.centroids,1)
    % plot the centroids of each module in the probe
    plot(probe.centroids(i,1), probe.centroids(i,2), 'g*');
    
    % plot the module index number
    text(probe.centroids(i,1), probe.centroids(i,2), num2str(i));
    
    % plot the shape over each centroid
    peri = translateShape(design.module.perimeter, probe.centroids(i,1:2));
    peri_x = [peri(:,1); peri(1,1)];
    peri_y = [peri(:,2); peri(1,2)];
    plot(peri_x, peri_y, 'k-', 'LineWidth', 3);
    
end

axis equal

end

