function spc_rangeIntoGlobal(range,chan,guiFlag)
% updates spc.fits{chan} with scaled beta; if guiFlag, update GUI
global spc
% guiFlag is optional; defaults to 0
if nargin<3
    guiFlag=0;
end

nsPerPoint=spc.datainfo.psPerUnit/1000;

srange=range*nsPerPoint;

spc.fits{chan}.fitstart=srange(1);
spc.fits{chan}.fitend=srange(2);

if guiFlag % && chan==spc_mainChannelChoice
    spc_updateGUIbyGlobal('spc.fits',chan,'fitstart');
    spc_updateGUIbyGlobal('spc.fits',chan,'fitend');
end
