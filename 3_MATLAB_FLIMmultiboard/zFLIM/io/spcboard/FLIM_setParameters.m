function FLIM_setParameters(module)
% modified gy 201202 multiboard

global state;

out1=calllib('spcm32','SPC_set_parameters',module,state.spc.acq.SPCdata{module+1});

if (out1~=0)
    error = FLIM_get_error_string (out1);    
    disp(['error during setting parameters:', error]);
end
