function lmMakeDeviceIDList
	global state gh
    
	devs=daqhwinfo('nidaq');
	
	state.lm.deviceIDs=cell(1, length(devs.BoardNames));
	
	for counter=1:length(state.lm.deviceIDs)
		state.lm.deviceIDs{counter}=[devs.InstalledBoardIds{counter} ' ' devs.BoardNames{counter}];
	end
	
	counter=1;

	while isfield(state.lm, ['paramName' num2str(counter)])
		h=getfield(gh.lmSettings, ['dev' num2str(counter)]);
		if ishandle(h)
			set(h, 'String', state.lm.deviceIDs);
			if get(h, 'Value')>length(state.lm.deviceIDs)
				eval(['gh.lmSettings.dev' num2str(counter) '=1;']);
				updateGUIByGlobal(['gh.lmSettings.dev' num2str(counter)]);
			end
		end
		counter=counter+1;
	end