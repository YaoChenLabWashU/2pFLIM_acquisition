function stopTiler
	global state
	stop([state.tiler.pcellOutputObj state.tiler.mirrorOutputObj state.tiler.mirrorInputObj]);
