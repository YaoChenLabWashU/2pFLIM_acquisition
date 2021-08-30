function selectImageUserFromMenu
	global state

	h=gcbo;
	children=get(state.internal.userSettingsMenu, 'Children');
	index=find(children==h);
	openAndLoadUserSettings(fullfile(get(children(end), 'Label'), get(children(index), 'Label')));
	