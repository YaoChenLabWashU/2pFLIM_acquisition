function stopAndRestartFocus
	global state

	state.internal.pauseAndRotate=0;

	global focusInput focusOutput pcellFocusOutput
	deviceList=[focusInput focusOutput];
	if state.pcell.pcellOn
		deviceList(end+1)=pcellFocusOutput;
	end
	
	stop(deviceList);
	while ~any(strcmp(get(deviceList, 'Running'), 'Off'))
		pause(0.01);
	end	
	
	setPcellsToDefault
	flushFocusData;

	if get(focusInput, 'SamplesAvailable')>0
		try
			flushdata(focusInput);
		catch
			disp(lasterr);
		end
	end

	putDataFocus;
	
    pause(0.02)

    state.internal.stripeCounter=0;
	state.internal.frameCounter = 0;
	updateGUIByGlobal('state.internal.frameCounter');
	
	startFocus;


	