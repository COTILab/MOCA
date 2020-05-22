function [probe] = rotateModules(probe, moduleidx, rotate_amount)
%ROTATEMODULES Summary of this function goes here
%   Rotates a modules within a probe layout by rotate_amount. Modules are
%   identified by their module idx. moduleidx can be a vector of module ids
%   in the probe. If moduleidx is empty (ie []), then the elementary
%   module, probe.module, is rotate.  Rotation of a module refers to the
%   rotation of its perimeter, its sources, and its detector.


% IF A SINGLE MODULE IS INPUTTED, ROTATE JUST THAT MODULE
if (isempty(moduleidx))    
    rperimeter = rotateCoordinates(probe.module.perimeter, rotate_amount);
    rsrcposns = rotateCoordinates(probe.module.srcposns, rotate_amount);
    rdetposns = rotateCoordinates(probe.module.detposns, rotate_amount);
    
    probe.module.perimeter = rperimeter;
    probe.module.srcposns = rsrcposns;
    probe.module.detposns = rdetposns;
    
    
% IF A PROBE IS INPUTTED, ROTATE THE LIST OF MODULES
else
    for i=1:size(moduleidx,2)
        % probe.modules = [x, y, rotatedangle, active]
        % probe.modules doesn't save the perimeter of a module, so all we
        % have to do is update the angle column so plotProbe.m know how to
        % orient each module when plotting. The reason the perimeter
        % coordinates are not saved is because the number of points that
        % make up a perimeter varies with the module shape.
        modulexy = probe.modules(moduleidx(i), 1:2); % current xy of centroid
        moduleangle = probe.modules(moduleidx(i), 3); % current angle
        modulestate = probe.modules(moduleidx(i), 4); % current state
        newangle = moduleangle + rotate_amount;
        probe.modules(moduleidx(i), :) = [modulexy(1), modulexy(2), newangle, modulestate];
        
        % srcposns and detposns are used directly in channel analysis.
        % Similarly, to use with other software, they need to know the xy
        % of each optode. Saving just the rotation angle isn't helpful.
        % Rather, we need to directly update the xy of each optode. 
        % probe.srcposns = [x, y, moduleid, srcid]
        srcposnsxy = probe.module.srcposns; % based on probe.module definition, NOT current srcposns
        rsrcposnsxy = rotateCoordinates(srcposnsxy, newangle); % rotate coors by inputted amount
        trsrcposnsxy = translateCoordinates(rsrcposnsxy, modulexy); % translate back to module centroid 
        srcposnsidx = probe.srcposns(:,3) == moduleidx(i); % find the sources on module moduleidx(i) that need to be updated
        probe.srcposns(srcposnsidx, 1:2) = trsrcposnsxy;  % update the coordinates of those sources only
        
        % repeat this process for detector as well. 
        % probe.detposns = [x, y, moduleid, detid]
        detposnsxy = probe.module.detposns; % based on probe.module definition, NOT current detposns
        rdetposnsxy = rotateCoordinates(detposnsxy, newangle); % rotate coors by inputted amount
        trdetposnsxy = translateCoordinates(rdetposnsxy, modulexy); % translate back to module centroid 
        detposnsidx = probe.detposns(:,3) == moduleidx(i); % find the sources on module moduleidx(i) that need to be updated
        probe.detposns(detposnsidx, 1:2) = trdetposnsxy;  % update the coordinates of those sources only 
        
    end
    
    
end

