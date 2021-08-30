function timerLoop

	global state gh
	val=get(gh.timerMainControls.loop, 'String');
	
	if strcmp(val, 'LOOP')
		if timerPausedStatus
			beep;
			setStatusString('Running. Stop processes');
			return
		end

		if ~savingInfoIsOK(~timerGetActiveStatus('Imaging'))
			return
        end	

        if state.cycle.randomize && isempty(state.internal.randomPositionsList)
            setupCycleRandomList
        end
        
		setStatusString('Starting loop...');

		state.internal.firstTimeThroughLoop=1;
		set(gh.timerMainControls.loop, 'String', 'ABORT');
		hideGUI('gh.timerMainControls.doOne');
		state.cycle.loopingStatus=1; 	% a loop
		state.timer.abort=0;

		setStatusString('Setting up packages...');
		timerCallPackageFunctions('FirstSetup');
		
		timerMainLoop;
	else
		timerCallPackageFunctions('Abort');
		if ~any(state.timer.packageStatus)	% nothing running
			set(gh.timerMainControls.loop, 'String', 'LOOP');
			set([gh.timerMainControls.doOne gh.timerMainControls.loop], 'Visible', 'on');
		end			
	end



