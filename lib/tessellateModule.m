function [probe] = tesselateModule( probe )
%TESSELATEMODULE Summary of this function goes here
%   Detailed explanation goes here



if (strcmp(probe.module.shape, 'square'))   
    single_row_quantities = probe.n_modules_x;
    n_modules = probe.n_modules_x * probe.n_modules_y;
    centroids = zeros(n_modules, 2); % x,y coordinates of centroid
    count = 0;
    for row=1:probe.n_modules_y
        for col=1:probe.n_modules_x
            x = (probe.module.dimension/2) + ((col-1)*probe.module.dimension);
            y = (probe.module.dimension/2) + ((row-1)*probe.module.dimension);
            count=count+1;
            centroids(count,:) = [x,y];
        end
    end
end


% Update probe values
probe.n_modules = n_modules;
probe.centroids = centroids;
probe.single_row_quantities = single_row_quantities; 
    
    
end

