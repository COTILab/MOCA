function [probe] = getSDSeparations(probe)
%GETSDSEPARATIONS Calculates separation for each src/det pair
%   Given a probe with src and detposns defined as [x, y, modidx,
%   src/detidx], calculate the euler distance between all
%   permutations/pairs of sources and detectors, of active modules only. 
%   Output is a Nx5 matrix, where N=(number of srcs)*(number of dets)-> 
%   only from active modules. The five columns refer to
%   [separation, srcidx, detidx, srcmodidx, detmodidx]. This function
%   calculates for both full sdrange as well as within sdrange channels.
%   Within range outputs are saved to sub-fields probe.results.channels,
%   .intramodulechannels, and .intermodulechannels. The same three
%   subfields are calculated without SDrange limitations and saved to
%   probe.results.full

srcs = probe.results.srcposns; % [x, y, modidx, srcidx]
dets = probe.results.detposns; % [x, y, modidx, detidx]

% Calculate for FULL CHANNELS (channels, intra, inter)
sd = zeros(size(srcs,1)*size(dets,1), 5);
intraidx = false(size(srcs,1)*size(dets,1), 1);  % logical matrix identifying intra channels.
sdcount = 1;

for s=1:size(srcs,1)
    for d=1:size(dets,1)
        separation = sqrt( (srcs(s,1)-dets(d,1))^2 + (srcs(s,2)-dets(d,2))^2 );
        srcidx = srcs(s,4);
        detidx = dets(d,4);
        srcmodidx = srcs(s,3);
        detmodidx = dets(d,3);
        sd(sdcount,:) = [separation, srcidx, detidx, srcmodidx, detmodidx];

        if (srcmodidx == detmodidx)
            intraidx(sdcount) = true;
        else
            intraidx(sdcount) = false;
        end

        sdcount = sdcount + 1;
    end
end

interidx = not(intraidx);

%probe.results.full.channels = sd;
probe.results.full.intrachannels = sd(intraidx,:);
probe.results.full.interchannels = sd(interidx,:);
probe.results.full.channels = [probe.results.full.intrachannels; probe.results.full.interchannels];


% Calculate for SDRANGE-LIMITED CHANNELS (channels, intra, inter, sschannels, lschannels, exchannels)
if(isfield(probe, 'sdrange'))
    sd = zeros(size(srcs,1)*size(dets,1), 5);
    intraidx = false(size(srcs,1)*size(dets,1), 1);  % logical matrix identifying intra channels.
    sdcount = 1;

    for s=1:size(srcs,1)
        for d=1:size(dets,1)
            separation = sqrt( (srcs(s,1)-dets(d,1))^2 + (srcs(s,2)-dets(d,2))^2 );
            srcidx = srcs(s,4);
            detidx = dets(d,4);
            srcmodidx = srcs(s,3);
            detmodidx = dets(d,3);
            sd(sdcount,:) = [separation, srcidx, detidx, srcmodidx, detmodidx];

            if (srcmodidx == detmodidx)
                intraidx(sdcount) = true;
            else
                intraidx(sdcount) = false;
            end

            sdcount = sdcount + 1;
        end
    end
    
    % full sdrange results
    interidx = not(intraidx);
    intrachannels = sd(intraidx,:);
    interchannels = sd(interidx,:);
    
    % indexes that limit channels to sdrange
    chidx = probe.results.full.channels(:,1) <= probe.sdrange(2);    % indeces of channels below <= sdrange(2)
    raidx = probe.results.full.intrachannels(:,1) <= probe.sdrange(2);    % indeces of intra channels <= sdrange(2)
    eridx = probe.results.full.interchannels(:,1) <= probe.sdrange(2);    % indeces of inter channels <= sdrange(2)
    ssidx = sd(:,1) < probe.sdrange(1); % indeces of ss channels
    lsidx = ( sd(:,1) >= probe.sdrange(1) & sd(:,1) <= probe.sdrange(2) ); % indeces of in range channels
    exidx = sd(:,1) > probe.sdrange(2); % indeces of channels above range 

    
    %probe.results.channels = probe.results.full.channels(chidx,:);
    probe.results.intrachannels = probe.results.full.intrachannels(raidx,:);
    probe.results.interchannels = probe.results.full.interchannels(eridx,:);
    probe.results.channels = [probe.results.intrachannels; probe.results.interchannels];    % intra then inter channels
    probe.results.sschannels = sd(ssidx,:);
    probe.results.lschannels = sd(lsidx,:);
    probe.results.exchannels = sd(exidx,:);
end

end

