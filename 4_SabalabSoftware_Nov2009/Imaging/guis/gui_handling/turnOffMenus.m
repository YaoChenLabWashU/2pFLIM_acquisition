function turnOffMenus

	global gh state
	turnoffPullDownMenu(gh.siGUI_ImagingControls.Settings, 'Edit Configuration...');
	turnoffPullDownMenu(gh.siGUI_ImagingControls.Settings, 'Channels...');
	turnoffPullDownMenu(gh.siGUI_ImagingControls.Settings, 'Get PMT Offsets...');
	turnoffPullDownMenu(gh.siGUI_ImagingControls.File, 'Load User Settings...');
	turnoffPullDownMenu(gh.siGUI_ImagingControls.File, 'Load Configuration...');

	if ishandle(state.internal.userSettingsMenu)
		 set(state.internal.userSettingsMenu, 'Enable', 'off');
	end
	if ishandle(state.internal.configurationsMenu)
		 set(state.internal.configurationsMenu, 'Enable', 'off');
	end
%	set(get(gh.siGUI_ImagingControls.figure1, 'children'), 'Enable', 'Off');
