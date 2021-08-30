function initTiler
	global state gh
	
	gh.tilerControls=guihandles(tilerControls);
	gh.tilerLineControls=guihandles(tilerLineControls);
	openini('tiler.ini');

	createTilerDAQObjects;
	makeTilerOutput;
	tilerAddInputChannels;
	
	
