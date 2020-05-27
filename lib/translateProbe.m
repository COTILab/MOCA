function [probe] = translateProbe(probe, translate_amount)
%TRANSLATEPROBE Translate probe relative to ROI
%   Translates the entire probe (assembly of modules) relative to ROI to
%   ensure proper coverage. Translate_amount is defined as [deltax, deltay]
%   where deltas can be negative or positive. Additionally, if
%   translate_amount is set to 'center', then this function calculates the
%   centroid of the ROI and the centroid of the probe to overlay.

optexist = true;    % flag to determine if optodes were defined. 
if( isfield(probe.module, 'srcposns') == false )
    optexist = false;
end


% if the translate amount is a vector 
if (isnumeric(translate_amount))
    % translate module geometries (translate their centroid)
    modulecentroids = probe.modules(:,1:2);
    translatedmodules = translateCoordinates(modulecentroids, translate_amount);
    probe.modules(:,1:2) = translatedmodules;

    % translate optodes if they exist
    if (optexist)
        % translate sources
        sources = probe.srcposns(:,1:2);
        translatedsources = translateCoordinates(sources, translate_amount);
        probe.srcposns(:,1:2) = translatedsources;

        % translate detectors
        detectors = probe.detposns(:,1:2);
        translateddetectors = translateCoordinates(detectors, translate_amount);
        probe.detposns(:,1:2) = translateddetectors;
    end

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

