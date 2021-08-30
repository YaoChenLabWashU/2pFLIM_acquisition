function updatePhysCycle(row, col, val)
	global state
	
	if size(state.phys.cycle.cycleDef,2) < 4 
		recreatePhysCycle;
	end

	if size(state.phys.cycle.cycleDef, 1) < row
		state.phys.cycle.cycleDef(row, :)=[0 0 0 0];
	end
	state.phys.cycle.cycleDef(row, col)=val;
