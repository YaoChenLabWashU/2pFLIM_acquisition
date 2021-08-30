function setAnalysisFunctionPath
	global state gh
	
	if ~isempty(state.phys.settings.analysisFunctionPath)
		try
			cd(state.phys.settings.analysisFunctionPath)
		catch
		end			
	end
	
	[fname, pname]=uiputfile('savepath.m', 'Select analysis function path');
	if ~isnumeric(fname)
		state.phys.settings.analysisFunctionPath=pname;
	end
	
	makeAnalysisFunctionMenu;