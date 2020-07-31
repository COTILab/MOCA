function [module] = createModule(nsides,mdimension)
%CREATEMODULE Automatically derive perimeter points of module
%   This is an automated function of MOCA meant to facilitate making a
%   regular shape. A regular shape is defined as equiangular and
%   equilateral. The first three regular polygons that can tessellate by
%   themselves are support (triangle, square, hexagon). Each module is
%   centered on the origin [0,0]. nsides must be equal to 3, 4, or 6. 
%   mdimension must be positive and refers to the length of one side of the
%   shape

% If the input is a number defining the number of sides
if( isnumeric(nsides))

    % Triangle shaped module
    if (nsides == 3) % || strcmp(nsides,'triangle'))
        module.dimension = mdimension;
        module.perimeter = [0,                      module.dimension/sqrt(3);...
                            module.dimension/2,     -module.dimension*sqrt(3)/6;...
                            -module.dimension/2,    -module.dimension*sqrt(3)/6];
        module.shape = 'triangle';

    % Square shaped module
    elseif (nsides == 4) % || strcmp(nsides,'square'))
        module.dimension = mdimension;
        module.perimeter = [-module.dimension/2,    module.dimension/2;...
                            module.dimension/2,     module.dimension/2;...
                            module.dimension/2,     -module.dimension/2;...
                            -module.dimension/2,    -module.dimension/2];
        module.shape = 'square'; % to demonstrate it was automatically generated

    % Hexagon shaped module
    elseif (nsides == 6) % || strcmp(nsides,'hexagon'))
        module.dimension = mdimension;
        module.perimeter = [0,                          module.dimension;...
                            module.dimension*cosd(30),  module.dimension*sind(30);...
                            module.dimension*cosd(30),  -module.dimension*sind(30);...
                            0,                          -module.dimension;
                            -module.dimension*cosd(30), -module.dimension*sind(30);...
                            -module.dimension*cosd(30), module.dimension*sind(30);];
        module.shape = 'hexagon';
    end
    
% If the input is a special case defined by a string
elseif( isstring(nsides) )
    if(strcmp(nsides, 'MOBI'))
        module.dimension = mdimension;
        module.perimeter = [-module.dimension/2,    0;...
                            0,                      (module.dimension/2)*sqrt(3);...
                            module.dimension/2,     0;...
                            0,                      -(module.dimension/2)*sqrt(3)];
        module.shape = 'diamond';
    end
    
% other shapes or number of sides
else
    disp('createModule can only be used with 3,4,6 sided regular polygons');
end


end

