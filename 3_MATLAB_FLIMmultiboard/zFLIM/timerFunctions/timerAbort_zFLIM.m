function timerAbort_zFLIM
global state
% zFLIM handling requested abort
timerSetPackageStatus(0, 'zFLIM');
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


