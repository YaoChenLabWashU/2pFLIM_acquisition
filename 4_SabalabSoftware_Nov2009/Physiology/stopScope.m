function stopScope(update)
	global state gh

	if nargin<1
		update=1;
	end
	
	inputRunning=0;
	if ~strcmp(state.phys.daq.scopeInputDevice.Running, 'Off')
		stop(state.phys.daq.scopeInputDevice);
		inputRunning=1;
	end
		
	outputRunning=0;
	if ~strcmp(state.phys.daq.scopeOutputDevice.Running, 'Off')
		stop(state.phys.daq.scopeOutputDevice);
		outputRunning=1;
	end

	while ~strcmp([state.phys.daq.scopeInputDevice.Running state.phys.daq.scopeOutputDevice.Running], ...
		['Off' 'Off']);
		pause(0.001);
	end	
	
	if get(state.phys.daq.scopeOutputDevice, 'SamplesAvailable')>0
		flushScopeData;
	end
	
	if inputRunning
		flushdata(state.phys.daq.scopeInputDevice);
	end
	
	if update
		set(gh.scope.start, 'String', 'Start');
		set(gh.scope.start, 'Enable', 'on');
		
		if ~state.cycle.loopingStatus
			set(gh.physControls.startButton, 'Enable', 'on');
			set(gh.physControls.liveModeButton, 'Enable', 'on');			
		end
		setPhysStatusString('Ready');	
	end
	timerReleasePause('Physiology')