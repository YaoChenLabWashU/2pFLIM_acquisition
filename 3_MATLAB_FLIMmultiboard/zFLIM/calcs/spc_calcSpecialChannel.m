function spc_calcSpecialChannel(chan)
% called to calculate special channels 5 or 6
% right now, only from spc_redrawSetting and timerProcess_zFLIM

global state spc gui

% if we're called, it means that this channel is enabled for both
% calculation and display
% need to:  calculate appropriately
%           populate spc.projects{chan}

switch chan
    case 5   % make this one sum of 1+2
        src1=1;
        src2=2;
    case 6
        src1=3;
        src2=4;
    otherwise
        disp(['spc_calcSpecialChannel ERROR ' num2str(chan)]);
        return
end
% flag the dependency, for later use
spc.fits{src1}.dependentChan=chan;
spc.fits{src2}.dependentChan=chan;
% and calculate the needed sum 
spc.projects{chan}=spc.projects{src1}+spc.projects{src2};
spc.switchess{chan}.figOffset=0;  % for ROI calcs

% take care of default Lifetime Map values here (first time only)
try
    x=spc.switchess{chan}.lifeLimitUpper;
catch
    spc.fits{chan}=spc.fits{src1};
    spc.switchess{chan}.lifeLimitUpper=spc.switchess{src1}.lifeLimitUpper;
    spc.switchess{chan}.lifeLimitLower=spc.switchess{src1}.lifeLimitLower;
    spc.switchess{chan}.LutLower=spc.switchess{src1}.LutLower;
    spc.switchess{chan}.LutUpper=spc.switchess{src1}.LutUpper;
    spc.switchess{chan}.drawPopulation=0;
    spc_updateGUIbyGlobal('spc.switchess',chan,'lifeLimitLower');
    spc_updateGUIbyGlobal('spc.switchess',chan,'lifeLimitUpper');
    spc_updateGUIbyGlobal('spc.switchess',chan,'LutLower');
    spc_updateGUIbyGlobal('spc.switchess',chan,'LutUpper');
    spc_updateGUIbyGlobal('spc.switchess',chan,'drawPopulation');
end
