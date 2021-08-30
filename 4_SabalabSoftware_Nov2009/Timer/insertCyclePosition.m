function insertCyclePosition(position)
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
		if strcmp(state.internal.cycleListNames{counter}, 'frames')
			new=1;
		elseif strcmp(state.internal.cycleListNames{counter}, 'delay')
			new=10;
		elseif strcmp(state.internal.cycleListNames{counter}, 'repeats')
			new=1;
		elseif strcmp(state.internal.cycleListNames{counter}, 'zStepSize')
			new=1;
		elseif strcmp(state.internal.cycleListNames{counter}, 'numberOfZSlices')
			new=1;
		elseif strcmp(state.internal.cycleListNames{counter}, 'functionName')
			new={''};
		else
			new=0;
		end
		eval(['state.cycle.' state.internal.cycleListNames{counter} ...
				'List(position+1:end+1) = state.cycle.' state.internal.cycleListNames{counter} 'List(position:end);']);
		eval(['state.cycle.' state.internal.cycleListNames{counter} 'List(position)=new;']);
    end
    if state.cycle.randomize 
        setupCycleRandomList
    end
	updateCycleDisplay(position);

