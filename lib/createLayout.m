function [probe] = createLayout( design, spacing )
%CREATELAYOUT Create a probe composed of modules over a ROI
%   Detailed explanation goes here

probe.width = max(design.roi(:,1));     % probe's max width
probe.height = max(design.roi(:,2));    % probe's max height
if(nargin == 1)     % if not gap inputted, default to a gap of zero
    gap = 0;
else
    gap = spacing;
end
add_module = 0;     % flag to know if another module should be added to a row


if (strcmp(design.module.shape, 'square'))
    probe.n_modules_x = ceil(probe.width / design.module.dimension);
    probe.n_modules_y = ceil(probe.height/ design.module.dimension);
    probe = tessellateModule(design, probe);
end

end

