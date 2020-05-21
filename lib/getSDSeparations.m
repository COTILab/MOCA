function [probe] = getSDSeparations(probe)
%GETSDSEPARATIONS Summary of this function goes here
%   Given a probe with src and detposns defined as [x, y, modidx,
%   src/detidx], calculate the euler distance between all
%   permutations/pairs of sources and detectors. Output is a Nx5 matrix,
%   where N=(number of srcs)*(number of dets). The five columns refer to
%   [separation, srcidx, detidx, srcmodidx, detmodidx]

srcs = probe.srcposns; % [x, y, modidx, srcidx]
dets = probe.detposns; % [x, y, modidx, detidx]

sd = zeros(size(srcs,1)*size(dets,1), 5);
sdcount = 1;

for s=1:size(srcs,1)
    for d=1:size(dets,1)
        separation = sqrt( (srcs(s,1)-dets(d,1))^2 + (srcs(s,2)-dets(d,2))^2 );
        srcidx = srcs(s,4);
        detidx = dets(d,4);
        srcmodidx = srcs(s,3);
        detmodidx = dets(d,3);
        sd(sdcount,:) = [separation, srcidx, detidx, srcmodidx, detmodidx];
        sdcount = sdcount + 1;
    end
end

probe.results.fullchannels = sd;

end

