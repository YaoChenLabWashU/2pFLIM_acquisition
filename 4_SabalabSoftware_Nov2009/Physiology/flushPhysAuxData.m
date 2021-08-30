function flushPhysAuxData
	global physAuxOutputDevice physAuxOutputDevice

	try
			
		start(physAuxOutputDevice);
		stop(physAuxOutputDevice);
	
		while ~strcmp(physAuxOutputDevice.Running, 'Off');
			pause(.001);
		end
	catch
		disp('flushPhysAuxData: Error.  Assume aborted.');
	end
