% The following function allows one to image for a specified number of
	% frames while uncaging for longer.  To use it, type command YaoFrame(# of frames you want the P cell on).
	function YaoFrame(frame)
	global state
 	if frame>0;
		state.acq.pcellRepeatedOutput = repmat(state.acq.pcellPowerOutput, frame, 1); 
	% con contanenate repmat [... ; ] to make more complicated pattersn;
	% can use state.acq.numberOfFrames.
	else state.acq.pcellRepeatedOutput = repmat(state.acq.pcellPowerOutput, state.acq.numberOfFrames, 1);
	applyChangesToOutput;
	frame=0;
	end