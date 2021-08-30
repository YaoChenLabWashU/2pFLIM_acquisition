function createTilerDAQObjects
	global state
	
	% input object will read from channeks 3 (to see pulse) and 4 (physiology to see effect on cell)
	
	state.tiler.mirrorInputObj = analoginput('nidaq', state.init.acquisitionBoardIndex);

	set(state.tiler.mirrorInputObj, 'TriggerType', 'HwDigital');										
	set(state.tiler.mirrorInputObj, 'SampleRate', state.tiler.inputRate);
	set(state.tiler.mirrorInputObj, 'SamplesAcquiredFcn', {'tilerActionFunction'});

	state.tiler.mirrorActualInputRate = get(state.tiler.mirrorInputObj, 'SampleRate');	

	state.tiler.physInputObj = analoginput('nidaq', state.phys.daq.inputBoardIndex);

	set(state.tiler.physInputObj, 'TriggerType', 'HwDigital');										
	set(state.tiler.physInputObj, 'SampleRate', state.tiler.inputRate);
	set(state.tiler.physInputObj, 'SamplesAcquiredFcn', {'tilerActionFunction'});

	state.tiler.physActualInputRate = get(state.tiler.physInputObj, 'SampleRate');	

	% output trigger a pockel or shutter pulse

	state.tiler.pcellOutputObj = analogoutput('nidaq', state.pcell.pcellBoardIndex);

	set(state.tiler.pcellOutputObj, 'SampleRate', state.tiler.outputRate);
	set(state.tiler.pcellOutputObj, 'TriggerType', 'HwDigital');		

	addchannel(state.tiler.pcellOutputObj, 0:3);
	
	state.tiler.pcellActualOutputRate = get(state.tiler.pcellOutputObj, 'SampleRate');	
	
	state.tiler.mirrorOutputObj = analogoutput('nidaq', state.init.mirrorOutputBoardIndex);

	set(state.tiler.mirrorOutputObj, 'SampleRate', state.tiler.outputRate);
	set(state.tiler.mirrorOutputObj, 'TriggerType', 'HwDigital');		

	addchannel(state.tiler.mirrorOutputObj, state.init.XMirrorChannelIndex);
	addchannel(state.tiler.mirrorOutputObj, state.init.YMirrorChannelIndex);

	state.tiler.mirrorActualOutputRate = get(state.tiler.mirrorOutputObj, 'SampleRate');	

	