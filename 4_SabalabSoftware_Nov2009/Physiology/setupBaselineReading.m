function setupBaselineReading
	global state
	if state.analysisMode
		return
	end
	
	state.phys.daq.baselineDevice=analoginput('nidaq', state.phys.daq.inputBoardIndex);
	set(state.phys.daq.baselineDevice, 'TriggerType', 'Immediate');

	for counter=0:1	% add channels for main reading
		type=getfield(state.phys.settings, ['channelType' num2str(counter)]);
		if type > 1
			addchannel(state.phys.daq.baselineDevice, counter);
			set(state.phys.daq.baselineDevice.Channel, 'InputRange', [-10 10])
		end
	end
	
	for counter=0:1	% add channels for the other one feedback reading of command
		type=getfield(state.phys.settings, ['channelType' num2str(counter)]);
		if type > 1
			addchannel(state.phys.daq.baselineDevice, counter+2);
			set(state.phys.daq.baselineDevice.Channel, 'InputRange', [-10 10])
		end
	end
	
	set(state.phys.daq.baselineDevice, 'SampleRate', 10000);
	set(state.phys.daq.baselineDevice, 'SamplesPerTrigger', 500);
