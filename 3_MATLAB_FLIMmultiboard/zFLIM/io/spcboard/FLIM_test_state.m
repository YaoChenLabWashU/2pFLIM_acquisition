function status = FLIM_test_state(m)
% m is module number

status=0;
[out status]=calllib('spcm32','SPC_test_state',m,status);
