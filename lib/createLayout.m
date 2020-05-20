function [probe] = createLayout( module, roi, SDrange, spacing )
%CREATELAYOUT Create a probe composed of modules over a ROI
%   Detailed explanation goes here

probe.module = module;          % absorb the single module into the probe
probe.width = max(roi(:,1));     % probe's max width
probe.height = max(roi(:,2));    % probe's max height
if (length(SDrange) == 1)       % if only a single number inputted, 
    probe.SDrange = [10 SDrange];   % then default to SS channels being < 10mm, inclusive
end
if(nargin == 3)     % if not gap inputted, default to a gap of zero
    gap = 0;
else
    gap = spacing;
end
add_module = 0;     % flag to know if another module should be added to a row


if (strcmp(probe.module.shape, 'square'))
    probe.n_modules_x = ceil(probe.width / probe.module.dimension);
    probe.n_modules_y = ceil(probe.height/ probe.module.dimension);
    probe = tessellateModule(probe);
end

end

