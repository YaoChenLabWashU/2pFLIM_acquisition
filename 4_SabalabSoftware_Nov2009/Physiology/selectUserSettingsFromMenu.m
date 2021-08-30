function selectUserSettingsFromMenu
	global state gh

	h=gcbo;
	children=get(gh.timerMainControls.Users, 'Children');
	index=find(children==h);
	loadUserSettings(get(children(end), 'Label'), get(children(index), 'Label'));