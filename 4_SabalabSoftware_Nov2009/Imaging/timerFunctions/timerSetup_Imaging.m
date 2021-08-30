function timerSetup_Imaging
	global state
	applyChangesToOutput;			
	
	if state.init.autoReadPMTOffsets
		getPMTOffsets;
	end
	mp285Flush;
	if state.acq.numberOfZSlices > 1	
		state.internal.initialMotorPosition=updateMotorPosition;
	else
		state.internal.initialMotorPosition=[];
	end
	
	resetCounters;
	state.files.lastAcquisition=state.files.fileCounter;
	state.internal.abortActionFunctions=0;
	
	turnOffMenus;
	
	
		
