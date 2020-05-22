function [rotatedxys] = rotateCoordinates(xys, rotate_amount)
%ROTATECOORDINATES Summary of this function goes here
%   Rotates a set of xy coordinates by an angle rotate_amount.
%   Rotate_amount is in degrees. 

theta = rotate_amount; % degrees

% Create rotation matrix
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
% Rotate your point(s)
for i=1:size(xys,1)
    rotatedxys(i,:) = (R * xys(i,:)')';
end


end

