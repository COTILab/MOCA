function [probe] = getBrainSensitivity(probe)
%GETBRAINSENSITIVITY Summary of this function goes here
%   Detailed explanation goes here

% only get BS for long separation channels. Ignore short separation
% channels, and channels above the sdrange.  Since, according to the
% workflow, we can only get BS if we have already ran channel analysis,
% lets just use probe.results.lschannels. 
sdseparation = probe.results.lschannels;
brainsensitivity = sdseparation;
for i=1:size(sdseparation,1)
    brainsensitivity(i,1) = lookupBS(sdseparation(i,1));
end
probe.results.brainsensitivity = brainsensitivity;

% Also get brain sensitivity for only inter and intra module channels
% INTRA
intrasdidx = probe.results.intrachannels(:,1) >= probe.sdrange(1); % intra channel idx above sdrange(1)
intrasd = probe.results.intrachannels(intrasdidx, :); % intra channel above sdrange(1). Already limited to <sdrange(2) in getChannelData.m
intrabrainsensitivity = intrasd;
for i=1:size(intrasd,1)
    intrabrainsensitivity(i,1) = lookupBS(intrasd(i,1));
end
probe.results.intrabrainsensitivity = intrabrainsensitivity;

% INTER
intersdidx = probe.results.interchannels(:,1) >= probe.sdrange(1); % intra channel idx above sdrange(1)
intersd = probe.results.interchannels(intersdidx, :); % intra channel above sdrange(1). Already limited to <sdrange(2) in getChannelData.m
interbrainsensitivity = intersd;
for i=1:size(intersd,1)
    interbrainsensitivity(i,1) = lookupBS(intersd(i,1));
end
probe.results.interbrainsensitivity = interbrainsensitivity;


end

