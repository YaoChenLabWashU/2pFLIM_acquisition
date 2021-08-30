function out=physAvgName(epoch, channel, pulse)
	global state
	
	if isnumeric(epoch)
		epoch=num2str(epoch);
	end
	if isnumeric(channel)
		channel=num2str(channel);
	end
	if isnumeric(pulse)
		pulse=num2str(pulse);
	end
	out=[getfield(state.phys.settings, ['ADPrefix' channel]) '_' 'e' epoch 'p' pulse 'avg'];
