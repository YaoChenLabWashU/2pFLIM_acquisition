function setPhysStatusString(status)
	global state
	state.phys.internal.statusString=status;
	updateGUIByGlobal('state.phys.internal.statusString');
	