function timerWait_LineMonitor
	global state
	
	if state.lm.pollDuringWait
		lmReadDAQs
	end	