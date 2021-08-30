function loadPhysCycleFromMemory(name)
% writes pulseSet to disk

	global state
	period=find(name=='.');
	if ~isempty(period)
		name=name(1:period(1)-1);
	end

	eval(['state.phys.cycle.cycleDef = state.phys.cycle.definitions.' name '{1};']);
	eval(['state.phys.cycle.rsPulseVC = state.phys.cycle.definitions.' name '{2};']);
	eval(['state.phys.cycle.rsPulseCC = state.phys.cycle.definitions.' name '{3};']);

	state.phys.cycle.startingPos=1;
	state.phys.cycle.startingPosFlip=101-state.phys.cycle.startingPos;
	updateGUIByGlobal('state.phys.cycle.startingPosFlip');
	
	state.phys.cycle.cycleName = [name '.epc'];
	checkCurrentCycleInMenu;
	redrawPhysCycle;
