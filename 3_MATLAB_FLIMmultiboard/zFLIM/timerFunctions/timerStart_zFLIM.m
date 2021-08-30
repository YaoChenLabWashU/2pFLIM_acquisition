function timerStart_zFLIM
global state
% The following group of commands was moved from timerSetup_zFLIM
% this will allow a 'restart' of acquisition, in the way that 
% (imaging) endAcquisition re-calls timerStart_Imaging for each level of a
% z-stack
%
% GY:  FROM function FLIM_Measurement(hObject,handles)
% GY:  We'll do without the mt timer (updates time display)

% gy multiboard modified 201202
for m=state.spc.acq.modulesInUse
    FLIM_StopMeasurement(m);  
    FLIM_ConfigureMemory(m);
    FLIM_SetPage(m,0);
    FLIM_FillMemory(m,-1);  %-1 is for all pages
	% FLIM_enable_sequencer(m,1); % removed gy 201204 - not needed in 
	% scan sync in mode (and in fact this doubles the memory usage!)
end

% GY 20110125  
global spc
spc.imageMod = [];  % clear these to start
spc.lifetime=[];
spc.project=[];
spc.errCode=999;

% now arm the module - it will acquire when triggered by the line clock
% (pcell waveform)
% gy multiboard modified 201202
for m=state.spc.acq.modulesInUse
    FLIM_StartMeasurement(m);  % arms the module
end
timerSetPackageStatus(1, 'zFLIM');
