function varargout =saveCurrentConfigAs
	global state

	if ~isempty(state.configPath)
		try
			cd(state.configPath)
		catch
		end
	end
	
	[fname, pname]=uiputfile('*.cfg', 'Choose configuration name');

	if ~isnumeric(fname)
		setStatusString('Saving config...');
	
		periods=findstr(fname, '.');
		if any(periods)								
			fname=fname(1:periods(1)-1);
		end		
		state.configName=fname;
		state.configPath=pname;
		updateGUIByGlobal('state.configName');
		saveCurrentConfig;
		makeConfigurationMenu;
		setStatusString('');
		state.internal.configurationNeedsSaving=0;
	else
		setStatusString('Cannot open file');
	end
