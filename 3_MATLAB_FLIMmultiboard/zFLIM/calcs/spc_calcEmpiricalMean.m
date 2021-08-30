function meanTau=spc_calcEmpiricalMean(chan)

global spc

% get a vector of the bin numbers in the fitting range
[~,range]=spc_fitParamsFromGlobal(chan);
t1 = (1:length([range(1):range(2)]));
t1 = t1(:);

% using the existing spc.lifetime (based on all pixels in the main ROI)
% limit the range to the fit range
lifetime = spc.lifetimes{chan}(range(1):range(2));
lifetime = lifetime(:);

% now integrate [nPhot*binNo]/totalPhotons, scaled by nS per bin
a = sum(lifetime.*t1)/sum(lifetime)*spc.datainfo.psPerUnit/1000;

% then subtract the offset
meanTau=a-spc.switchess{chan}.figOffset; % str2double(get(handles.F_offset,'String'));