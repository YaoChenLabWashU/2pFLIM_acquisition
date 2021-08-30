function out = FLIM_enable_sequencer (m,enable)
% gy multiboard modified 201202
% m is FLIM module number, from state.spc.acq.modulesInUse

out = calllib('spcm32', 'SPC_enable_sequencer', m, enable);
if (out~=0)
    error = FLIM_get_error_string (out);    
    disp(['error during enabling sequencer:', error]);
end