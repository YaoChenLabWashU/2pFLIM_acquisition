function saveCycle
% writes pulseSet to disk

	global state
	
	if isempty(state.cycle.cyclePath) || isempty(state.cycle.cycleName)
		saveCycleAs;
	else
		for counter=1:length(state.internal.cycleListNames)
			eval(['cycle.' state.internal.cycleListNames{counter} 'List = state.cycle.' state.internal.cycleListNames{counter} 'List;']);
		end
		cycle.VCRCPulse=state.cycle.VCRCPulse;
		cycle.CCRCPulse=state.cycle.CCRCPulse;		
		cycle.randomize=state.cycle.randomize;		
		cycle.writeProtect=state.cycle.writeProtect;		
		cycle.useCyclePos=state.cycle.useCyclePos;		
		
		save(fullfile(state.cycle.cyclePath, state.cycle.cycleName), 'cycle', '-MAT');
		state.internal.cycleChanged=0;
		setStatusString('cycle saved');
	end
