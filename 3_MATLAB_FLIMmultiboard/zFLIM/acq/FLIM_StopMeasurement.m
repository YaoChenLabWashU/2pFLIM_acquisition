function error1 = FLIM_StopMeasurement(m)
% gy multiboard modified 201202
% m is FLIM module number, from state.spc.acq.modulesInUse

global state;

error1 = 0;
state.spc.internal.ifstart = 0;
out1=calllib('spcm32','SPC_stop_measurement',m);
if out1 < 0
    %Try again!!
    j = 0;
    while out1 < 0 && j < 25 
        out1=calllib('spcm32','SPC_stop_measurement',m);
        j = j+1;
    end
    if out1 < 0
        error = FLIM_get_error_string (out1);    
        disp(['Error during stop measurement:', error]);
        error1 = 1;
    end
else
    
end