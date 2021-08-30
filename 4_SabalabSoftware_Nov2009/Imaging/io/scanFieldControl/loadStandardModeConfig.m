function loadStandardModeConfig()
	global state;
	out=0;
	
	configSelected=1;
	
	if isnumeric(state.configName) | length(state.configName)==0
		configSelected=0;
	else	
		[flag, fname, pname, ext]=initGUIs([state.configPath '\' state.configName '.cfg'], 0);
		if flag==0
			configSelected=0;
		end
	end

	if configSelected
		setStatusString('Config read in...');
		state.configName=fname;
		state.configPath=pname;
	else
		setStatusString('Using config in memory');
		disp('loadStandardModeConfig: No configuration selected.  Using parameters currently in memory');
		state.configName='Default';
		state.configPath='';
	end

	updateChannelFlags;
	updateDataForConfiguration;
	state.internal.configurationChanged=0;

	setStatusString('');

	