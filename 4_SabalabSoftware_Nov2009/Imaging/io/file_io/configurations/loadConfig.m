function loadConfig()
	global state;
	out=0;
	
	configSelected=1;
	
	if isnumeric(state.configName) || isempty(state.configName)
		configSelected=0;
	else	
		[flag, fname, pname, ext]=initGUIs([state.configPath '\' state.configName '.cfg'], 0);
		if flag==0
			configSelected=0;
		end
    end
    
    if state.acq.msPerLine<0.01
        disp('state.acq.msPerLine was loaded as less than 0.01.  Assuming error')
        state.acq.msPerLine=state.acq.msPerLine*1000;
        disp(['state.acq.msPerLine = ' num2str(state.acq.msPerLine)])
        disp('*** Suggest resaving the configuration');
    end
    
	if configSelected
		setStatusString('Config read in...');
		state.configName=fname;
		state.configPath=pname;
	else
		setStatusString('Using config in memory');
		disp('loadConfig: No configuration selected.  Using parameters currently in memory');
		state.configName='Default';
		state.configPath='';
	end

	updateChannelFlags;
%	state.internal.configurationChanged=1;
%    closeConfigurationGUI;
	setAcquisitionParameters
 	updateDataForConfiguration;
 	state.internal.configurationChanged=0;

	setStatusString('');

	