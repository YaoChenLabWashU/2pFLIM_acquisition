function editConfiguration
% brings up configuration window for editting
	global gh state
	
	state.internal.configurationChanged=0;
	seeGUI('gh.basicConfigurationGUI.figure1');
 