function savePulseSet
% writes pulseSet to disk

	global state
	
	if isempty(state.pulses.pulseSetPath) || isempty(state.pulses.pulseSetName)
		savePulseSetAs;
	else
		fn=fieldnames(state.pulses);
		
		pulseSet=[];
		
		for counter=1:length(fn)
			if findstr('List', fn{counter})
				eval(['pulseSet.' fn{counter} '=state.pulses. ' fn{counter} ';']);
			end
		end

		save(fullfile(state.pulses.pulseSetPath, state.pulses.pulseSetName), 'pulseSet')
		%save(fullfile(state.pulses.pulseSetPath, state.pulses.pulseSetName), 'pulseSet', '-v6')

        setPhysStatusString('pulseSet saved');
        state.pulses.pulseSetChanged=0;
	end
