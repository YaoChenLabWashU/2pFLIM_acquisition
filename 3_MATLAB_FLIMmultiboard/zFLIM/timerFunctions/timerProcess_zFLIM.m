function timerProcess_zFLIM
% modified gy multiboard 201202
% after all frames and zSlices collected, save FLIM data, then auto fit (and export to Excel) if requested
global state spc gui gh

% clean up things that apply only during FLIM acquisition
resetRFswitches; % if they're in use
% gy modified for dualLaserMode 201204 
if state.acq.dualLaserMode==2
    for m=state.spc.acq.modulesInUse
        % undo the setting that was made in timerStart_zFLIM
        state.spc.acq.SPCdata{m+1}.scan_size_y=state.acq.linesPerFrame;
        FLIM_setParameters(m);
        FLIM_getParameters(m);
    end
end

% GY: for DEBUG
% FLIM_decode_test_state(1);
% END GY: for DEBUG


% set up datainfo structure
spc.datainfo=[];  %GY 20110124 clear it out first
spc.datainfo.multiPages.timing = 0;
spc.datainfo.multiPages.nPages = 0;
spc.datainfo.multiPages.page = 0;
spc.datainfo.multiPages.pageTime = 0;
spc.datainfo.numberOfZSlices=state.acq.numberOfZSlices;
spc.datainfo.numberOfFrames=state.acq.numberOfFrames; 
% added gy 201112 with alterations to FLIMgui and endAcquisition
%  specifying how to replace ScanImage imageData with spc data
spc.datainfo.imageChannel1content=state.spc.acq.imageChannel1content;
spc.datainfo.imageChannel1divN=state.spc.acq.imageChannel1divN;
spc.datainfo.imageChannel2content=state.spc.acq.imageChannel2content;
spc.datainfo.imageChannel2divN=state.spc.acq.imageChannel2divN;
spc.datainfo.imageChannel4content=state.spc.acq.imageChannel4content;
spc.datainfo.imageChannel4divN=state.spc.acq.imageChannel4divN;
spc.datainfo.imageScale=state.spc.acq.imageScale;
% end mod gy 201112
spc.page = 0;
% multiboard:  these new parameters saved in datainfo
spc.datainfo.modulesInUse=state.spc.acq.modulesInUse;
spc.datainfo.modChans=state.spc.acq.modChans;
spc.datainfo.channelDefs=state.spc.acq.channelDefs;
% multiboard:  these parameters always taken from the first module
scan_size_y = state.spc.acq.SPCdata{state.spc.acq.modulesInUse(1)+1}.scan_size_y;
scan_size_x = state.spc.acq.SPCdata{state.spc.acq.modulesInUse(1)+1}.scan_size_x;
res = 2^state.spc.acq.SPCdata{state.spc.acq.modulesInUse(1)+1}.adc_resolution;
% multiboard:  for analysis convenience, this only gets board 1 parameters
spc.SPCdata = state.spc.acq.SPCdata{state.spc.acq.modulesInUse(1)+1};
%spc.size = [res, scan_size_x, scan_size_y]; %ryohei commented this out
spc.size = [res, scan_size_y, scan_size_x];
spc.switches.peak = [-1, 4];
try 
    limit = spc.switches.lifetime_limit; 
catch
    limit = [2.4, 3.4];
end
try 
    range = spc.fits{1}.range; 
catch
    range = [1, res];
end
spc.switches.lifetime_limit = limit;
spc.fit.background = 0;
spc.switches.imagemode = 1;
spc.switches.logscale = 1;
spc.fit.range = range;
% set a bunch more stuff in datainfo
spc.datainfo.time = datestr(clock, 13);
spc.datainfo.date = datestr(clock, 1);
spc.datainfo.adc_re = res;
% for multiFLIM
spc.datainfo.FLIMchoices=state.spc.FLIMchoices;
% most of the FLIM board parameters are stored in spc.SPCdata

spc.datainfo.laser.power=state.pcell.pcellScanning1;
try 
    spc.datainfo.laser.wavelength=state.laser.wavelength;
end
try
    spc.datainfo.triggerTime = state.spc.acq.triggerTime;
catch
    spc.datainfo.triggerTime = datestr(now);
end

% spc.datainfo.psPerUnit = spc.datainfo.tac_r/spc.datainfo.tac_g/spc.datainfo.adc_re*1e12;
% multiboard - from first module
spc.datainfo.psPerUnit = state.spc.acq.SPCdata{state.spc.acq.modulesInUse(1)+1}.tac_range ...
    /state.spc.acq.SPCdata{state.spc.acq.modulesInUse(1)+1}.tac_gain/res * 1000;
% spc.datainfo.pulseInt = 12.58;  % GY: what is this?? inverse of laser rate??
spc.datainfo.pulseInt = 1E9/state.spc.internal.syncRate;  % GY 201101
if (spc.errCode~=0)
    error = FLIM_get_error_string (spc.errCode);
    disp(['error during reading data:', error]);
    return;
end

% spc.imageMod = image1; 
% END of imported (subset of) code from FLIM_imageAcq
%spc_redrawSetting(1);  % GY: follows call to FLIM_imageAcq in FLIM_Measurement


% gy 201111:  This replaces the call to spc_redrawSetting
global FLIMchannels
for fc=FLIMchannels  
    if bitget(state.spc.FLIMchoices(fc),3)
        % calculate a channel (sum) if needed
        spc_calcSpecialChannel(fc);
    end
    axes(gui.spc.projects{fc}.axes);
    set(gui.spc.projects{fc}.projectImage, 'CData', spc.projects{fc});
end
for chan=FLIMchannels
    spc_drawAll(chan, 1, 1); % recalcs lifetime maps
end
spc_calculateROIvals(0);



% GY:  TEMPORARY (?) SAVE CODE
str1 = '000';
str2 = num2str(state.files.lastAcquisition);
str1(end-length(str2)+1:end) = str2;
spc.filename = [state.files.savePath state.files.baseName 'FLIM' str1 '.mat'];



% save(spc.filename,'spc');  %save the SPC structure (includes data)

% GY 201012 - more frugal - save only the key parts of the SPC structure
spcSave.filename=spc.filename;
% gy 201111 multiFLIM changes
spcSave.imageMods=spc.imageMods;
spcSave.imageModSlices=spc.imageModSlices;  % now that we do zStacks
spcSave.lifetimes=spc.lifetimes;
% don't save calc'ed channels
FLIMacq=find(bitget(state.spc.FLIMchoices,2));
spcSave.projects=spc.projects(FLIMacq);  % NOW we do save projections 201111
  % as of 201111, these are max projections across the zSlice
  % but NOT divided by the number of frames
spcSave.fits=spc.fits(FLIMacq);
spcSave.switchess=spc.switchess;
spcSave.switches=spc.switches;
% end changes for multiFLIM 201111

spcSave.datainfo=spc.datainfo;
spcSave.SPCdata=spc.SPCdata;
spcSave.size=spc.size;

% multiboard - for correct archiving, save the additional board parameter
%   if it exists, in a special variable
if size(state.spc.acq.modulesInUse)>1
    spcSave.SPCdataMulti=state.spc.acq.SPCdata; %
end
save(spc.filename,'spcSave');  %save the SPC structure (includes data)
set(gui.spc.spc_main.File_N,'String',str1);  % update file number display
spc_updateGUIbyGlobal('spc.filename');

% update the spc_main file info, should we wish to browse back
gui.gy.filename.path = state.files.savePath;
gui.gy.filename.base = state.files.baseName;
gui.gy.filename.num = state.files.lastAcquisition;

spc_setupSliceChooser; % update current value of slice chooser (and choices)


if get(gui.spc.spc_main.fit_eachtime,'Value')
	try
		spc_autoDuringAcq;
	catch
		disp('spc_autoDuringAcq failed in ''timerProcess_zFLIM.m''');
	end
% 	try
% 		spc_auto(1, ~last_frame);
% 	catch
% 		disp('spc_auto failed in ''timerProcess_zFLIM.m''');
% 	end
end

%set(gh.spc.FLIMgui.status, 'String', 'Waiting for next operation');    
