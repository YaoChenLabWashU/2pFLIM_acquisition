function lmSaveSettings(fileName)
	global state
	
	if (nargin<1) || isempty(fileName)
		[fname, pname]=uiputfile('*.mat', 'Select file for settings');
		if isempty(fname) || isnumeric(fname)
			return
		end
		fileName=fullfile(pname, fname);
	end

	saveFields=state.lm;
	
	if isfield(state.lm, 'devices')
		saveFields=rmfield(state.lm, 'devices');
	else
		saveFields=state.lm;		
	end
	
	save(fileName, 'saveFields');
	
	
	

		