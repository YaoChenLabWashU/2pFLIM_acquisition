function flushPhysData
	global state physOutputDevice
	
	try
		if get(physOutputDevice, 'SamplesAvailable')>0
			start(physOutputDevice);
			stop(physOutputDevice);
	
			while ~strcmp(get(physOutputDevice, 'Running'), 'Off')
				pause(.001);
			end
		end
	catch
		disp(['flushPhysData: ' lasterr]);
	end
