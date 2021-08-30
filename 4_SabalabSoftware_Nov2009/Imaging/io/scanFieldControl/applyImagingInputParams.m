function applyImagingInputParams
	global state
	if state.analysisMode
		resetImageProperties;
	else
		setupInputChannels;
		preallocateMemory;
		resetImageProperties(0);
		resetCounters;
	end
	updateHeaderString('state.acq.pixelsPerLine');
	updateHeaderString('state.acq.fillFraction');

	updateimageGUI;			
	updateClim;

	state.internal.fractionStart = (...
		(state.acq.lineDelay-state.acq.mirrorLag)/state.acq.msPerLine*state.internal.samplesPerLine) / state.internal.samplesPerLine;
	state.internal.fractionEnd = state.internal.fractionStart + (state.acq.samplesAcquiredPerLine-1) / state.internal.samplesPerLine;
	state.internal.fractionPerPixel=(state.internal.fractionEnd - state.internal.fractionStart)/state.acq.pixelsPerLine;

		
