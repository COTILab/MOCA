function [probe] = translateProbe(probe, translate_amount)
%TRANSLATEPROBE Summary of this function goes here
%   Detailed explanation goes here


% if the translate amount is a vector 
if (isnumeric(translate_amount))
    % translate module geometries (translate their centroid)
    modulecentroids = probe.modules(:,1:2);
    translatedmodules = translateCoordinates(modulecentroids, translate_amount);
    probe.modules(:,1:2) = translatedmodules;

    % translate sources
    sources = probe.srcposns(:,1:2);
    translatedsources = translateCoordinates(sources, translate_amount);
    probe.srcposns(:,1:2) = translatedsources;

    % translate detectors
    detectors = probe.detposns(:,1:2);
    translateddetectors = translateCoordinates(detectors, translate_amount);
    probe.detposns(:,1:2) = translateddetectors;

elseif (ischar(translate_amount))
    % find center roi
    roi_centroid(1) = round(max(probe.roi(:,1)) + min(probe.roi(:,1))) / 2;
    roi_centroid(2) = round(max(probe.roi(:,2)) + min(probe.roi(:,2))) / 2;

    % find center of probe of active modules only
    activemoduleidx = probe.modules(:,4) == 1;  % indeces of active modules
    activemodules = probe.modules(activemoduleidx,:); % logic for sub-matrix
    probe_centroid(1) = round( ((max(activemodules(:,1))+(probe.module.dimension/2)) + ...
                                (min(activemodules(:,1))-(probe.module.dimension/2))) / 2);
    probe_centroid(2) = round( ((max(activemodules(:,2))+(probe.module.dimension/2)) + ...
                                (min(activemodules(:,2))-(probe.module.dimension/2))) / 2);

    % translate probe
    centroid_diff = roi_centroid - probe_centroid;
    probe = translateProbe(probe, centroid_diff); % recursive
end

end

