function [] = plotSingleChannel(probein, srcIDin, detIDin, linestylein, colorin)
%PLOTSINGLECHANNEL Summary of this function goes here
%   Given a probe, srcID, and detID, this functions draws a line between
%   optodes. Used for MOBI visualization to update individual channels


%'Color',[.6 0 0]
%'LineStyle'
switch nargin
    case 3
        probe = probein;
        srcID = srcIDin;
        detID = detIDin;
        linestyle = '--';
        color = [.5 .5 .5];
    case 5
        probe = probein;
        srcID = srcIDin;
        detID = detIDin;
        linestyle = linestylein;
        color = colorin;
    otherwise
        disp('Not enough input arguments');
end


% Begin plotting
hold on

% Find indeces
srcRowIdx = find(probe.srcposns(:,4) == srcID);
detRowIdx = find(probe.detposns(:,4) == detID);
srcX = probe.srcposns(srcRowIdx, 1);
srcY = probe.srcposns(srcRowIdx, 2);
detX = probe.detposns(detRowIdx, 1);
detY = probe.detposns(detRowIdx, 2);

%probe.srcposns(srcRowIdx, 1:2);
%probe.detposns(detRowIdx, 1:2);

% plot the line
plot([srcX, detX],...
            [srcY, detY],...
            'LineStyle', linestyle,...
            'Color', color);
% plot([probe.srcposns(srcRowIdx, 1:2)],...
%             [probe.detposns(detRowIdx, 1:2)],...
%             'LineStyle', linestyle,...
%             'Color', color);


end

