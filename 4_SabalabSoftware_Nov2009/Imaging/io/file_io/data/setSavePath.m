function setSavePath
	global state
	
	if ~isempty(state.files.savePath)
		try
			cd(state.files.savePath)
		catch
		end
	end
	
	[fname, pname]=uiputfile('save_path', 'Choose a save path');
	if isnumeric(fname)
		return
	end
			
	setStatusString('Setting Path...');
	state.files.savePath=pname;
	updateFullFileName(0);
	cd(pname);

	if ~isempty(state.internal.excelChannel)
		try
			ddepoke(state.internal.excelChannel, 'r5c2', state.files.savePath);
		catch
			disp('setSavePath : Unable to link to excel');
		end
	end
	
	setStatusString('')	
	disp(['*** SAVE PATH = ' state.files.savePath ' ***']);
	
	
