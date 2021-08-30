function phGrabButtonPressed
	global state gh
	
	buttonString=get(gh.physControls.startButton, 'String');
	if strcmp(buttonString, 'GRAB')
		if ~savingInfoIsOK(1)
			return
		end	

		state.phys.internal.runningMode=0;
		
		timerCallPackageFunctions('FirstSetup', 'Physiology');
		timerCallPackageFunctions('Setup', 'Physiology');

		state.phys.internal.forceTrigger=1;

		timerCallPackageFunctions('Start', 'Physiology');
		set(gh.physControls.startButton, 'Enable', 'on');
		triggerPhys;
	elseif strcmp(buttonString, 'end acq')
		state.phys.internal.stopInfiniteAcq=1;		
	else
		state.phys.internal.abort=1;
        timerCallPackageFunctions('Abort', 'Physiology');
	end