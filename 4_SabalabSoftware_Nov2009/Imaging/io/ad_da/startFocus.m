function startFocus
	global state
	global focusInput focusOutput pcellFocusOutput
	
	state.internal.status=2;
	state.internal.lastTaskDone=2;
    
	
	if state.blaster.blankImaging && (state.internal.lastTaskDone~=2)
		state.internal.needNewPcellPowerOutput=1;
		applyChangesToOutput;
	end
	
	putDataFocus

	start(focusOutput);
	if state.pcell.pcellOn
		start(pcellFocusOutput);
    end
    
	start(focusInput);
%	trigger(focusInput);


 