function initializeScopeDaq

	global state
	if state.analysisMode
		return
	end
	
	state.phys.daq.scopeOutputDevice = analogoutput('nidaq', state.phys.daq.outputBoardIndex);
	set(state.phys.daq.scopeOutputDevice, 'SampleRate', state.phys.scope.outputRate);
	state.phys.scope.actualOutputRate=get(state.phys.daq.scopeOutputDevice, 'SampleRate');
	set(state.phys.daq.scopeOutputDevice, 'TriggerType', 'HwDigital');		
	set(state.phys.daq.scopeOutputDevice, 'HwDigitalTriggerSource', 'RTSI1');
	set(state.phys.daq.scopeOutputDevice, 'TriggerCondition', 'PositiveEdge');


	state.phys.daq.scopeInputDevice = analoginput('nidaq', state.phys.daq.inputBoardIndex);
	set(state.phys.daq.scopeInputDevice, 'SampleRate', state.phys.scope.inputRate);
	state.phys.scope.actualInputRate=get(state.phys.daq.scopeInputDevice, 'SampleRate');
	set(state.phys.daq.scopeInputDevice, 'SamplesAcquiredFcn', {'processScopeData'});
	set(state.phys.daq.scopeInputDevice, 'TriggerType', 'Manual');
	set(state.phys.daq.scopeInputDevice, 'ExternalTriggerDriveLine', 'RTSI1');
	set(state.phys.daq.scopeInputDevice, 'ManualTriggerHwOn', 'Trigger');
