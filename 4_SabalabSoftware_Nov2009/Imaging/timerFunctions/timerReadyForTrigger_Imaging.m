function status=timerReadyForTrigger_Imaging
	global state grabOutput pcellGrabOutput
	
	status=1;	% good to do
	
	if state.pcell.pcellOn
		if strcmp(get(pcellGrabOutput, 'Running'), 'Off')
			status=0; % not ready
			disp('timerReadyForTrigger_Imaging: pcellGrabOutput device not ready');
		end
	end	

	if strcmp(get(grabOutput, 'Running'), 'Off')	
		status=0; % not ready
		disp('timerReadyForTrigger_Imaging: grabOutput device not ready');
	end


