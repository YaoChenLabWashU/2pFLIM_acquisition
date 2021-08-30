function checkCurrentCycleInMenu(name)
	global state gh
	if nargin<1
		name=state.cycle.cycleName;
	end

	children=get(gh.timerMainControls.Cycles, 'Children');
	index=find(strcmp(get(children, 'Label'), name));
	set(children, 'Checked', 'off');
	if ~isempty(index)
		set(children(index), 'Checked', 'on');
	end

