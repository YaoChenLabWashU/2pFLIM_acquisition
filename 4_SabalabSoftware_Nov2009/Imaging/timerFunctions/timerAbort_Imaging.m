function timerAbort_Imaging
	global state grabInput

	state.internal.abortActionFunctions=1;
	state.internal.status=0;
	
	if state.acq.externalTrigger
		if strcmp(get(grabInput, 'Running'),'Off') 
			abortGrab;
		elseif get(grabInput, 'TriggersExecuted')>0
			state.internal.abortActionFunctions=1;
		else
			abortGrab;
		end
	else
		if strcmp(get(grabInput, 'Running'),'Off') || get(grabInput, 'TriggersExecuted')==0
			abortGrab;
		else
			state.internal.abortActionFunctions=1;
		%	abortGrab;
		end
	end
	
