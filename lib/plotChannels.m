function [] = plotChannels(probe, plottypein, rangetypein, breakdowntypein)
%PLOTCHANNELS Plot histrogram or spatial plot of channel distribution
%   Plot the channels. There are two plot types: histogram and spatial.
%   Histogram plots the channels in a histogram showing frequency of SD
%   separations. By default, the binwidth is 1mm.  Spatial plots plot the
%   channels in a 2D plot of lines representing channels. The channels can
%   either be colored using a colorbar representing the channel SD
%   separation, or using a binary color showing inter and intra module
%   channels. How to define the plot, range, and breakdown type is shown in
%   the table below. If a type in a column in not defined, the type with
%   the asterisk (*) is plotted by default.
%         Plot    | Range     | Breakdown
%         type    | type      | type
%         -------------------------------
%         'hist'* | 'sd'*     | 
%                 | 'full'    | 
%         -------------------------------
%         'spat'  | 'sd'*     | 'col'*
%                 |           | 'int'
%                 -----------------------
%                 | 'full'    | 'col'*
%                 |           | 'int'


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


% make temporary variables based on rangetype
srcposns = probe.srcposns;
detposns = probe.detposns;
switch rangetype
    case 'sd'
        channels = probe.results.channels;
        intrachannels = probe.results.intrachannels;
        interchannels = probe.results.interchannels;
    case 'full'
        channels = probe.results.full.channels;
        intrachannels = probe.results.full.intrachannels;
        interchannels = probe.results.full.interchannels;
    otherwise
end


% Begin plotting
hold on

% PLOT THEM AS A HISTOGRAM
switch plottype
    case 'hist'
        h1 = histogram(intrachannels(:,1),...
                'BinWidth', 1, 'FaceColor', [0 0.4470 0.7410]); %blue
        h2 = histogram(interchannels(:,1),...
                'BinWidth', 1, 'FaceColor', [0.8500 0.3250 0.0980]); %orange
        legend('intra', 'inter');
        xlabel('SD Separation [mm]');
        ylabel('Channel Count [n]');
        title('Channel Count Distribution');
    
% PLOT THEM SPATIALLY
	case 'spat'
        % Determine breakdowntype
        switch breakdowntype
            case 'col'
                clear c srcidx detidx i
                c = probe.results.channels(:,1);    % data to be plotted
                srcidx = probe.results.channels(:,2);
                detidx = probe.results.channels(:,3);
                ran=range(probe.results.channels(:,1));   % range of data
                min_val=min(probe.results.channels(:,1)); % minimum value of data
                max_val=max(probe.results.channels(:,1)); % maximum value of data
                y=floor(((c-min_val)/ran)*63)+1;    % 2^6, scale for 6 bit colors
                col=zeros(length(c),3);     % an rgb value for each channel
                p=colormap;
                for i=1:length(c)
                    a=y(i);
                    col(i,:)=p(a,:);
                    plot([srcposns(srcidx(i),1), detposns(detidx(i),1)],...
                            [srcposns(srcidx(i),2), detposns(detidx(i),2)],...
                            'Color',col(i,:),...
                            'LineWidth',2);
                    axis equal;
                    h = colorbar;
                    ylabel(h, 'SD Separation [mm]');
                    caxis([min_val max_val]);
                end

            case 'int'
                clear c srcidx detidx i
                % INTER module channels
                c = interchannels(:,1);    % channel separations
                srcidx = interchannels(:,2);
                detidx = interchannels(:,3);
                for i=1:length(c)
                    src = srcidx(i); % src 1
                    det = detidx(i); % det 16   
                    % fix this part. Find the xy coor of the src_th src
                    h(1) = plot([srcposns(src,1), detposns(det,1)],...
                            [srcposns(src,2), detposns(det,2)],...
                            'Color', [0.8500 0.3250 0.0980],...
                            'LineWidth',2);
                end
                clear c srcidx detidx i
                % INTRA module channels
                c = intrachannels(:,1);    % channel separations
                srcidx = intrachannels(:,2);
                detidx = intrachannels(:,3);
                for i=1:length(c)
                    src = srcidx(i);
                    det = detidx(i);
                    h(2) = plot([srcposns(src,1), detposns(det,1)],...
                            [srcposns(src,2), detposns(det,2)],...
                            'Color', [0 0.4470 0.7410],...
                            'LineWidth',2);
                end
                legend(h(1:2),'inter','intra');
        end
end


% update xlabels, ylabels, and titles


end

