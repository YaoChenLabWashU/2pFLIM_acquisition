function setCurrentClamp(channel)
	global state
	
	eval(['state.phys.settings.currentClamp' num2str(channel) '=1;']);
	if state.phys.scope.channel==channel
		state.phys.internal.needNewScopeOutput=1;
		state.phys.internal.scopeChannelChanged=1;
	end
	if getfield(state.cycle, ['pulseToUse' num2str(channel)])
		state.phys.internal.needNewOutputData=1;
	end
	updateGUIByGlobal(['state.phys.settings.currentClamp' num2str(channel)]);
	setPhysStatusString(['Channel ' num2str(channel) ' in C-Clamp']);
	
