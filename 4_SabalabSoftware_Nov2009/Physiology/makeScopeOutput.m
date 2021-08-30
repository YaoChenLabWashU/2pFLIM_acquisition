function makeScopeOutput
	global state 

	if state.phys.scope.channel==0
		state.phys.scope.channelUsed=0;
		if state.phys.settings.currentClamp0
			state.phys.scope.ampUsed=state.phys.scope.pulseAmpCC;
			state.phys.scope.ccUsed=1;
			amp=state.phys.scope.pulseAmpCC/state.phys.settings.pAPerVOut0;
			width=state.phys.scope.pulseWidthCC;
		else
			state.phys.scope.ampUsed=state.phys.scope.pulseAmpVC;
			state.phys.scope.ccUsed=0;
			amp=state.phys.scope.pulseAmpVC/state.phys.settings.mVPerVOut0;
			width=state.phys.scope.pulseWidthVC;
		end
	elseif state.phys.scope.channel==1
		state.phys.scope.channelUsed=1;
		if state.phys.settings.currentClamp1
			state.phys.scope.ampUsed=state.phys.scope.pulseAmpCC;
			state.phys.scope.ccUsed=1;
			amp=state.phys.scope.pulseAmpCC/state.phys.settings.pAPerVOut1;
			width=state.phys.scope.pulseWidthCC;
		else
			state.phys.scope.ampUsed=state.phys.scope.pulseAmpVC;
			state.phys.scope.ccUsed=0;
			amp=state.phys.scope.pulseAmpVC/state.phys.settings.mVPerVOut1;
			width=state.phys.scope.pulseWidthVC;
		end
	else
		stopScope;
		disp('*** makeScopeOutput: Scope channel out of range');
		beep;
		setPhysStatus('ERROR');
		return;
	end
	
	state.phys.scope.pointsUntilOutputPulse=round(width*state.phys.scope.actualOutputRate/2000);
	state.phys.scope.pointsUntilInputPulse=round(width*state.phys.scope.actualInputRate/2000);
	
	state.phys.scope.output=zeros(4*state.phys.scope.pointsUntilOutputPulse,1);
	state.phys.scope.output(state.phys.scope.pointsUntilOutputPulse : 3*state.phys.scope.pointsUntilOutputPulse) = amp;
	
	setWave('scopeInputFit', 'xscale', [width/2-1000/state.phys.scope.actualOutputRate 1000/state.phys.scope.actualInputRate]);

	