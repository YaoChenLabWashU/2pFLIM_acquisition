function turnOffExecuteButtons
	global gh
	set(gh.siGUI_ImagingControls.focusButton, 'enable', 'off')
	set(gh.siGUI_ImagingControls.grabOneButton, 'enable', 'off')
	set(gh.timerMainControls.loop, 'enable', 'off')
	set(gh.timerMainControls.doOne, 'enable', 'off')
	set(gh.motorGUI.GRAB, 'enable', 'off')
