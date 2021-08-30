function valid=findValidCyclePosition
	global state
	
	valid=0;
	
	if state.cycle.randomize
		fullcycle=0;
		first=1;
		startingPosition=state.internal.randomPosition;
		
		while ~valid && ~fullcycle
			% if we're at the end of the cycle, start again
			if state.internal.randomPosition > length(state.internal.randomPositionsList)
				state.internal.randomPosition=1;
				state.cycle.repeatsDone=0;
				disp('*** New cycle started. ***');
			end
			
			% is the current position valid?
			% is imaging on?
			if state.cycle.imageOnList(state.cycle.currentCyclePosition)
				valid=1;
			end
			% if phys on?  and is there a non zero entry in the output list?
			if state.cycle.physOnList(state.cycle.currentCyclePosition)
				if state.cycle.da0List(state.cycle.currentCyclePosition) || state.cycle.da1List(state.cycle.currentCyclePosition) ...
						|| state.cycle.aux4List(state.cycle.currentCyclePosition) || state.cycle.aux5List(state.cycle.currentCyclePosition) ...
						|| state.cycle.aux6List(state.cycle.currentCyclePosition) || state.cycle.aux7List(state.cycle.currentCyclePosition)
					valid=1;
				end
			end
			
			if ~valid
				state.internal.randomPosition = state.internal.randomPosition + 1;
				if state.internal.randomPosition > length(state.internal.randomPositionsList)
					state.internal.randomPosition=1;
					disp('*** New cycle started. ***');
				end
			end
			
			if ~valid && ~first && (startingPosition==state.internal.randomPosition)
				fullcycle=1;
				setStatusString('INVALID CYCLE');
				error('findValidCyclePosition: no valid cycle position found');
			end
			first=0;
			
			state.cycle.currentCyclePosition=state.internal.randomPositionsList(state.internal.randomPosition);
			updateGUIByGlobal('state.cycle.currentCyclePosition');
			if state.internal.randomPosition>1
				state.cycle.repeatsDone=length(find(state.internal.randomPositionsList(1:state.internal.randomPosition-1)==state.cycle.currentCyclePosition));
			else
				state.cycle.repeatsDone=0;
			end
			updateGUIByGlobal('state.cycle.repeatsDone');
		end		
	else
		fullcycle=0;
		first=1;

		startingPosition=state.cycle.currentCyclePosition;
		
		while ~valid && ~fullcycle
            
			% if we did all the repeats, then advance in the cycle
			if state.cycle.repeatsDone>=state.cycle.repeatsList(state.cycle.currentCyclePosition)
				state.cycle.currentCyclePosition = state.cycle.currentCyclePosition + 1;
				state.cycle.repeatsDone=0;
				updateGUIByGlobal('state.cycle.currentCyclePosition');
				updateGUIByGlobal('state.cycle.repeatsDone');
			end
			
			% if we're at the end of the cycle, start again
			if state.cycle.currentCyclePosition > length(state.cycle.delayList)
				state.cycle.currentCyclePosition=1;
				state.cycle.repeatsDone=0;
				updateGUIByGlobal('state.cycle.currentCyclePosition');
				updateGUIByGlobal('state.cycle.repeatsDone');
				disp('*** New cycle started. ***');
			end
			
			% is the current position valid?
			% is imaging on?
			if state.cycle.imageOnList(state.cycle.currentCyclePosition)
				valid=1;
			end
			% if phys on?  and is there a non zero entry in the output list?
			if state.cycle.physOnList(state.cycle.currentCyclePosition)
				valid=1;
			end
			% there is something to do at this position because of a
			% function call
			if ~isempty(state.cycle.functionNameList{state.cycle.currentCyclePosition})
				valid=1;
			end
			
			if ~valid
				state.cycle.currentCyclePosition = state.cycle.currentCyclePosition + 1;
				state.cycle.repeatsDone=0;
				if state.cycle.currentCyclePosition > length(state.cycle.delayList)
					state.cycle.currentCyclePosition=1;
					disp('*** New cycle started. ***');
				end
				updateGUIByGlobal('state.cycle.currentCyclePosition');
				updateGUIByGlobal('state.cycle.repeatsDone');
			end
			
			if ~valid && ~first && (startingPosition==state.cycle.currentCyclePosition)
				fullcycle=1;
				setStatusString('INVALID CYCLE');
				error('findValidCyclePosition: no valid cycle position found');
			end
			first=0;
		end
	end
		
		

