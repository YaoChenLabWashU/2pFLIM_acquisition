function setupPhysDaqInputChannels
% adds appropriate channels to physInputDevice
	global state physInputDevice
	if state.analysisMode
		return
	end
	
	if size(get(physInputDevice, 'Channel'),1)>0
		delete(physInputDevice.Channel);
	end

	state.phys.settings.acquiredChannels=[];
	for counter=0:7
		if getfield(state.phys.settings, ['acq' num2str(counter)])
			channel=addchannel(physInputDevice, counter);
			channel.InputRange = [-10 10];
			channel.SensorRange = [-10 10];
			channel.UnitsRange = [-10 10];
			state.phys.settings.acquiredChannels(end+1)=counter;
		end
	end
	
	if isempty(get(physInputDevice, 'Channel'))
		error('setupPhysDaqInputChannels: No input channels selected');
	else
		flushdata(physInputDevice);
	end
	

	
