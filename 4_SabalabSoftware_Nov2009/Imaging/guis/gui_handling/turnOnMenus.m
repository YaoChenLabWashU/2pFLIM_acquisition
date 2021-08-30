function turnOnMenus

	global gh state

	turnonPullDownMenu(gh.siGUI_ImagingControls.Settings, 'Edit Configuration...');
	turnonPullDownMenu(gh.siGUI_ImagingControls.Settings, 'Channels...');
	turnonPullDownMenu(gh.siGUI_ImagingControls.File, 'Load User Settings...');
	turnonPullDownMenu(gh.siGUI_ImagingControls.File, 'Load Configuration...');
	turnonPullDownMenu(gh.siGUI_ImagingControls.Settings, 'Get PMT Offsets...');
	if ishandle(state.internal.userSettingsMenu)
		 set(state.internal.userSettingsMenu, 'Enable', 'On');
	end
	if ishandle(state.internal.configurationsMenu)
		 set(state.internal.configurationsMenu, 'Enable', 'On');
	end	
	
%	set(get(gh.siGUI_ImagingControls.figure1, 'children'), 'Enable', 'On');
