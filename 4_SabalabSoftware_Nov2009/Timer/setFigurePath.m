function setFigurePath
	global state
	
	if ~isempty(state.figurePath)
		try
			cd(state.figurePath)
		catch
		end
	end
	
	[fname, pname]=uiputfile('Figure path', 'Choose a figure path');
	if isnumeric(fname)
		return
	end
			
	state.figurePath=pname;

	
	
