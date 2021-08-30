function deletePhysCycleRow(row)
	global state
	
	row = row + state.phys.cycle.startingPos - 1;
	
	if row>size(state.phys.cycle.cycleDef,1)
		return
	end

	if row>1
		newCycle=state.phys.cycle.cycleDef(1:row-1, :);
	end
	
	if row<size(state.phys.cycle.cycleDef,1)
		newCycle(row:size(state.phys.cycle.cycleDef,1)-1, :) ...
			= state.phys.cycle.cycleDef(row+1:end, :);
	end
	if size(newCycle,1)<4
		newCycle(4,:)=[0 0 0 0];
	end
	state.phys.cycle.cycleDef=newCycle;
	redrawPhysCycle;