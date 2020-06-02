function [probe] = tessellateModule( probe )
%TESSELATEMODULE Summary of this function goes here
%   Detailed explanation goes here

optexist = true;    % flag to determine if optodes were defined. 
if( isfield(probe.module, 'srcposns') == false )
    optexist = false;
end

% SQUARE MODULES, or not defined
if ((isfield(probe.module, 'shape')==false) || strcmp(probe.module.shape, 'square'))
    single_row_quantities = probe.n_modules_x;
    n_modules = probe.n_modules_x * probe.n_modules_y;
    
    modules = zeros(n_modules, 4); % x_centroid,y_centroid, orientation, active
    if(optexist)
        allsrcs = zeros(size(probe.module.srcposns(:,1), 1) * n_modules, 4); % x,y,moduleIdx,globalsrcIdx
        alldets = zeros(size(probe.module.detposns(:,1), 1) * n_modules, 4); % x,y,moduleIdx,globaldetIdx
    end
    
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
            % Save the module
            modules(modcount,:) = [x,y,orientation,active]; % x, y, orientation (deg), active
            
            
            % translate and rotate sources, if they exist. Save which module idx they
            % belong to. give a unique id to each source
            if (optexist)
                nsrcs = size(probe.module.srcposns(:,1), 1);
                % rotatedsrcs = rotateCoordinates(probe.module.srcposns,
                % angle);
                translatedsrcs = translateCoordinates(probe.module.srcposns, [x,y]);
                moduleidxsrcs = modcount; 
                for s=1:nsrcs
                    allsrcs(srccount,:) = [translatedsrcs(s,:), moduleidxsrcs, srccount];
                    srccount = srccount+1;
                end

                % translate and rotate detectors. Save which module idx they
                % belong to. give a unique id to each detector
                ndets = size(probe.module.detposns(:,1), 1);
                translateddets = translateCoordinates(probe.module.detposns, [x,y]);
                moduleidxdets = modcount;
                for d=1:ndets
                    alldets(detcount,:) = [translateddets(d,:), moduleidxdets, detcount];
                    detcount = detcount+1;
                end
            end
            
            % increment module
            modcount = modcount+1;
            
        end
    end

% HEXAGON SHAPE
elseif (strcmp(probe.module.shape, 'hexagon'))   
    % always assume add_module = 1
    % if(add_module == 1);
    single_row_quantities = probe.n_modules_x;
    n_modules = probe.n_modules_x * probe.n_modules_y;
    
    modules = zeros(n_modules, 4); % x_centroid,y_centroid, orientation, active
    if(optexist)
        allsrcs = zeros(size(probe.module.srcposns(:,1), 1) * n_modules, 4); % x,y,moduleIdx,globalsrcIdx
        alldets = zeros(size(probe.module.detposns(:,1), 1) * n_modules, 4); % x,y,moduleIdx,globaldetIdx
    end
    
    modcount = 1;
    srccount = 1;
    detcount = 1;
    
    xdim = 2*probe.module.dimension*cosd(30); %module.dimension*cosd(30);
    ydim = probe.module.dimension;
    
    for row=1:probe.n_modules_y
        for col=1:probe.n_modules_x
            % Find dimensions of the centroid, adjusting for probe.spacing
            x = (probe.module.dimension/2) + ((col-1)*probe.module.dimension) + ((col-1)*probe.spacing);
            y = (probe.module.dimension/2) + ((row-1)*probe.module.dimension) + ((row-1)*probe.spacing);
            
            if(mod(row,2)==1)       %odd
                x = (xdim/2) + ((col-1)*xdim) + ((col-1)*probe.spacing);
                y = (ydim) + ((row-1)*1.5*ydim) + ((row-1)*probe.spacing);
            elseif (mod(row,2)==0)  %even
                x = (xdim) + ((col-1)*xdim) + ((col-1)*probe.spacing) + probe.spacing/2;
                y = (ydim) + ((row-1)*1.5*ydim) + ((row-1)*probe.spacing);
            end
            
            % Save orientation of individual module (deg)
            orientation = 0;
            % Save whether module is active or inactive
            active = 1;
            % Save the module
            modules(modcount,:) = [x,y,orientation,active]; % x, y, orientation (deg), active
            
            
            % translate and rotate sources, if they exist. Save which module idx they
            % belong to. give a unique id to each source
            
            
            % increment module
            modcount = modcount+1;
        end
    end
end


% Update probe values
probe.modules = modules;
if (optexist)
    probe.srcposns = allsrcs;
    probe.detposns = alldets;
end
    
    
end

