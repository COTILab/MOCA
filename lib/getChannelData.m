function [probe] = getChannelData(probe)
%GETCHANNELDATA Summary of this function goes here
%   Detailed explanation goes here


% WITHOUT sdrange DEFINED, ONLY CALCULATE THESE
% fullchannels (all) [sep srcid detid srcmodid detmodid]
% fullintrachannels (channels within modules)
% fullinterchannels (channels with optodes on diff modules)

probe = getSDSeparations(probe);







% IF sdrange IS DEFINED, CALCULATE THESE TOO
% channels (all, limited to sdrange(2) inclusive)
% intrachannels (channels within modules)
% interchannels (channels with optodes on diff modules)
% sschannels (channels below sdrange(1), exclusive)
% lschannels (channels within sdrange)
% exchannels (excluded channels due to sdrange. channels above sdrange(2))





end

