function [probe] = createLayout(probe, denseoption) 
%CREATELAYOUT Create a probe composed of modules over a ROI
%   Create layout is a MOCA function used to facilitate the tessellation of
%   a module design over a ROI. Tessellation is done as a "grid" over the
%   ROI that covers the max width and max height of the ROI. For triangle
%   and hexagon shapes, the 'dense' option permits MOCA to change the
%   orientation of each module to tessellate the module shape over the ROI
%   without leaving any gaps. If the module shape was defined manually (not
%   using createModule(), then only the grid tessellation is available.
%   Individual modules can be translated and oriented using rotateModule()
%   and translateProbe() functions. This function results in sub-fields of
%   probe.modules, probe.srcposns, and probe.detposns. These sub-fields can
%   be individually inputted manually for higher control.

if (nargin == 2)
    if (strcmp(denseoption, 'dense'))
        probe.denseflag = true;
        add_module = 1;
    else
        probe.denseflag = false;
        add_module = 0;
    end
elseif (nargin == 1)
    add_module = 0;     % flag to know if another module should be added to a row
end

probe.maxroiwidth = max(probe.roi(:,1)) - min(probe.roi(:,1));     % probe's max width
probe.maxroiheight = max(probe.roi(:,2)) - min(probe.roi(:,2));    % probe's max height

if (isfield(probe,'sdrange'))
    if (length(probe.sdrange) == 1)         % if only a single number inputted, 
        probe.sdrange = [10 probe.sdrange]; % then default to SS channels being < 10mm, inclusive
    end
else    % if sdrange was never inputted 
    probe.sdrange = [10 1000];
end
if(isfield(probe, 'spacing') == 0)     % if spacing not specified
    probe.spacing = 0;
end


% SQUARE shape
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
    
    probe.add_module = add_module;
    probe = tessellateModule(probe);


%TRIANGLE shape
elseif (strcmp(probe.module.shape, 'triangle'))
    add_module = 1;
    tri_width = probe.module.dimension;
    
    % Find number of modules in x axis
    probe.n_modules_x = ceil(probe.maxroiwidth / (tri_width + probe.spacing)) * 2;
    % if n_modules_x + spacing in between is less than roi width, add another
    if(probe.n_modules_x*tri_width + (probe.n_modules_x-1)*probe.spacing < probe.maxroiwidth)
        probe.n_modules_x = probe.n_modules_x + 1;
    end
    % Find number of modules in y axis
    tri_height = probe.module.dimension*sqrt(3)/2;
    probe.n_modules_y = ceil((probe.maxroiheight) / (tri_height + probe.spacing));
    if(probe.n_modules_y*tri_height + (probe.n_modules_y-1)*probe.spacing < probe.maxroiheight)
        probe.n_modules_y = probe.n_modules_y + 1;
    end
    
    probe.add_module = add_module;
    probe = tessellateModule(probe);
    
%HEXAGON shape
elseif (strcmp(probe.module.shape, 'hexagon'))
    add_module = 1;
    hex_width = 2*probe.module.dimension*cosd(30);
    
    % Find number of modules in x axis
    probe.n_modules_x = ceil(probe.maxroiwidth / (hex_width + probe.spacing));
    % if n_modules_x + spacing in between is less than roi width, add another
    if(probe.n_modules_x*hex_width + (probe.n_modules_x-1)*probe.spacing < probe.maxroiwidth)
        probe.n_modules_x = probe.n_modules_x + 1;
    end
    % Find number of modules in y axis
    probe.n_modules_y = ceil((probe.maxroiheight) / ((1.5*probe.module.dimension) + probe.spacing));
    if(probe.n_modules_y*1.5*probe.module.dimension + (probe.n_modules_y-1)*probe.spacing < probe.maxroiheight)
        probe.n_modules_y = probe.n_modules_y + 1;
    end
    
    probe.add_module = add_module;
    probe = tessellateModule(probe);
    
%ARBITRARY shape  
elseif ((isfield(probe.module, 'shape')==false) || strcmp(probe.module.shape, 'diamond'))
    maxmodwidth = max(probe.module.perimeter(:,1)) - min(probe.module.perimeter(:,1));
    maxmodheight = max(probe.module.perimeter(:,2)) - min(probe.module.perimeter(:,2));
    probe.module.dimension = max([maxmodwidth, maxmodheight]);
    
    % Find number of modules in x axis
    probe.n_modules_x = ceil(probe.maxroiwidth / (maxmodwidth + probe.spacing));
    % if n_modules_x + spacing in between is less than width, add another
    if(probe.n_modules_x*maxmodwidth + (probe.n_modules_x-1)*probe.spacing < probe.maxroiwidth)
        probe.n_modules_x = probe.n_modules_x + 1;
    end
    % Find number of modules in y axis
    probe.n_modules_y = ceil(probe.maxroiheight/ (maxmodheight + probe.spacing));
    if(probe.n_modules_y*maxmodheight + (probe.n_modules_y-1)*probe.spacing < probe.maxroiheight)
        probe.n_modules_y = probe.n_modules_y + 1;
    end
    
    probe.add_module = add_module;
    probe = tessellateModule(probe);

end



%probe = getAdjMatrix(probe);

end

