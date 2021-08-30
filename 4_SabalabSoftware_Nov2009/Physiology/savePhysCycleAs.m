function savePhysCycleAs
% save pulse set to disk with new name

	global state
	
	if ~isempty(state.phys.cycle.cyclePath)
		try
			cd(state.phys.cycle.cyclePath)
		catch
		end			
	end
	
	[fname, pname]=uiputfile('*.epc', 'Choose file for cycle');

	if ~isnumeric(fname)
		periods=findstr(fname, '.');
		if any(periods)								
			fname=fname(1:periods(1)-1);
		end		
		fname=[fname '.epc'];
		
		state.phys.cycle.cycleName = fname;
		state.phys.cycle.cyclePath = pname;
		updateGUIByGlobal('state.phys.cycle.cycleName');
		savePhysCycle;
		savePhysCycleInMemory;	
		makeCycleMenu;
		checkCurrentCycleInMenu;		
	else
		setPhysStatusString('Cannot open file');
	end
	