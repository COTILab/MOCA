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
Lambda = [690,830];
nSrcs = size(probe.results.srcposns,1);
nDets = size(probe.results.detposns,1);
nChannels = size(probe.results.channels,1);
MeasList = [probe.results.channels(:,2:3), ones(nChannels,1), ones(nChannels,1);...
            probe.results.channels(:,2:3), ones(nChannels,1), 2*ones(nChannels,1)];

% Generate Spring List
% FIRST, the distances between all optodes (including src-src and det-det
% pairs) should be fixed. This prevents the module from changing shape when
% registered to the scalp
iSL = 1;
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
        
        IntraSpringList(iSL, :) = [op1, op2, len];
        iSL = iSL + 1;
    end
end
% SECOND, add loose springs in between intermodule channels
InterSpringList = zeros(size(probe.results.interchannels,1), 3);
InterSpringList(:,1:2) = probe.results.interchannels(:,2:3);    % x,y positions
InterSpringList(:,3) = probe.results.interchannels(:,1);        % actual distances
InterSpringList(:,2) = InterSpringList(:,2) + nSrcs;            % shift det numbering
InterSpringList(:,3) = -1 * ones(size(probe.results.interchannels,1), 1);   % make -1 to be flexible

% Add dummy optodes. Need at least 3 to use as anchors
DummyPos(1,:) = [mean([xmin,xmax]), ymin             , 0];
DummyPos(2,:) = [mean([xmin,xmax]), mean([ymin,ymax]), 0];
DummyPos(3,:) = [mean([xmin,xmax]), ymax             , 0];
nDummys = size(DummyPos,1);

% Anchor list. Begins counting after sources and detectors
AnchorList{1,1} = nSrcs+nDets+1;
AnchorList{2,1} = nSrcs+nDets+2;
AnchorList{3,1} = nSrcs+nDets+3;
AnchorList{1,2} = 'Oz'; %Fpz=forehead. Cz=top of head, C5=left of head, C6=right of head, Oz=back of head
AnchorList{2,2} = 'POz';
AnchorList{3,2} = 'Pz';

% create the SD structure
SD.Lambda = Lambda;
SD.SrcPos = [probe.results.srcposns(:,1:2), zeros(nSrcs,1)];
SD.DetPos = [probe.results.detposns(:,1:2), zeros(nDets,1)];
SD.DummyPos = DummyPos;
SD.nSrcs = nSrcs;
SD.nDets = nDets;
SD.nDummys = nDummys;
SD.MeasList = MeasList;
SD.SpringList = [IntraSpringList; InterSpringList];
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

