function updateMinInCell(clockTime)

	if nargin<1
		clockTime=clock;
	end
	
	global state
	
	if ~isempty(state.phys.cellParams.breakInClock0)
		state.phys.cellParams.minInCell0=round(1000*etime(clockTime,state.phys.cellParams.breakInClock0)/60)/1000;
	else
		state.phys.cellParams.minInCell0=NaN;
	end
	updateGUIByGlobal('state.phys.cellParams.minInCell0');

	if ~isempty(state.phys.cellParams.breakInClock1)
		state.phys.cellParams.minInCell1=round(1000*etime(clockTime,state.phys.cellParams.breakInClock1)/60)/1000;
	else
		state.phys.cellParams.minInCell1=NaN;
	end
	updateGUIByGlobal('state.phys.cellParams.minInCell1');

