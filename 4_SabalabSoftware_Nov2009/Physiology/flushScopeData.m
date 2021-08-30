function flushScopeData
	global state
	
%	putdata(state.phys.daq.scopeOutputDevice, zeros(100,1));
	try
		start(state.phys.daq.scopeOutputDevice);
		stop(state.phys.daq.scopeOutputDevice);
%	triggerPhys;
		while ~strcmp(state.phys.daq.scopeOutputDevice.Running, 'Off');
			pause(.001);
		end
	catch
	end
