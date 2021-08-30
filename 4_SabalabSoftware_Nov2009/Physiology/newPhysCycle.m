function newPhysCycle
	global state
	
	state.phys.cycle.cycleDef=zeros(4,4);
	state.phys.cycle.startingPos=1;
	state.phys.cycle.startingPosFlip=101-state.phys.cycle.startingPos;
	updateGUIByGlobal('state.phys.cycle.startingPosFlip');
	state.phys.cycle.cycleName = '';
	state.phys.cycle.rsPulseVC=0;
	state.phys.cycle.rsPulseCC=0;
	
	redrawPhysCycle;
	