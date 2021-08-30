function timerSetup_LineMonitor
	global state
	if state.lm.pollEachAcq
		lmReadDAQs
	end