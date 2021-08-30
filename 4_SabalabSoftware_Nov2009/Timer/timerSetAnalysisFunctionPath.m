function timerSetAnalysisFunctionPath
	global state 
	
	if ~isempty(state.timer.analysisFunctionPath)
		try
			cd(state.timer.analysisFunctionPath)
		catch
		end			
	end
	
	[fname, pname]=uiputfile('savepath.m', 'Select analysis function path');
	if ~isnumeric(fname)
		state.timer.analysisFunctionPath=pname;
	end
	
	timerMakeAnalysisFunctionMenu;