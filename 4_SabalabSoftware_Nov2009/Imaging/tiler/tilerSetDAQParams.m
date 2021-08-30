function tilerAddInputChannels
	global state
	
	c=get(state.tiler.physInputObj, 'Channel');
	if ~isempty(c)
		delete(c);
	end
	
	c=get(state.tiler.mirrorInputObj, 'Channel');
	if ~isempty(c)
		delete(c);
	end

	for counter=0:3
		if getfield(state.tiler, ['mirrorAcq' num2str(counter)])
			addchannel(state.tiler.mirrorInputObj, counter);
		end
	end
	
	for counter=0:7
		if getfield(state.tiler, ['physAcq' num2str(counter)])
			addchannel(state.tiler.physInputObj, counter);
		end
	end
