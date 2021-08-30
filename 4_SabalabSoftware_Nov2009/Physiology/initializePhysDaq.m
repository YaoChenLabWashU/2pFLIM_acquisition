function initializePhysDaq

	global state physOutputDevice physAuxOutputDevice physInputDevice
	
	physOutputDevice = analogoutput('nidaq', state.phys.daq.outputBoardIndex);
	set(physOutputDevice, 'SampleRate', state.phys.settings.outputRate);
	set(physOutputDevice, 'TriggerType', 'HwDigital');
	set(physOutputDevice, 'HwDigitalTriggerSource', 'RTSI1');
	set(physOutputDevice, 'TriggerCondition', 'PositiveEdge');
	
	if state.phys.daq.auxOutputBoardIndex>0
		physAuxOutputDevice = analogoutput('nidaq', state.phys.daq.auxOutputBoardIndex);
		set(physAuxOutputDevice, 'TriggerType', 'HwDigital');		
		set(physAuxOutputDevice, 'HwDigitalTriggerSource', 'RTSI1');
		set(physAuxOutputDevice, 'TriggerCondition', 'PositiveEdge');
	end
	
	physInputDevice = analoginput('nidaq', state.phys.daq.inputBoardIndex);
    set(physInputDevice, 'ExternalTriggerDriveLine', 'RTSI1');
    set(physInputDevice, 'TriggerType', 'Manual');
    set(physInputDevice, 'ManualTriggerHwOn', 'Trigger');
	set(physInputDevice, 'SamplesAcquiredFcn', {'processPhysData'});

