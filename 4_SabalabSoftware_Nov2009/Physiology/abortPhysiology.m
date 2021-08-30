function abortPhysiology
	global state gh physOutputDevice physAuxOutputDevice physInputDevice

	state.phys.internal.abort=1;

	inputRunning=0;
	if ~strcmp(physInputDevice.Running, 'Off')
		stop(physInputDevice);
		inputRunning=1;
	end

	outputRunning=0;
	if ~strcmp(physOutputDevice.Running, 'Off')
		outputRunning=1;
		stop(physOutputDevice);
	end

	if ~isempty(state.phys.daq.auxOutputBoardIndex) && any(state.cycle.lastUsedAuxPulses)
		if ~strcmp(physAuxOutputDevice.Running, 'Off')
			auxOutputRunning=1;
			stop(physAuxOutputDevice);
		end
		while ~strcmp(physAuxOutputDevice.Running, 'Off')
			pause(0.001);
		end	
		if get(physAuxOutputDevice, 'SamplesAvailable')>0
			flushPhysAuxData;
		end
	end
		
	while ~strcmp([physInputDevice.Running physOutputDevice.Running], ...
		['Off' 'Off']);
		pause(0.001);
	end	

	if get(physOutputDevice, 'SamplesAvailable')>0
		flushPhysData;
	end

	if inputRunning
		flushdata(physInputDevice);
	end

	set(gh.physControls.startButton, 'String', 'GRAB');
	set(gh.physControls.liveModeButton, 'String', 'live');	
	pause(0.001);
	set(gh.physControls.startButton, 'Enable', 'on');
	set(gh.scope.start, 'Enable', 'on');
    
	setPhysStatusString('Ready');	
	timerSetPackageStatus(0, 'Physiology');
	timerCheckIfAllAborted;
	state.phys.internal.runningMode=0;