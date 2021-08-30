function filled = FLIM_ifmemoryfilled(m)
% gy multiboard modified 201202
% m is FLIM module number, from state.spc.acq.modulesInUse

status=0;
[out status]=calllib('spcm32','SPC_test_state',m,status);

if status<0
	pause(0.2);
	[out status]=calllib('spcm32','SPC_test_state',m,status);
end 
	
a=dec2bin(double(status));

a = ['0000000000000000000', a];
    
Notfilled = num2str(a(end-13));

if Notfilled == 1
    filled = 0;
else
    filled = 1;
end