function setStatusString(st)

% This function sets the status field in mainControls.

	global state gh
	state.internal.statusString=st;
	updateGUIByGlobal('state.internal.statusString');
	
	