function nameList=physAvgList(epoch, pulses, channels)
	global state
	
	if nargin<1
		epoch=state.epoch;
	end
	if nargin<2
		if state.cycle.useCyclePos
			pulses=1:size(state.cycle.delayList,2);
		else
			pulses=unique(state.cycle.da0List);
		end
	end
	if nargin<3
		channels=0:7;
	end
	
	nameList={};
	for channel=channels
		if getfield(state.phys.settings, ['acq' num2str(channel)]) & getfield(state.phys.settings, ['avg' num2str(channel)])
			for pulse=pulses
				name=physAvgName(epoch, channel, pulse);
				if iswave(name);
					nameList{end+1}=name;
				end
			end
		end
	end
