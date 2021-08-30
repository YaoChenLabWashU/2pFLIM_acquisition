function savePhysCycleInMemory
% writes pulseSet to disk

	global state

	if ~isempty(state.phys.cycle.cycleName)
		period=find(state.phys.cycle.cycleName=='.');
		if isempty(period)
			name=state.phys.cycle.cycleName;
		else
			name=state.phys.cycle.cycleName(1:period(1)-1);
		end
	
		eval(['state.phys.cycle.definitions.' name ' = {state.phys.cycle.cycleDef state.phys.cycle.rsPulseVC state.phys.cycle.rsPulseCC};']);
	end
