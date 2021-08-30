function saveCycleAs
% save pulse set to disk with new name

	global state
	
	if ~isempty(state.cycle.cyclePath)
		try
			cd(state.cycle.cyclePath)
		catch
		end			
	end
	
	[fname, pname]=uiputfile('*.cyc', 'Choose file for cycle');

	if ~isnumeric(fname)
		periods=findstr(fname, '.');
		if any(periods)								
			fname=fname(1:periods(1)-1);
		end		
		fname=[fname '.cyc'];
		
		state.cycle.cycleName = fname;
		state.cycle.cyclePath = pname;
		updateGUIByGlobal('state.cycle.cycleName');
		saveCycle;
		makeCycleMenu;
		checkCurrentCycleInMenu;		
	else
		setStatusString('Cannot open file');
	end
	