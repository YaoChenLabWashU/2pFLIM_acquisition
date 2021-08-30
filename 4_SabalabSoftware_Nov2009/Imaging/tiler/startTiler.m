function startTiler
	global state

	state.tiler.tileCounter=0;

	state.tiler.abort=0;
	
 	start([state.tiler.mirrorInputObj ...
		 state.tiler.mirrorOutputObj ...
		 state.tiler.pcellOutputObj]);
	diotrigger;