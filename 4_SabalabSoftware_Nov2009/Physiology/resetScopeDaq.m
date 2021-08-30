function resetScopeDaq

	global state
	if state.analysisMode
		return
	end
	if size(get(state.phys.daq.scopeOutputDevice, 'Channel'),1)>0
		delete(state.phys.daq.scopeOutputDevice.Channel);
	end
	state.phys.daq.scopeOutputChannel = addchannel(state.phys.daq.scopeOutputDevice, state.phys.scope.channel);
	set(state.phys.daq.scopeOutputChannel, 'OutputRange', [-10 10]);
	set(state.phys.daq.scopeOutputChannel, 'UnitsRange', [-10 10]);

	if size(get(state.phys.daq.scopeInputDevice, 'Channel'),1)>0
		delete(state.phys.daq.scopeInputDevice.Channel);
	end
	state.phys.daq.scopeInputChannel  = addchannel(state.phys.daq.scopeInputDevice, state.phys.scope.channel);
	set(state.phys.daq.scopeInputChannel, 'InputRange', [-10 10]);
	set(state.phys.daq.scopeInputChannel, 'SensorRange', [-10 10]);
	set(state.phys.daq.scopeInputChannel, 'UnitsRange', [-10 10]);
	set(state.phys.daq.scopeInputDevice, 'SamplesAcquiredFcnCount', ...
		round(state.phys.scope.actualInputRate/state.phys.scope.actualOutputRate*size(state.phys.scope.output,1))); 
	set(state.phys.daq.scopeInputDevice, 'SamplesPerTrigger', ...
		round(state.phys.scope.actualInputRate/state.phys.scope.actualOutputRate*size(state.phys.scope.output,1)));

	flushdata(state.phys.daq.scopeInputDevice);

	