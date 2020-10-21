function [matrix] = getSMGMatrix(probe,outputtype)
%GETSMGMATRIX Summary of this function goes here
%   Given a characterized probe, this function outputs a 
%   [nGroups+2]x[1+nModule] matrix for use updating firmware of master
%   board of fNIRS modules. Two rows are added to the number of groups, one
%   for 'group' that samples all short-separation channels and one 'group'
%   that samples all auxiliary sensors (ie. IMUs). A column is added to the
%   beginning of the nModule columns. This is a dummy column that can be
%   used by the master board to distinquish the type of data (Pattern,
%   Sensor, Trigger, etc.). If outputtype='num', a numeric matrix is
%   outputted. If outputtype='str', then a [nGroups+2]x1 string array is
%   outputted to facilitate copy and paste during debugging.


groups = probe.results.groups;          % [x y modid srcid groupid]
ngroups = probe.results.ngroups;        % number of groups
nmodules = probe.results.modulecount;   % number of modules
nsrcssingle = size(probe.module.srcposns,2);    % n srcs in one module

% update src numbers from global (1:total srcs in the entire probe) to 
% module (1:number of src on a single module)
srcrelative = mod(groups(:,4), nsrcssingle);
srcrelative(srcrelative == 0) = nsrcssingle;

% preallocate matrix
patterns = zeros(ngroups+2, 1+nmodules);

for row = 1:ngroups
    %for col = 2:1+nmodules
        % inside one row
        
        % find all rows of group 1
        idxOfGroup = find(groups(:,5) == row);
        globalModuleNumber = groups(idxOfGroup,3);
        srcID = srcrelative(idxOfGroup,1);
        
        for col = 1:size(globalModuleNumber,1)
            patterns(row, 1+globalModuleNumber(col)) = srcID(col);
        end
        
    %end
end

% row defining SS channels
patterns(size(patterns,1)-1, 2:size(patterns,2)) = 3*ones(1,nmodules);

% row defining auxiliary sensors (IMU)
patterns(size(patterns,1),   2:size(patterns,2)) = 8*ones(1,nmodules);


if (strcmp(outputtype, 'num'))
    matrix = patterns;
elseif (strcmp(outputtype, 'str'))
    disp('make to string')
end

% example
% int patterns[NUMBER_PATTERNS+2][NUMBER_DEVICES+1] = { 
%   {0, 0,3,0,0,0,0,0,0},
%   {0, 1,0,0,0,3,0,0,0},
%   {0, 8,0,0,0,0,0,0,0},
%   {0, 0,8,0,0,0,0,0,0},
%   //{0, 3,3,3,3,3,3,3,3},   // TODO: Confirm this reads all SS channels at once
%   //{0, 8,8,8,8,8,8,8,8},   // TODO: Confirm this gets all IMU data at once
% 
%   };

%matrix;

end

