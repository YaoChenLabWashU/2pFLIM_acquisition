function deleteCyclePosition(position)
	global state

	if nargin<1
		position=state.cycle.displayCyclePosition;
	else
		if position>length(state.cycle.delayList)
			return
		end
	end
	
	state.internal.cycleChanged=1;
	for counter=1:length(state.internal.cycleListNames)
		eval(['state.cycle.' state.internal.cycleListNames{counter} 'List(position) = [];']);
	end
	if position>length(state.cycle.delayList)
		updateCycleDisplay(position-1);
	else
		updateCycleDisplay(position);
    end			

    
    if state.cycle.randomize 
        setupCycleRandomList
    end