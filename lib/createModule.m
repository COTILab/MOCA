function [module] = createModule(nsides,mdimension)
%CREATEMODULE Automatically derive perimeter points of module
%   This is an automated function of MOCA meant to facilitate making a
%   regular shape. A regular shape is defined as equiangular and
%   equilateral. The first three regular polygons that can tessellate by
%   themselves are support (triangle, square, hexagon). Each module is
%   centered on the origin 0,0.
%   nsides must be equal to 3, 4, or 6
%   mdimension must be positive


% Triangle shaped module
if (nsides == 3)
    module.dimension = mdimension;
    module.perimeter = [0,                      module.dimension/sqrt(3);...
                        module.dimension/2,     -module.dimension*sqrt(3)/6;...
                        -module.dimension/2,    -module.dimension*sqrt(3)/6];

% Square shaped module
elseif (nsides == 4)
    module.dimension = mdimension;
    module.perimeter = [-module.dimension/2,    module.dimension/2;...
                        module.dimension/2,     module.dimension/2;...
                        module.dimension/2,     -module.dimension/2;...
                        -module.dimension/2,    -module.dimension/2];
    module.type = 'square'; % to demonstrate it was automatically generated

% Hexagon shaped module
elseif (nsides == 6)
end


end

