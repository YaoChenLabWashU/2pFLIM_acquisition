function timerCheckIfAllAborted
	global state gh

	if ~any(state.timer.packageStatus)	% nothing running
		set(gh.timerMainControls.doOne, 'String', 'DO ONE');
		set(gh.timerMainControls.loop, 'String', 'LOOP');
		set([gh.timerMainControls.doOne gh.timerMainControls.loop], 'Visible', 'on');
		done=0;
	end
			
	setStatusString('Ready');
	state.cycle.loopingStatus=0; 	% not a loop
	state.cycle.cycleStatus=0; 	% not a loop
