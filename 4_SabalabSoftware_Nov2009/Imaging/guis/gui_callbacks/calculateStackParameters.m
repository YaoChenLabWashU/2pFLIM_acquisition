function calculateStackParameters
	global state
	step=abs(state.acq.zStepSize);
	
	if state.piezo.usePiezo
		zStart=state.motor.stackStart;
		zStop=state.motor.stackStop;
	else
		if length(state.motor.stackStart)==3
			zStart=state.motor.stackStart(3);
		else
			disp('*** Stack starting position not defined.');
			return
		end

		if length(state.motor.stackStop)==3
			zStop=state.motor.stackStop(3);
		else
			disp('*** Stack ending position not defined.');
			return
		end
	end
	
	if zStart>zStop
		state.acq.zStepSize=-step;
	else
		state.acq.zStepSize=step;
	end

	updateGUIByGlobal('state.acq.zStepSize');


	state.acq.numberOfZSlices=max(ceil((abs(zStop-zStart))/step),1); %TNMOD
	updateGUIByGlobal('state.acq.numberOfZSlices');

	preallocateMemory;


	
	
