function [] = plotChannels(probe, plottypein, rangetypein, breakdowntypein)
%PLOTCHANNELS Summary of this function goes here
%   Plot the channels. There are two plot types: histogram and spatial.
%   Histogram plots the channels in a histogram showing frequency of SD
%   separations. By default, the binwidth is 1mm.  Spatial plots plot the
%   channels in a 2D plot of lines representing channels. The channels can
%   either be colored using a colorbar representing the channel SD
%   separation, or using a binary color showing inter and intra module
%   channels. How to define the plot, range, and breakdown type is shown in
%   the table below. If a type in a column in not defined, the type with
%   the asterisk (*) is plotted by default.

% Plot    | Range     | Breakdown
% type    | type      | type
% -------------------------------
% 'hist'* | 'sd'*     | 
%         | 'full'    | 
% -------------------------------
% 'spat'  | 'sd'*     | 'col'*
%         |           | 'int'
%         -----------------------
%         | 'full'    | 'col'*
%         |           | 'int'


% Determine the number of inputs.
switch nargin
    case 1
        plottype =      'hist';
        rangetype =     'sd';
        breakdowntype = 'col';
    case 2
        plottype =      plottypein;
        rangetype =     'sd';
        breakdowntype = 'col';
    case 3
        plottype =      plottypein;
        rangetype =     rangetypein;
        breakdowntype = 'col';
    case 4
        plottype =      plottypein;
        rangetype =     rangetypein;
        breakdowntype = breakdowntypein;
    otherwise
end


hold on
% PLOT THEM AS A HISTOGRAM
switch plottype
    case 'hist'

        % Determine rangetype
        switch rangetype
            case 'sd'
            case 'full'
                h1 = histogram(probe.results.fullintrachannels(:,1), 'BinWidth', 1);
                h2 = histogram(probe.results.fullinterchannels(:,1), 'BinWidth', 1);
                legend('intra', 'inter')
        end
    


% PLOT THEM SPATIALLY
	case 'spat'



end



end

