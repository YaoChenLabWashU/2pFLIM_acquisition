function cfChangeInputRate(rate)
	global state
	
	state.phys.settings.inputRate=rate;
	updateGUIByGlobal('state.phys.settings.inputRate');
	
	