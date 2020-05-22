function [activemodules, activesrcposns, activedetposns] = getActiveMSD(probe)
%GETACTIVEMSD Summary of this function goes here
%   Takes a probe as input, reads which modules are inactive, and removes
%   those from modules. It then finds the sources and detectors that are in
%   those inactive modules, and removes them from srcposns and detposns.

% Get active MODULES only
activemoduleidx = probe.modules(:,4) == 1;  % indeces of active modules
mcount = 1;
for m=1:size(activemoduleidx,1)
    if(activemoduleidx(m)==true)
        activemoduleN(mcount,1) = m;
        mcount=mcount+1;
    end
end
activemodules = probe.modules(activemoduleidx,:); % logic for sub-matrix

% get active SOURCES only
activesrcidx = false(size(probe.srcposns,1), 1);
for m=1:size(activemoduleN,1)
    for s=1:size(probe.srcposns, 1)
        if(probe.srcposns(s,3) == activemoduleN(m))
            activesrcidx(s) = true;
        end
    end
end
activesrcposns = probe.srcposns(activesrcidx,:);

% get active DETECTORS only
%activedetposns
activedetidx = false(size(probe.detposns,1), 1);
for m=1:size(activemoduleN,1)
    for d=1:size(probe.detposns, 1)
        if(probe.detposns(d,3) == activemoduleN(m))
            activedetidx(d) = true;
        end
    end
end
activedetposns = probe.detposns(activedetidx,:);

end

