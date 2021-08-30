function turnOnExecuteButtons
	global gh
	set(gh.siGUI_ImagingControls.focusButton, 'enable', 'on')
	set(gh.siGUI_ImagingControls.grabOneButton, 'enable', 'on')
	set(gh.timerMainControls.loop, 'enable', 'on')
	set(gh.timerMainControls.doOne, 'enable', 'on')
	set(gh.motorGUI.GRAB, 'enable', 'on')
