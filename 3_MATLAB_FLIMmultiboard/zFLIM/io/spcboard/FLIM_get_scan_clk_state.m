function status = FLIM_get_scan_clk_state(m)
% gy multiboard modified 201202
% m is FLIM module number, from state.spc.acq.modulesInUse
status = 0;
[out status]=calllib('spcm32','SPC_get_scan_clk_state',m,status);