function FLIM_SetPage (m,pageNumber)
% gy multiboard modified 201202
% m is FLIM module number, from state.spc.acq.modulesInUse

out1=calllib('spcm32','SPC_set_page',m,pageNumber);

if out1 ~= 0
    error = FLIM_get_error_string (out1);    
    disp(['Set page error:', error]);
end