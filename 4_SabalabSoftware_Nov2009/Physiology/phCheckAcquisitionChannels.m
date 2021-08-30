function phCheckAcquisitionChannels
	global state physOutputDevice
	
	channels=get(get(physOutputDevice, 'Channel'), 'HwChannel');
	if ~isnumeric(channels)
		for counter=1:length(channels)
			cList(counter)=channels{counter};
		end
	else
		cList=channels;
	end
	
	if length(cList)~=length(find([state.cycle.pulseToUse0 state.cycle.pulseToUse1]))
		state.phys.internal.needNewChannels=1;
	else
		if state.cycle.pulseToUse0 && isempty(cList==0)
			state.phys.internal.needNewChannels=1;
		end
		if state.cycle.pulseToUse1 && isempty(cList==1)
			state.phys.internal.needNewChannels=1;
		end
	end