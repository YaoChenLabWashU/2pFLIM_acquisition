function putDataFocus
	global state
	global focusOutput pcellFocusOutput
	
	putdata(focusOutput, state.acq.rotatedMirrorData);	
	putdata(pcellFocusOutput, state.acq.pcellPowerOutput);		
	set(focusOutput, 'RepeatOutput', state.internal.numberOfFocusFrames);
	set(pcellFocusOutput, 'RepeatOutput', state.internal.numberOfFocusFrames);
