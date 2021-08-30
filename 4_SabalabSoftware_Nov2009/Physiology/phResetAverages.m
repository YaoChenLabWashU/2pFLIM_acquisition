function phResetAverages(pulses, channels) 
	global state
	
	if nargin==0
		if state.cycle.useCyclePos
			pulses=find(state.cycle.physOnList);
		else
			pulses=unique(state.cycle.da0List);
		end
	end
	
	if nargin<2 || isempty(channels)
		channels=0:7;
	end


	for channel=channels
		for pulse=pulses
			name=physAvgName(state.epoch, channel, pulse);
			if iswave(name);
				resetAverage(name);
			end
		end
	end
	



