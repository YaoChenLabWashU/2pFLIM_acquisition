function setCyclesPath(pname)
	global state

	if nargin<1
		if ~isempty(state.cycle.cyclePath)
			try
				cd(state.cycle.cyclePath);
			catch
			end
		end
		[fname, pname]=uiputfile('cyclePath.cyc', 'Choose cycle path');
	end

	if ~isnumeric(pname) 
		state.cycle.cyclePath = pname;
	end
	makeCycleMenu;
	checkCurrentCycleInMenu;
	
	