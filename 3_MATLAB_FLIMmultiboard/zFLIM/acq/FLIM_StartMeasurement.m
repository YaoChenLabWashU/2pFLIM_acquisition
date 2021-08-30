function FLIM_StartMeasurement(m)
% gy multiboard modified 201202
% m is FLIM module number, from state.spc.acq.modulesInUse

global state;
% if (state.spc.acq.SPCdata.mode == 2 | state.spc.acq.SPCdata.mode == 3)
%     status = 0;
%     [out1, status]=calllib('spcm32', 'SPC_get_scan_clk_state',state.spc.acq.module,status);
%     if (out1 ~= 0)
%         error = FLIM_get_error_string (out1);
%         disp(['error during scanning check:', error]);
%     else
%         status
%     end
% end

state.spc.internal.ifstart = 1;
out1=calllib('spcm32','SPC_start_measurement',m);
if out1 ~= 0
    error = FLIM_get_error_string (out1);    
    disp(['Error during start measurement:', error]);
end
% a = FLIM_ifarmed;
% if a
%     disp('Starting FLIM')
% else
%     disp('Error in starting FLIM')
% end
if ~FLIM_ifarmed(m)
    pause(0.2);
    if ~FLIM_ifarmed(m)
        error = 1;
        disp('Error in starting FLIM');
    end
end