function startGrab
	global state

	global grabInput grabOutput pcellGrabOutput

	putDataGrab
	start(grabInput)
	start(grabOutput)
	if state.pcell.pcellOn
		start(pcellGrabOutput);
	end
	state.internal.status=3;
	state.internal.lastTaskDone=3;
	state.internal.triggerTime=clock;