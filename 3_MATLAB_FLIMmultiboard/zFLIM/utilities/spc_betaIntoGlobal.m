function spc_betaIntoGlobal(beta,chan,guiFlag)
% updates spc.fits{chan} with scaled beta; if guiFlag, update GUI
global spc
% guiFlag is optional; defaults to 0
if nargin<3
    guiFlag=0;
end

nsPerPoint=spc.datainfo.psPerUnit/1000;

if findstr('prf',spc.fits{chan}.lastFitFunction)
    % beta6 is scatter
    sbeta=beta(:).*[1 nsPerPoint 1 nsPerPoint nsPerPoint 1]';
else % beta6 is gauss width
    sbeta=beta(:).*[1 nsPerPoint 1 nsPerPoint nsPerPoint nsPerPoint]';
end

for k=1:6
    fName=['beta' num2str(k)];
    spc.fits{chan}.(fName)=sbeta(k);
    if guiFlag && chan==spc_mainChannelChoice
        spc_updateGUIbyGlobal('spc.fits',chan,fName);
    end
end

% save background correction, if it was used  (gy 201207)
if isfield(spc.fit,'backCorr')
    spc.fits{chan}.backCorr=spc.fit.backCorr;
end
