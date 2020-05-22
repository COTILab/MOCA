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

% Check that the sdrange limited channels exists. If they don't default to
% full.intrachannels and full.interchannels. 


% Begin plotting
hold on

% PLOT THEM AS A HISTOGRAM
switch plottype
    case 'hist'
        % Determine rangetype
        switch rangetype
            case 'sd'
            case 'full'
                h1 = histogram(probe.results.full.intrachannels(:,1),...
                                'BinWidth', 1, 'FaceColor', [0 0.4470 0.7410]);
                h2 = histogram(probe.results.full.interchannels(:,1),...
                                'BinWidth', 1, 'FaceColor', [0.8500 0.3250 0.0980]);
                legend('intra', 'inter');
                xlabel('SD Separation [mm]');
                ylabel('Channel Count [n]');
                title('Channel Count Distribution');
        end
    
% PLOT THEM SPATIALLY
	case 'spat'
        % Determine rangetype
        switch rangetype
            case 'sd'
                % Determine breakdowntype
                switch breakdowntype
                    case 'col'
                    case 'int'
                end

            case 'full'
                % Determine breakdowntype
                switch breakdowntype
                    case 'col'
                        c = probe.results.full.channels(:,1);    % data to be plotted
                        srcidx = probe.results.full.channels(:,2);
                        detidx = probe.results.full.channels(:,3);
                        ran=range(c);   % range of data
                        min_val=min(c); % minimum value of data
                        max_val=max(c); % maximum value of data
                        y=floor(((c-min_val)/ran)*63)+1;    % 2^6, scale for 6 bit colors
                        col=zeros(length(c),3);     % an rgb value for each channel
                        p=colormap;
                        for i=1:length(c)
                            a=y(i);
                            col(i,:)=p(a,:);
                            plot([probe.srcposns(srcidx(i),1), probe.detposns(detidx(i),1)],...
                                    [probe.srcposns(srcidx(i),2), probe.detposns(detidx(i),2)],...
                                    'Color',col(i,:),...
                                    'LineWidth',2);
                            axis equal;
                            h = colorbar;
                            ylabel(h, 'SD Separation [mm]');
                            caxis([min_val max_val]);
                        end

                    case 'int'
                        % INTER module channels
                        c = probe.results.full.interchannels(:,1);    % channel separations
                        srcidx = probe.results.full.interchannels(:,2);
                        detidx = probe.results.full.interchannels(:,3);
                        for i=1:length(c)
                            src = srcidx(i);
                            det = detidx(i);
                            h(1) = plot([probe.srcposns(src,1), probe.detposns(det,1)],...
                                    [probe.srcposns(src,2), probe.detposns(det,2)],...
                                    'Color', [0 0.4470 0.7410],...
                                    'LineWidth',2);
                        end
                        clear c srcidx detidx i
                        % INTRA module channels
                        c = probe.results.full.intrachannels(:,1);    % channel separations
                        srcidx = probe.results.full.intrachannels(:,2);
                        detidx = probe.results.full.intrachannels(:,3);
                        for i=1:length(c)
                            src = srcidx(i);
                            det = detidx(i);
                            h(2) = plot([probe.srcposns(src,1), probe.detposns(det,1)],...
                                    [probe.srcposns(src,2), probe.detposns(det,2)],...
                                    'Color', [0.8500 0.3250 0.0980],...
                                    'LineWidth',2);
                        end
                        %legend('inter', 'intra');
                        legend(h(1:2),'inter','intra');
                end
        end

end

% update xlabels, ylabels, and titles


end

