function siApplyDAQSampleRates
	global focusInput focusOutput pcellFocusOutput
	global grabInput grabOutput pcellGrabOutput
	global state
	
	set(focusOutput, 'SampleRate', state.acq.outputRate);
	set(grabOutput, 'SampleRate', state.acq.outputRate);
	state.acq.actualOutputRate = get(grabOutput, 'SampleRate');
	updateGUIByGlobal('state.acq.actualOutputRate');
	if state.acq.outputRate~=state.acq.actualOutputRate
		disp('siApplyDAQSampleRates: Warning request output rate not achieved');
	end
	
	set(pcellFocusOutput, 'SampleRate', state.acq.outputRate);
	set(pcellGrabOutput, 'SampleRate', state.acq.outputRate);
	state.acq.actualPcellOutputRate = get(pcellGrabOutput, 'SampleRate');
	updateGUIByGlobal('state.acq.actualPcellOutputRate');
	if state.acq.outputRate~=state.acq.actualPcellOutputRate
		disp('siApplyDAQSampleRates: Warning request output pcell rate not achieved');
	end
	
	set(grabInput, 'SampleRate', state.acq.inputRate);
	set(focusInput, 'SampleRate', state.acq.inputRate);	
	set(state.daq.pmtOffsetInput, 'SampleRate', state.acq.inputRate);
	state.acq.actualInputRate = get(grabInput, 'SampleRate');
	updateGUIByGlobal('state.acq.actualInputRate');
	if state.acq.inputRate~=state.acq.actualInputRate
		disp('siApplyDAQSampleRates: Warning request input rate not achieved');
	end	