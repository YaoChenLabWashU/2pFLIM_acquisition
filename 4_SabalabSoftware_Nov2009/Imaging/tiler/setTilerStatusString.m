function setTilerStatusString(st)
	global gh state
	
	state.tiler.statusString=st;
	updateGUIByGlobal('state.tiler.statusString');
