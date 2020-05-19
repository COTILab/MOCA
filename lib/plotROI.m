function [] = plotROI(design)
%PLOTROI Plots the perimeter of the ROI
%   

if( isfield(design, 'roi'))
    figure
    hold on

    % Add the first xy coordinate to the matrix
    first_xycoor = design.roi(1,:);  
    perimeter_coors = [design.roi; first_xycoor];

    % Plot the perimeter. 
    plot(perimeter_coors(:,1), perimeter_coors(:,2), 'k','LineWidth',2); 
    axis equal

    % Title the plot
    title('Design of ROI Geometry')
    xlabel('Position [mm]')
    ylabel('Position [mm]')
    axis equal
end

end

