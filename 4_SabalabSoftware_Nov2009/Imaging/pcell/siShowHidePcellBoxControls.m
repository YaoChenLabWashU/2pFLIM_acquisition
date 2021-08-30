function siShowHidePcellBoxControls	
	global gh
	if strcmp(get(gh.pcellControl.showHideBoxControls, 'String'), '/\')
		figurePos=get(gh.pcellControl.figure1, 'Position');
		set(gh.pcellControl.figure1, 'Position', figurePos-[0 -7.30 0 7.3])
		powerPanelPosition=get(gh.pcellControl.powerPanel, 'Position');
		set(gh.pcellControl.powerPanel, 'Position', ...
			[powerPanelPosition(1) 0 powerPanelPosition(3:4)])
		set(gh.pcellControl.boxPanel, 'Visible', 'off')
		set(gh.pcellControl.showHideBoxControls, 'String', '\/')	
	else
		figurePos=get(gh.pcellControl.figure1, 'Position');
		set(gh.pcellControl.figure1, 'Position', figurePos+[0 -7.31 0 7.3])
		powerPanelPosition=get(gh.pcellControl.powerPanel, 'Position');
		set(gh.pcellControl.powerPanel, 'Position', ...
			[powerPanelPosition(1) 7.3 powerPanelPosition(3:4)])
		set(gh.pcellControl.boxPanel, 'Visible', 'on')
		set(gh.pcellControl.showHideBoxControls, 'String', '/\')
	end