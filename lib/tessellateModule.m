function [probe] = tessellateModule( probe )
%TESSELATEMODULE Summary of this function goes here
%   Detailed explanation goes here



if (strcmp(probe.module.shape, 'square'))   
    single_row_quantities = probe.n_modules_x;
    n_modules = probe.n_modules_x * probe.n_modules_y;
    modules = zeros(n_modules, 4); % x_centroid,y_centroid, orientation, active
    count = 0;
    for row=1:probe.n_modules_y
        for col=1:probe.n_modules_x
            x = (probe.module.dimension/2) + ((col-1)*probe.module.dimension);
            y = (probe.module.dimension/2) + ((row-1)*probe.module.dimension);
            count=count+1;
            modules(count,:) = [x,y,0,1]; % x, y, orientation (deg), active
        end
    end
end


% Update probe values
probe.n_modules = n_modules;
probe.modules = modules;
probe.single_row_quantities = single_row_quantities; 
    
    
end

