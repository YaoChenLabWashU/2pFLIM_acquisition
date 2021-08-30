function phLiveModeButtonPressed
	global state gh
	
	buttonString=get(gh.physControls.liveModeButton, 'String');
	if strcmp(buttonString, 'live')
		set(gh.physControls.liveModeButton, 'String', 'abort');
		timerCallPackageFunctions('FirstSetup', 'Physiology');
		
		state.phys.internal.runningMode=1;
		timerCallPackageFunctions('Setup', 'Physiology');

		state.phys.internal.forceTrigger=1;
	
		timerCallPackageFunctions('Start', 'Physiology');
		set(gh.physControls.startButton, 'Enable', 'on');
		triggerPhys;		
	elseif strcmp(buttonString, 'stop')
		state.phys.internal.stopInfiniteAcq=1;		
	else
		state.phys.internal.abort=1;
	    timerCallPackageFunctions('Abort', 'Physiology');
	end
	
	