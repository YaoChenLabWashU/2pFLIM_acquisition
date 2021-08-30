function resumeLoop
	global state gh
	updateGUIByGlobal('state.internal.secondsCounter');

	state.cycle.repeatsDone=state.cycle.repeatsDone+1;
	updateGUIByGlobal('state.cycle.repeatsDone');

	if state.cycle.randomize
		state.internal.randomPosition=state.internal.randomPosition+1;
	end
	timerMainLoop;
