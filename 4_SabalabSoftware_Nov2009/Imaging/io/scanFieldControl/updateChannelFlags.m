function updateChannelFlags
	global state
	
	for counter = 1:state.init.maximumNumberOfInputChannels
		state.acq.acquiringChannel(counter) = getfield(state.acq, ['acquiringChannel' num2str(counter)]);
		state.acq.savingChannel(counter) = getfield(state.acq, ['savingChannel' num2str(counter)]);
		state.acq.imagingChannel(counter) = getfield(state.acq, ['imagingChannel' num2str(counter)]);
		state.acq.maxImage(counter) = getfield(state.acq, ['maxImage' num2str(counter)]);
	end

