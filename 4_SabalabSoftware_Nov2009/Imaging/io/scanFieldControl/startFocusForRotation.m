function startFocusForRotation
	global state
	global focusInput
	
	if get(focusInput, 'SamplesAvailable')>0 
		try
			flushData(focusInput);
		catch
			disp(['startFocusForRotation: ' lasterr]);
		end
	end

	putDataFocus;
	
	resetCounters;
	state.internal.abortActionFunctions=0;	
	startFocus;

	
	