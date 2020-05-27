function [probe] = translateModule(probe, moduleidx, translate_amount)
%TRANSLATEMODULE Translates a module within a probe in x and y
%   Detailed explanation goes here


optexist = true;    % flag to determine if optodes were defined. 
if( isfield(probe.module, 'srcposns') == false )
    optexist = false;
end


for i=1:size(moduleidx,2)
        % probe.modules = [x, y, rotatedangle, active]
        % probe.modules doesn't save the perimeter of a module, so all we
        % have to do is update the x,y columns so plotProbe.m knows where to
        % place each module when plotting. The reason the perimeter
        % coordinates are not saved is because the number of points that
        % make up a perimeter varies with the module shape.
        modulexy = probe.modules(moduleidx(i), 1:2); % current xy of centroid
        moduleangle = probe.modules(moduleidx(i), 3); % current angle
        modulestate = probe.modules(moduleidx(i), 4); % current state
        newxy = translateCoordinates(modulexy, translate_amount);
        probe.modules(moduleidx(i), :) = [newxy(1), newxy(2), moduleangle, modulestate];
        
        % if optodes were defined, rotate them too
        if (optexist)
            % srcposns and detposns are used directly in channel analysis.
            % Similarly, to use with other software, they need to know the xy
            % of each optode. Saving just the rotation angle isn't helpful.
            % Rather, we need to directly update the xy of each optode. 
            % probe.srcposns = [x, y, moduleid, srcid]
            srcposnsxy = probe.srcposns; % based on probe.module definition, NOT current srcposns
            newsrcposnsxy = translateCoordinates(srcposnsxy(:,1:2), translate_amount); % translate the source xys
            srcposnsidx = probe.srcposns(:,3) == moduleidx(i); % find the sources on module moduleidx(i) that need to be updated
            probe.srcposns(srcposnsidx, 1:2) = newsrcposnsxy(srcposnsidx, 1:2);  % update the coordinates of those sources only

            % repeat this process for detector as well. 
            % probe.detposns = [x, y, moduleid, detid]
            detposnsxy = probe.detposns; % based on probe.module definition, NOT current detposns
            newdetposnsxy = translateCoordinates(detposnsxy(:,1:2), translate_amount); % translate back to module centroid 
            detposnsidx = probe.detposns(:,3) == moduleidx(i); % find the sources on module moduleidx(i) that need to be updated
            probe.detposns(detposnsidx, 1:2) = newdetposnsxy(detposnsidx, 1:2);  % update the coordinates of those sources only 
        end
        
    end

end

