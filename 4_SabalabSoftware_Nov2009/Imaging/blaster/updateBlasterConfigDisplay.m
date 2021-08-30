function updateBlasterConfigDisplay
	global state
	if state.blaster.displayConfig>size(state.blaster.allConfigs,1)
		state.blaster.displayConfig=size(state.blaster.allConfigs,1);
	end
	updateGUIByGlobal('state.blaster.displayConfig');
	state.blaster.displayConfigName=state.blaster.allConfigs{state.blaster.displayConfig, 1};
	updateGUIByGlobal('state.blaster.displayConfigName');
	
	state.blaster.line=1;
	updateGUIByGlobal('state.blaster.line');
	updateBlasterConfigLineDisplay	
	state.blaster.maxLine=size(state.blaster.allConfigs{state.blaster.displayConfig, 2},1);
	updateGUIByGlobal('state.blaster.maxLine')
