function loadPhysCycle(pname, fname)
	global state

	if nargin<2
		if ~isempty(state.phys.cycle.cyclePath)
			try
				cd(state.phys.cycle.cyclePath);
			catch
			end
		end
		[fname, pname]=uigetfile('*.epc', 'Choose cycle');
	end

	state.phys.cycle.startingPos=1;
	state.phys.cycle.startingPosFlip=101-state.phys.cycle.startingPos;
	updateGUIByGlobal('state.phys.cycle.startingPosFlip');
	
	if ~isnumeric(fname) & ~isempty(fname)
		cycle=load(fullfile(pname, fname), '-MAT');
		state.phys.cycle.cycleDef=cycle.cycle.cycleDef;
		if size(state.phys.cycle.cycleDef,2)<12
			state.phys.cycle.cycleDef(end,12)=0;
		end
		state.phys.cycle.rsPulseVC=cycle.cycle.rsPulseVC;
		state.phys.cycle.rsPulseCC=cycle.cycle.rsPulseCC;
		
		state.phys.cycle.cycleName = fname;
		state.phys.cycle.cyclePath = pname;
		makeCycleMenu;
		checkCurrentCycleInMenu;
		redrawPhysCycle;
		setPhysStatusString('cycle loaded');
	else
		setPhysStatusString('Cannot cycle');
	end
	
	