function out=physTraceName(channel, counter)
	global state
	
	if isnumeric(channel)
		channel=num2str(channel);
	end
	if isnumeric(counter)
		counter=num2str(counter);
	end
	out=[getfield(state.phys.settings, ['ADPrefix' channel]) '_' counter];
