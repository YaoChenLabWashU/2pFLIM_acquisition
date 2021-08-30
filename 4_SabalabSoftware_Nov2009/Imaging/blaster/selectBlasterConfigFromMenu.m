function selectBlasterConfigFromMenu
	global state gh

	h=gcbo;
	children=get(gh.blaster.Config, 'Children');
	state.blaster.displayConfig=length(children)-find(children==h)-1;
	updateGUIByGlobal('state.blaster.displayConfig');
	state.blaster.currentConfig=state.blaster.displayConfig;
	updateBlasterConfigDisplay;
	set(children, 'Checked', 'off');
	set(h, 'Checked', 'on');
	
	if state.blaster.active
		state.internal.needNewRepeatedMirrorOutput=1;
		state.internal.needNewPcellRepeatedOutput=1;
		applyChangesToOutput;
	end

