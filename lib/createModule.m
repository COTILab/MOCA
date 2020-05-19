function [module] = createModule(nsides,mdimension)
%CREATEMODULE Automatically derive perimeter points of module
%   This is an automated function of MOCA meant to facilitate making a
%   regular shape. A regular shape is defined as equiangular and
%   equilateral. The first three regular polygons that can tessellate by
%   themselves are support (triangle, square, hexagon). Each module is
%   centered on the origin 0,0.
%   nsides must be equal to 3, 4, or 6
%   mdimension must be positive

% Square shaped module
if (nsides == 4)
    %module.srcs = [-12.5,12.5; 12.5,-12.5];
    %module.dets = [-12.5,4; 12.5,12.5; 12.5,-4; -12.5,-12.5];
    %module.nss = 2;
    %module.lss = 8.5;
    %module.shape = 'square';
    module.dimension = mdimension;
    module.perimeter = [-module.dimension/2,    module.dimension/2;...
                        module.dimension/2,     module.dimension/2;...
                        module.dimension/2,     -module.dimension/2;...
                        -module.dimension/2,    -module.dimension/2];
end




%module = [0 0; 4 0; 4 4; 0 4];
end

