function setupAxonTelegraphs
	global state
	if state.analysisMode
		return
	end
	
	state.phys.daq.telegraphDevice=analoginput('nidaq', state.phys.daq.axonTelegraphBoardIndex);
	set(state.phys.daq.telegraphDevice, 'TriggerType', 'Immediate');

	for counter=0:1
		type=getfield(state.phys.settings, ['channelType' num2str(counter)]);
		if type == 2
			addchannel(state.phys.daq.telegraphDevice, getfield(state.phys.settings, ['axonGainTelegraphLine' num2str(counter)]));
			addchannel(state.phys.daq.telegraphDevice, getfield(state.phys.settings, ['axonModeTelegraphLine' num2str(counter)]));
		end
	end
	set(state.phys.daq.telegraphDevice.Channel, 'InputRange', [-10 10]);
	
	set(state.phys.daq.telegraphDevice, 'SampleRate', 10000);
	set(state.phys.daq.telegraphDevice, 'SamplesPerTrigger', 500);
