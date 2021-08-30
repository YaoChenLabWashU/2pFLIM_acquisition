function insertPhysCycleRow(row)
	global state
	
	oldRow=row;
	row = row + state.phys.cycle.startingPos - 1;
	
	if row > size(state.phys.cycle.cycleDef,1)
		return
	end
	if row>1
		newCycle=state.phys.cycle.cycleDef(1:row-1, :);
	end
	
	newCycle(row,:)=[0 0 0 0];
	if row<size(state.phys.cycle.cycleDef,1)
		newCycle(row+1:size(state.phys.cycle.cycleDef,1)+1, :) ...
			= state.phys.cycle.cycleDef(row:end, :);
	end
	state.phys.cycle.cycleDef=newCycle;
	if oldRow==5
		state.phys.cycle.startingPos=state.phys.cycle.startingPos+1;
		updateGUIByGlobal('state.phys.cycle.startingPos');
	end
	redrawPhysCycle;