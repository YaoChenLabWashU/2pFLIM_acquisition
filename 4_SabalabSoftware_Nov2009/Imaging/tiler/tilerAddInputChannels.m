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
			waveo(['mirrorDataWave' num2str(counter)], nan);
			waveo(['mirrorLastWave' num2str(counter)], nan);
		end
	end
	
	for counter=0:7
		if getfield(state.tiler, ['physAcq' num2str(counter)])
			addchannel(state.tiler.physInputObj, counter);
			waveo(['physDataWave' num2str(counter)], nan);
			waveo(['physLastWave' num2str(counter)], nan);
		end
	end
