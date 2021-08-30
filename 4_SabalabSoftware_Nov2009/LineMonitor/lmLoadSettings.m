function lmLoadSettings(fileName)
	global state
	
	if (nargin<1) || isempty(fileName)
		[fname, pname]=uigetfile('*.mat', 'Select file for settings');
		if isempty(fname) || isnumeric(fname)
			return
		end
		fileName=fullfile(pname, fname);
	end

	loaded=load(fileName);
	
	fnames=fieldnames(loaded.saveFields);
	for counter=1:length(fnames)
		fname=fnames{counter};
		if ~strcmp(fname, 'devices')
			eval(['state.lm.' fname '=loaded.saveFields.' fname ';']);
			updateGUIByGlobal(['state.lm.' fname]);
		end
	end
	lmBuildDAQs
	
	
	

	
	
	

		