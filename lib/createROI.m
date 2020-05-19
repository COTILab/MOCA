function [ROI] = createROI(roi_width, roi_height)
%CREATEROI Generates a Nx2 matrix of perimeter points of the ROI
%   ROI is a structure. Bottom left corner of ROI is 0,0.

ROI = [ 0,          0;...
        roi_width,  0;...
        roi_width,  roi_height;...
        0,          roi_height];

end

