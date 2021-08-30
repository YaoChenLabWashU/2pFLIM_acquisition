function setupCyclePosition
	global state
	
	done=0;
	looped=0;
	while ~done
		if state.phys.cycle.positionInCycle>size(state.phys.cycle.cycleDef,1)
			state.phys.cycle.positionInCycle=1;
			updateGUIByGlobal('state.phys.cycle.positionInCycle');
			state.phys.cycle.repeatsDone=0;
			updateGUIByGlobal('state.phys.cycle.repeatsDone');
			if looped
				setPhysStatusString('INVALID CYCLE');
				error('setupCyclePosition: unable to find valid cycle position');
			end
			looped=1;
		end
		
		if state.phys.cycle.repeatsDone >= state.phys.cycle.cycleDef(state.phys.cycle.positionInCycle,1)
			state.phys.cycle.positionInCycle=state.phys.cycle.positionInCycle+1;
			updateGUIByGlobal('state.phys.cycle.positionInCycle');
			state.phys.cycle.repeatsDone=0;
			updateGUIByGlobal('state.phys.cycle.repeatsDone');
		else
			state.phys.cycle.pulseToUse0=state.phys.cycle.cycleDef(state.phys.cycle.positionInCycle,3);
			state.phys.cycle.pulseToUse1=state.phys.cycle.cycleDef(state.phys.cycle.positionInCycle,4);
			if state.phys.daq.auxOutputBoardIndex > 0
				state.phys.cycle.auxPulses=state.phys.cycle.cycleDef(state.phys.cycle.positionInCycle, 5:12);
				state.phys.cycle.auxOn=any(state.phys.cycle.auxPulses);
			else
				state.phys.cycle.auxOn=0;
				state.phys.cycle.auxPulses=zeros(1,8);
			end
			
			updateGUIByGlobal('state.phys.cycle.pulseToUse0');
			updateGUIByGlobal('state.phys.cycle.pulseToUse1');
			if (~state.phys.cycle.pulseToUse0 & ~state.phys.cycle.pulseToUse1) | ~state.phys.cycle.cycleDef(state.phys.cycle.positionInCycle,1)
				state.phys.cycle.positionInCycle=state.phys.cycle.positionInCycle+1;
				updateGUIByGlobal('state.phys.cycle.positionInCycle');
				state.phys.cycle.repeatsDone=0;
				updateGUIByGlobal('state.phys.cycle.repeatsDone');
			else
				done=1;
			end
		end
	end
	
			
			
			
