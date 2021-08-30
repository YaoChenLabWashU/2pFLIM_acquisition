function readTelegraphs
	global state

	readAxon=0;
	for counter=0:1
		type=getfield(state.phys.settings, ['channelType' num2str(counter)]);
		switch type
		case 2
			if ~readAxon
				readAxonTelegraphs;
				readAxon=1;
			end
		case 3
			readMultiClampParams(counter);
		end
	end
	phSetChannelGains
	