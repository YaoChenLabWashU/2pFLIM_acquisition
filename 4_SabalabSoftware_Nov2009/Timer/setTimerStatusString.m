function setTimerStatusString(st)

	global state
	state.timer.statusString=st;
	updateGUIByGlobal('state.timer.statusString');
	
	