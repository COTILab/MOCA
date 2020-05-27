function [probe] = createLayout(probe) 
%CREATELAYOUT Create a probe composed of modules over a ROI
%   Detailed explanation goes here

probe.maxroiwidth = max(probe.roi(:,1)) - min(probe.roi(:,1));     % probe's max width
probe.maxroiheight = max(probe.roi(:,2)) - min(probe.roi(:,2));    % probe's max height
if (isfield(probe,'sdrange'))
    if (length(probe.sdrange) == 1)       % if only a single number inputted, 
        probe.sdrange = [10 probe.sdrange];   % then default to SS channels being < 10mm, inclusive
    end
else    % if sdrange was never inputted 
    probe.sdrange = [10 1000];
end
if(isfield(probe, 'spacing') == 0)     % if spacing not specified
    probe.spacing = 0;
end
add_module = 0;     % flag to know if another module should be added to a row


if (strcmp(probe.module.shape, 'square'))
    % Find number of modules in x axis
    probe.n_modules_x = ceil(probe.maxroiwidth / (probe.module.dimension + probe.spacing));
    % if n_modules_x + spacing in between is less than width, add another
    if(probe.n_modules_x*probe.module.dimension + (probe.n_modules_x-1)*probe.spacing < probe.maxroiwidth)
        probe.n_modules_x = probe.n_modules_x + 1;
    end
    % Find number of modules in y axis
    probe.n_modules_y = ceil(probe.maxroiheight/ (probe.module.dimension + probe.spacing));
    if(probe.n_modules_y*probe.module.dimension + (probe.n_modules_y-1)*probe.spacing < probe.maxroiheight)
        probe.n_modules_y = probe.n_modules_y + 1;
    end
    
    probe = tessellateModule(probe);
end

end

