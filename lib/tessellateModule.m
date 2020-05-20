function [probe] = tessellateModule( probe )
%TESSELATEMODULE Summary of this function goes here
%   Detailed explanation goes here



if (strcmp(probe.module.shape, 'square'))   
    single_row_quantities = probe.n_modules_x;
    n_modules = probe.n_modules_x * probe.n_modules_y;
    
    modules = zeros(n_modules, 4); % x_centroid,y_centroid, orientation, active
    allsrcs = zeros(size(probe.module.srcposns(:,1), 1) * n_modules, 3); % x,y,moduleIdx
    alldets = zeros(size(probe.module.detposns(:,1), 1) * n_modules, 3); % x,y,moduleIdx
    
    modcount = 1;
    srccount = 1;
    detcount = 1;
    for row=1:probe.n_modules_y
        for col=1:probe.n_modules_x
            % Find dimensions of the centroid, adjusting for probe.spacing
            x = (probe.module.dimension/2) + ((col-1)*probe.module.dimension) + ((col-1)*probe.spacing);
            y = (probe.module.dimension/2) + ((row-1)*probe.module.dimension) + ((row-1)*probe.spacing);
            
            % Save orientation of individual module (deg)
            orientation = 0;
            
            % Save whether module is active or inactive
            active = 1;
            
            % translate and rotate sources. Save which module idx they
            % belong to
            nsrcs = size(probe.module.srcposns(:,1), 1);
            translatedsrcs = translateCoordinates(probe.module.srcposns, [x,y]);
            moduleidxsrcs = ones(nsrcs,1)*modcount;
            allsrcs(srccount:srccount+nsrcs-1,:) = [translatedsrcs, moduleidxsrcs];
            srccount = srccount+nsrcs;
            
            % translate and rotate detectors. Save which module idx they
            % belong to
            ndets = size(probe.module.detposns(:,1), 1);
            translateddets = translateCoordinates(probe.module.detposns, [x,y]);
            moduleidxdets = ones(ndets,1)*modcount;
            alldets(detcount:detcount+ndets-1,:) = [translateddets, moduleidxdets];
            detcount = detcount+ndets;
            
            % Save the module
            modules(modcount,:) = [x,y,orientation,active]; % x, y, orientation (deg), active
            modcount = modcount+1;
        end
    end
end


% Update probe values
%probe.n_modules = n_modules;
probe.modules = modules;
%probe.single_row_quantities = single_row_quantities;

probe.srcposns = allsrcs;
probe.detposns = alldets;
    
    
end

