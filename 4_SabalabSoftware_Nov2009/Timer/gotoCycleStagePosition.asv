function gotoCycleStagePosition(forceMovement)
	global state
	
	if nargin<1
		forceMovement=0;
	end

	if state.cycle.stagePosList(state.cycle.currentCyclePosition)>0
		if forceMovement ...
				|| (state.acq.numberOfZSlices>1 ) ...
				|| (state.cycle.lastPositionUsed~=state.cycle.currentCyclePosition)...
				|| (state.cycle.lastStagePosition~=state.cycle.stagePosList(state.cycle.currentCyclePosition))
			gotoPosition(state.cycle.stagePosList(state.cycle.currentCyclePosition));
			state.cycle.lastStagePosition=state.cycle.stagePosList(state.cycle.currentCyclePosition);
		else
			disp('*** No new stage movement made.  Assuming correct position from last acquisition ***');
		end
	end
	