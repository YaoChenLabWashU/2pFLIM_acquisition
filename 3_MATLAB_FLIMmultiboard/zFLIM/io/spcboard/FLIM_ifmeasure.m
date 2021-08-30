function measure = FLIM_ifmeasure(m)
% gy multiboard modified 201202
% m is FLIM module number, from state.spc.acq.modulesInUse
status=0;
[out status]=calllib('spcm32','SPC_test_state',m,status);
a=dec2bin(double(status));
a = ['0000000000000000000', a];
measure = num2str(a(end-6));