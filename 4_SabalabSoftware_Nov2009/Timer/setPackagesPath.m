function setPackagesPath
	global state gh
	
	if ~isempty(state.timer.packagesPath)
		try
			cd(state.timer.packagesPath)
		catch
		end
	end
	
	[fname, pname]=uiputfile('savepath.m', 'Select packages path');
	if ~isnumeric(fname)
		state.timer.packagesPath=pname;
		makeTimerPackagesMenu;
	end
	
