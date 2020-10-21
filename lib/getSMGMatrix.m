function [globalmatrix, localmatrix] = getSMGMatrix(probe,outputtype)
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
%   outputted to facilitate copy and paste during debugging. The global
%   matrix outputted returns the global src id (1:total number of sources).
%   The local matrix output uses the src id within a module (1:total number
%   of sources inside a module) by using mod(globalSrcID,
%   numSrcInASingleModule).


groups = probe.results.groups;          % [x y modid srcid groupid]
ngroups = probe.results.ngroups;        % number of groups
nmodules = probe.results.modulecount;   % number of modules
nsrcssingle = size(probe.module.srcposns,1);    % n srcs in one module

% preallocate matrix
patterns = zeros(ngroups+2, 1+nmodules);

for row = 1:ngroups
        % find all rows of that are part of this group
        idxOfGroup = find(groups(:,5) == row);
        globalModuleNumber = groups(idxOfGroup,3);
        srcID = groups(idxOfGroup,4);
        
        % update the row values with src number
        for col = 1:size(globalModuleNumber,1)
            patterns(row, 1+globalModuleNumber(col)) = srcID(col);
        end
end

% row defining SS channels
patterns(size(patterns,1)-1, 2:size(patterns,2)) = 3*ones(1,nmodules);

% row defining auxiliary sensors (IMU)
patterns(size(patterns,1),   2:size(patterns,2)) = 8*ones(1,nmodules);


% convert to local src ID
% update src numbers from global (1:total srcs in the entire probe) to 
% module (1:number of src on a single module)
submatrix = patterns(1:ngroups, 2:nmodules+1);
submatrix(submatrix == 0) = nan;% preserve the zeros
srcrelative = mod(submatrix, nsrcssingle);
srcrelative(srcrelative == 0) = nsrcssingle;
srcrelative(isnan(srcrelative)) = 0;% preserve the zeros
localpatterns = patterns;
localpatterns(1:ngroups, 2:nmodules+1) = srcrelative;


% create string list for copy and paste
strList = string( zeros(size(patterns,1), 1) );
localstrList = string( zeros(size(localpatterns,1), 1) );

for r=1:size(patterns,1)
    % convert global src id
    n = patterns(r,:);
    allOneString = sprintf('%.0f,' , n);    % character vector   
    allOneString = allOneString(1:end-1);   % strip final comma
    textRow = "{" + allOneString + "},";
    strList(r) = string(textRow);      % string
    
    % convert local src id
    n = localpatterns(r,:);
    allOneString = sprintf('%.0f,' , n);    % character vector   
    allOneString = allOneString(1:end-1);   % strip final comma
    textRow = "{" + allOneString + "},";
    localstrList(r) = string(textRow);      % string
end


% save to output
if (strcmp(outputtype, 'num'))
    globalmatrix = patterns;
    localmatrix = localpatterns;
elseif (strcmp(outputtype, 'str'))
    globalmatrix = strList;
    localmatrix = localstrList;
end



% example string output for arduino
% int patterns[NUMBER_PATTERNS+2][NUMBER_DEVICES+1] = { 
%     {0,1,0,1,0,1,0,1,0},
%     {0,2,1,0,1,0,1,0,1},
%     {0,3,0,2,3,0,2,3,0},
%     {0,0,2,3,0,2,3,0,2},
%     {0,0,3,0,2,3,0,2,3},
%     {0,3,3,3,3,3,3,3,3}, // TODO: Confirm this reads all SS channels at once
%     {0,8,8,8,8,8,8,8,8}, // TODO: Confirm this gets all IMU data at once 
%   };

end

