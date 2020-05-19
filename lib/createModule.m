function [modulegeometry] = createModule(nsides,mdimension)
%CREATEMODULE Automatically derive perimeter points of module
%   This is an automated function of MOCA meant to facilitate making a
%   regular shape. A regular shape is defined as equiangular and
%   equilateral. The first three regular polygons that can tessellate by
%   themselves are support (triangle, square, hexagon).


modulegeometry = [0 0; 4 0; 4 4; 0 4; 0 0];
end

