function selectCycleFromMenu
	global state gh
	
	h=gcbo;
	children=get(gh.timerMainControls.Cycles, 'Children');
	index=find(children==h);
	
	name=get(children(index), 'Label');
	period=find(name=='.');
	if ~isempty(period)
		name=name(1:period(1)-1);
	end
	loadCycle(get(children(end-1), 'Label'), get(children(index), 'Label'));
