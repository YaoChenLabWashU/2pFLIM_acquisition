function makeNewRepeatedMirrorOutput
	global state
	
	state.acq.repeatedMirrorData=repmat(state.acq.rotatedMirrorData, state.acq.numberOfFrames, 1);

	if state.blaster.active
		applyBlasterParking;
	end
