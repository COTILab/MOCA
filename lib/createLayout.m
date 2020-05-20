function [probe] = createLayout(module, probe) % roi, SDrange, spacing )
%CREATELAYOUT Create a probe composed of modules over a ROI
%   Detailed explanation goes here

probe.module = module;          % absorb the single module into the probe
probe.maxwidth = max(probe.roi(:,1));     % probe's max width
probe.maxheight = max(probe.roi(:,2));    % probe's max height
if (length(probe.sdrange) == 1)       % if only a single number inputted, 
    probe.sdrange = [10 probe.sdrange];   % then default to SS channels being < 10mm, inclusive
end
if(isfield(probe, 'spacing') == 0)     % if spacing not specified
    probe.spacing = 0;
end
add_module = 0;     % flag to know if another module should be added to a row


if (strcmp(probe.module.shape, 'square'))
    probe.n_modules_x = ceil(probe.maxwidth / probe.module.dimension);
    probe.n_modules_y = ceil(probe.maxheight/ probe.module.dimension);
    probe = tessellateModule(probe);
end

end

