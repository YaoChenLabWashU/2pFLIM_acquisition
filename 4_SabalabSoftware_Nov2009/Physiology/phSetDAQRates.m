function phSetDAQRates
	global state physOutputDevice physAuxOutputDevice physInputDevice
	
	state.phys.settings.inputRate=setverify(physInputDevice, 'SampleRate', state.phys.settings.inputRate);
	updateGUIByGlobal('state.phys.settings.inputRate');

	state.phys.settings.outputRate=setverify(physOutputDevice, 'SampleRate', state.phys.settings.outputRate);
    if state.phys.daq.auxOutputBoardIndex>0
    	outputRate=setverify(physAuxOutputDevice, 'SampleRate', state.phys.settings.outputRate);  
		state.phys.internal.needNewAuxOutputData=1;
	end
	state.phys.internal.needNewOutputData=1;	
	updateGUIByGlobal('state.phys.settings.outputRate');	