function [SD] = exportOptodes(probe, ExportLocation)
%EXPORTOPTODES Exports optodes of a probe into a SD file structure
%   Creates an SD file structure for use in AtlasViewer. Add fixed springs
%   between all optodes within modules to maintain the module shape when
%   the probe is registered to the scalp. Add loose springs on intermodule
%   channels to allow the probe to "flex" onto the surface.


% find limits based on optodes
allx = [probe.results.srcposns(:,1); probe.results.detposns(:,1)];
xmin = min(allx);
xmax = max(allx);
ally = [probe.results.srcposns(:,2); probe.results.detposns(:,2)];
ymin = min(ally);
ymax = max(ally);

% get quantities and measurement list
Lambda = [690,850]; % Can change
nSrcs = size(probe.results.srcposns,1);
nDets = size(probe.results.detposns,1);
nChannels = size(probe.results.channels,1);
MeasList = [probe.results.channels(:,2:3), ones(nChannels,1), ones(nChannels,1);...
            probe.results.channels(:,2:3), ones(nChannels,1), 2*ones(nChannels,1)];

% Generate Spring List
% FIRST, the distances between all optodes (including src-src and det-det
% pairs) should be fixed. This prevents the module from changing shape when
% registered to the scalp
idxIntra = 1;
for m=1:probe.results.modulecount
    srcs = find(probe.results.srcposns(:,3)==m); %srcs in module m
    dets = find(probe.results.detposns(:,3)==m); %dets in module m
    dets_global = dets + nSrcs;
    
    A = [srcs; dets_global];
    pairs = nchoosek(A, 2);
    
    for p=1:size(pairs,1)   % for every pair
        op1 = pairs(p,1);
        op2 = pairs(p,2);
        
        if (op1>nSrcs) % then its a detector
            op1x = probe.results.detposns(op1-nSrcs,1); % pull from detposns
            op1y = probe.results.detposns(op1-nSrcs,2);
        else
            op1x = probe.results.srcposns(op1,1); % pull from srcposns
            op1y = probe.results.srcposns(op1,2);
        end
        
        if (op2>nSrcs) 
            op2x = probe.results.detposns(op2-nSrcs,1); % pull from detposns
            op2y = probe.results.detposns(op2-nSrcs,2);
        else
            op2x = probe.results.srcposns(op2,1); % pull from srcposns
            op2y = probe.results.srcposns(op2,2);
        end
        
        len = sqrt((op2x-op1x)^2 + (op2y-op1y)^2);
        
        IntraSpringList(idxIntra, :) = [op1, op2, len];
        idxIntra = idxIntra + 1;
    end
end

% SECOND, add fixed springs between intermodule channels that are within
% range of SD separation limit
interWithinRange=probe.results.interchannels;  % intermodule channels within SD range
interAll=probe.results.full.interchannels; % intermodule channels (all)
[C,idxInsideRange,idxA]=intersect(interAll,interWithinRange,'rows','stable');
[C,idxOutsideRange] = setdiff(interAll,interWithinRange,'rows','stable');

idxInter = 1;
for w=1:size(idxInsideRange,1)    % within SD range. Keep fixed
    op1 = probe.results.full.interchannels(idxInsideRange(w),2); %src
    op2 = probe.results.full.interchannels(idxInsideRange(w),3) + nSrcs; %det
    len = probe.results.full.interchannels(idxInsideRange(w),1); %distance
    
    InterSpringList(idxInter, :) = [op1, op2, len];
    idxInter = idxInter + 1;
end
for w=1:size(idxOutsideRange,1)    % outside SD range. Keep flexible (-1)
    op1 = probe.results.full.interchannels(idxOutsideRange(w),2); %src
    op2 = probe.results.full.interchannels(idxOutsideRange(w),3) + nSrcs; %det
    len = -1; %distance
    
    InterSpringList(idxInter, :) = [op1, op2, len];
    idxInter = idxInter + 1;
end


% Add dummy optodes. Need at least 3 to use as anchors
DummyPos(1,:) = [mean([xmin,xmax]), ymin             , 0];
DummyPos(2,:) = [mean([xmin,xmax]), mean([ymin,ymax]), 0];
DummyPos(3,:) = [mean([xmin,xmax]), ymax             , 0];
nDummys = size(DummyPos,1);

% Anchor list. Begins counting after sources and detectors
AnchorList{1,1} = nSrcs+nDets+1;
AnchorList{2,1} = nSrcs+nDets+2;
AnchorList{3,1} = nSrcs+nDets+3;
AnchorList{1,2} = 'Fpz'; %Fpz=forehead. Cz=top of head, C5=left of head, C6=right of head, Oz=back of head
AnchorList{2,2} = 'Cz';
AnchorList{3,2} = 'Oz';

% create the SD structure
SD.Lambda = Lambda;
SD.SrcPos = [probe.results.srcposns(:,1:2), zeros(nSrcs,1)];
SD.DetPos = [probe.results.detposns(:,1:2), zeros(nDets,1)];
SD.DummyPos = DummyPos;
SD.nSrcs = nSrcs;
SD.nDets = nDets;
SD.nDummys = nDummys;
SD.MeasList = MeasList;
if (exist('InterSpringList','var'))
    SD.SpringList = [IntraSpringList; InterSpringList];
else
    SD.SpringList = [IntraSpringList];
end
SD.AnchorList = AnchorList;
%SD.MeasListAct
%SD.SrcMap
SD.SpatialUnit = 'mm';
SD.xmin = xmin;
SD.xmax = xmax;
SD.ymin = ymin;
SD.ymax = ymax;
SD.auxChannels = [];

% if user added an export location, save the file
if (nargin==2)
    save(ExportLocation, 'SD');
else
end

end

