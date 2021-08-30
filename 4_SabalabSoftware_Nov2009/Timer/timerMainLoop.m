function timerMainLoop
	global state gh
    global grabOutput pcellGrabOutput  grabInput

	
	setStatusString('Looping...');
	
	change=0;
	recoveredFromPause=0;
	if state.cycle.loopingStatus==2	% we're going in after a pause
		state.cycle.loopingStatus=1;
		recoveredFromPause=1;
	end
	
	if state.timer.abort
		return
	end	
	if timerPausedStatus
		state.cycle.loopingStatus=2;
		setStatusString('LOOP PAUSED');
		return
	end
	
	if (~findValidCyclePosition)
		setStatusString('BAD CYCLE');
		error('mainLoop: Unable to find valid cycle position');
	end
	applyAdvancedCyclePosition;

	setStatusString('Setting up packages...');
	timerCallPackageFunctions('Setup');
	
	if state.timer.abort
		return
	end	
	if timerPausedStatus
		state.cycle.loopingStatus=2;
		setStatusString('LOOP PAUSED');
		return
	end
	
	state.cycle.loopingStatus=1;
	
	if (state.internal.firstTimeThroughLoop==0) || recoveredFromPause
		state.internal.secondsCounter=floor(state.internal.lastTimeDelay-etime(clock,state.internal.triggerTime));
	else
		state.internal.triggerTime=clock;
		state.internal.secondsCounter=state.internal.lastTimeDelay;
	end
	
	updateGUIByGlobal('state.internal.secondsCounter');
	
	% load daq engine % here get dacq ready for trigger
	if (state.internal.firstTimeThroughLoop==0) || state.acq.externalTrigger
		setStatusString('Counting down...');
		
		if etime(clock,state.internal.triggerTime)>(state.internal.lastTimeDelay)
			setStatusString('DELAY TOO SHORT!');
			beep;
		end
		
		if etime(clock,state.internal.triggerTime) >= (state.internal.lastTimeDelay-10)
			gotoCycleStagePosition(state.internal.firstTimeThroughLoop);
			moveDone=1;
		else
			moveDone=0;
		end
		
		while etime(clock,state.internal.triggerTime) <(state.internal.lastTimeDelay-1)
			if state.timer.abort
				return
			end	
			if timerPausedStatus
				state.cycle.loopingStatus=2;
				setStatusString('LOOP PAUSED');
				return
			end
			
			if (etime(clock,state.internal.triggerTime) >= (state.internal.lastTimeDelay-10)) & ~moveDone
				gotoCycleStagePosition(state.internal.firstTimeThroughLoop);
				moveDone=1;
			end
			old=etime(clock,state.internal.triggerTime);
			
			timerCallPackageFunctions('Wait');
			
			while floor(etime(clock,state.internal.triggerTime))<old
				pause(0.01);
				if state.timer.abort
					return
				end	
				if timerPausedStatus
					state.cycle.loopingStatus=2;
					setStatusString('LOOP PAUSED');
					return
				end
			end
			state.internal.secondsCounter=round(state.internal.lastTimeDelay-etime(clock,state.internal.triggerTime));
			updateGUIByGlobal('state.internal.secondsCounter');
			pause(0.01);
		end
		
		if state.timer.abort
			return
		end	
		
		if timerPausedStatus
			state.cycle.loopingStatus=2;
			setStatusString('LOOP PAUSED');
			return
		end
		
		state.internal.secondsCounter=0;
		
		timerCallPackageFunctions('Start');
		
% 		if state.internal.lastTimeDelay-etime(clock,state.internal.triggerTime)-state.internal.timingDelay>0
% 			pause(state.internal.lastTimeDelay-etime(clock,state.internal.triggerTime)-state.internal.timingDelay) % 0.05 is 
% 		end
	else
		if ~recoveredFromPause
			gotoCycleStagePosition(state.internal.firstTimeThroughLoop);
		end
		if state.timer.abort
			return
		end	
		if timerPausedStatus
			state.cycle.loopingStatus=2;
			setStatusString('LOOP PAUSED');
			return
		end
		
		timerCallPackageFunctions('Start');
%         grabOutput
%  pcellGrabOutput
		state.internal.firstTimeThroughLoop=0;
	end
	
	if state.timer.abort
		return
	end
	
	setStatusString('Acquiring...');

	if ~state.acq.externalTrigger
		timerTrigger;
%         grabInput
%         grabOutput
%  pcellGrabOutput
	else
		setStatusString('Waiting for trigger...');
		disp(['Waiting for trigger at ' clockToString(clock) '. ']);
	end		
	
	
	
	
