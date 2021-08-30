function savePhysCycle
% writes pulseSet to disk

	global state
	
	if isempty(state.phys.cycle.cyclePath) | isempty(state.phys.cycle.cycleName)
		savePhysCycleAs;
	else
		cycle.cycleDef=state.phys.cycle.cycleDef;
		cycle.rsPulseVC=state.phys.cycle.rsPulseVC;
		cycle.rsPulseCC=state.phys.cycle.rsPulseCC;		
		
		save(fullfile(state.phys.cycle.cyclePath, state.phys.cycle.cycleName), 'cycle', '-MAT');
		setPhysStatusString('cycle saved');
	end
