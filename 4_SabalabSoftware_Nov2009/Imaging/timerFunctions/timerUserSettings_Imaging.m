function timerUserSettings_Imaging
	loadConfig;
	updateKeepAllSlicesCheckMark; % BSMOD
	makeConfigurationMenu;
	reloadPcellTables;
	global state
	if ~isempty(state.blaster.setupName) & ~isempty(state.blaster.setupPath)
		loadBlasterSetup(state.blaster.setupPath, state.blaster.setupName)
	end
	