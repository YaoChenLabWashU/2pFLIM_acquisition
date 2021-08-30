function timerStart_Imaging
	global state gh

	timerSetPackageStatus(1, 'Imaging');
		
	set(gh.siGUI_ImagingControls.grabOneButton, 'String', 'ABORT');
	set(gh.siGUI_ImagingControls.focusButton, 'Visible', 'Off');

	global grabOutput pcellGrabOutput
	putDataGrab

	start(grabOutput)
	if state.pcell.pcellOn
		start(pcellGrabOutput)
	end
	
	state.internal.status=3;
	state.internal.lastTaskDone=3;




 	
