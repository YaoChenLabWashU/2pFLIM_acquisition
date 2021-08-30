function updateCycleDisplay(position)
	global state

	createPosition=0;
	if nargin<1
		position=state.cycle.displayCyclePosition;
	else
		if position>length(state.cycle.delayList)
			position=length(state.cycle.delayList)+1;
			createPosition=1;
            if state.cycle.randomize 
                setupCycleRandomList
            end            
		end
		state.cycle.displayCyclePosition=position;
		updateGUIByGlobal('state.cycle.displayCyclePosition');
	end
	
	for counter=1:length(state.internal.cycleListNames)
		if createPosition
			if strcmp(state.internal.cycleListNames{counter}, 'frames')
				state.cycle.framesList(state.cycle.displayCyclePosition)=1;
			elseif strcmp(state.internal.cycleListNames{counter}, 'delay')
				state.cycle.delayList(state.cycle.displayCyclePosition)=10;
			elseif strcmp(state.internal.cycleListNames{counter}, 'repeats')
				state.cycle.repeatsList(state.cycle.displayCyclePosition)=1;
			elseif strcmp(state.internal.cycleListNames{counter}, 'zStepSize')
				state.cycle.zStepSizeList(state.cycle.displayCyclePosition)=1;
			elseif strcmp(state.internal.cycleListNames{counter}, 'numberOfZSlices')
				state.cycle.numberOfZSlicesList(state.cycle.displayCyclePosition)=1;
			elseif strcmp(state.internal.cycleListNames{counter}, 'functionName')
				state.cycle.functionNameList{state.cycle.displayCyclePosition}='';
			else
				eval(['state.cycle.' state.internal.cycleListNames{counter} 'List(state.cycle.displayCyclePosition) = 0;']);
			end
		end
		if isnumeric(getfield(state.cycle, state.internal.cycleListNames{counter}))
			eval(['state.cycle.' state.internal.cycleListNames{counter} '=state.cycle.' state.internal.cycleListNames{counter} 'List(state.cycle.displayCyclePosition);']);
		else
			eval(['state.cycle.' state.internal.cycleListNames{counter} '=state.cycle.' state.internal.cycleListNames{counter} 'List{state.cycle.displayCyclePosition};']);
		end
		updateGUIByGlobal(['state.cycle.' state.internal.cycleListNames{counter}]);
    end
	

	timerCallPackageFunctions('CycleChanged');
