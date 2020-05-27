function [] = moca()
%              MOCA - Modular Optode Configuration Analyzer
%             Morris Vanegas <vanegas.m at northeastern.edu>
%                 URL: https://github.com/cotilab/moca
% 
% Format:
%     probe=characterizeProbe(probe);
%     
% Workflow:
%     https://github.com/COTILab/MOCA/blob/master/images/flowchart.png
% 
% Structure:
%     probe: a struct. Each element of probe defines the design parameters in
%             the workflow above. At least the first two design parameters 
%             (probe.module and probe.roi) must be defined. Results from the 
%             characterization are saved under probe.results
%             
%     probe may contain the following fields
%     
% Inputs:    
%     **probe.module:     A struct with sub-fields:
%             probe.module.perimeter: a Px2 double matrix specifying the X,Y 
%                         coordinates of the perimeter of the module shape in mm.
%                         Modules should be centered at 0,0
%             probe.module.shape:     (optional) a string specifying the 
%                         module shape. Can be 'square', 'triangle', or 'hexagon'
%             probe.module.dimension: (optional) integer specifying the 
%                         length of one side of a regular polygon in mm.
%             NOTE: optional subfields are only necessary when using the 
%                         automated moca function createModule().
%     **probe.roi:        a Px2 double matrix specifying the X,Y coordinates of 
%                         the perimeter of the region of interest in mm.
%      *probe.module.srcposns:a Nx2 double matrix specifying the X,Y
%                         coordinates of each source within a single module in mm
%      *probe.module.detposns:a Nx2 double matrix specifying the X,Y
%                         coordinates of each detector within a single module in mm
%      *probe.sdrange:    an array specifying the minimum and maximum SD
%                         separation in mm. Defined as [minSD, maxSD]. minSD is used to 
%                         define short-separation channels.
%       probe.spacing:    an integer value specifying the spacing between
%                         modules when tessellated over a ROI in mm. Spacing 
%                         is done in both X and Y axes. If not defined, 
%                         defaults to 0.
%       
%       fields with ** are required; fields with * are required to reveal 
%       more probe characterizations (see workflow). 
%       
% Assembly Fields:
%     The following fields are derived from createLayout(). These fields 
%     emerge when an elementary module is tessellated over a ROI
%     
%     probe.maxroiwidth:  An integer specifying the maximum width (x axis) 
%                         of the ROI in mm
%     probe.maxroiheight: An integer specifying the maximum height (y axis) 
%                         of the ROI in mm
%     probe.n_modules_x:  The number of modules in the x axis if the ROI were
%                         a rectangular area
%     probe.n_modules_y:  The number of modules in the y axis if the ROI were
%                         a rectangular area
%     probe.modules:      A Mx2 matrix defining each module's X,Y centroid (in mm), 
%                         its orientation angle (in deg), and its active 
%                         state (0 or 1). Each row is [centroidX, centroidY,
%                         orientationAngle, activeState]. M is the number of 
%                         modules in the probe.
%     probe.srcposns:     A Sx2 matrix defining the coordinates of a source (in mm), 
%                         the module id it is on, and the source id value. S
%                         is the number of total sources (number of sources 
%                         within a module * number of modules). Each row
%                         is [X, Y, moduleID, sourceID]. ModuleID is the row
%                         number of probe.modules. Coordinates are defined from
%                         a global 0,0 coordinate. Included regardless if module is
%                         active or not.
%     probe.detposns:     A Dx2 matrix similar to probe.srcposns. Each row
%                         is [X, Y, moduleID, detectorID].
%     
% Outputs:
%     The following fields are derived from characterizeProbe(). The number 
%     of outputs depends on the number of design parameters defined. 
%     
%     probe.results:      A struct with sub-fields:
%         results.modulecount:    An integer. The number of active modules in the probe
%         results.optodecount:    A struct with sub-fields
%                 srcs: An integer with the total number of sources on active modules
%                 dets: An integer with the total number of detectors on active modules
%                 optodes: An integer with the total number of optodes (srcs + dets)
%         results.channels: A Cx5 matrix specifying channels. C is the number of 
%                         channels of the probe. Channels is limited to 
%                         SD separations below sdrange(2). Each row is
%                         [SDseparation, sourceID, detectorID, moduleIDofSource,
%                         moduleIDofdetector].
%         results.intrachannels: Subset of results.channels that only includes 
%                         channels with sources and detectors on the 
%                         same module. 
%         results.interchannels: Subset of results.channels that only includes 
%                         channels with sources and detectors on different
%                         modules.
%         results.full:   A struct with sub-fields channels, intrachannels, and
%                         interchannels. These fields are NOT limited by sdrange.
%         results.sschannels: Subset of results.channels with SD separations below
%                         sdrange(1), exclusive
%         results.lschannels: Subset of results.channels with SD separations between
%                         sdrange(1) and sdrange(2), inclusive
%         results.exchannels: Channels with SD separations above sdrange(2), 
%                         exclusive. 
%         results.brainsensitivity: A Bx5 matrix specifying the Brain Sensitivity
%                         of each channel. B is the number of channels.
%                         Brain Sensitivity is sum of white and gray
%                         matter. Each row is [BrainSensitivity, 
%                         sourceID, detectorID, moduleIDofSource,
%                         moduleIDofdetector].
%         results.intrabrainsensitivity: A subset of results.brainsensitivity
%                         that only includes channels with sources
%                         and detectors on the same module.
%         results.interbrainsensitivity: A subset of results.brainsensitivity
%                         that only includes channels with sources
%                         and detectors on different modules.
%         results.groupings:  A Gx5 matrix specifying the spatial multiplexing
%                         groups of the probe. Each row is an active
%                         source. Each row is defined as [sourceX, 
%                         sourceY, moduleID, sourceID,
%                         SpatialMultiplexingGroupID]
    

addpath('lib');
addpath('examples');


end

