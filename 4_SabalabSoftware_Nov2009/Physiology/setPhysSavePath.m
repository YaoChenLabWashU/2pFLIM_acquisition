function setPhysSavePath
	global state
	
	if ~isempty(state.files.savePath)
		try
			cd(state.files.savePath)
		catch
		end
	end
	
	[fname, pname]=uiputfile('savepath.txt', 'Select save path');
	if ~isnumeric(fname)
		state.files.savePath=pname;
	end
	
	