function lmBuildDAQs

	global state
	
	counter=1;
	devList={};
	activeList=[];
	adList=[];
	
	while isfield(state.lm, ['paramName' num2str(counter)])
		if (getfield(state.lm, ['active' num2str(counter)])==1) && ...
			(getfield(state.lm, ['dev' num2str(counter)])>0)
			devSelection=getfield(state.lm, ['dev' num2str(counter)]);
			if (devSelection>0) && (devSelection<=length(state.lm.deviceIDs))
				devSelection=state.lm.deviceIDs{getfield(state.lm, ['dev' num2str(counter)])};
                spaceFind=findstr(devSelection, ' ');
				devList{end+1}=devSelection(1:spaceFind-1); 
			else
				eval(['state.lm.dev' num2str(counter) '=1;']);
				updateGUIByGlobal(['state.lm.dev' num2str(counter)]);
				devList(end+1)=1; 
			end
			adList(end+1)=getfield(state.lm, ['ad' num2str(counter)]);
			activeList(end+1)=counter;
			seeGUI(['gh.lmSettings.paramName' num2str(counter)]);
			seeGUI(['gh.lmSettings.paramValue' num2str(counter)]);
		else
			hideGUI(['gh.lmSettings.paramName' num2str(counter)]);
			hideGUI(['gh.lmSettings.paramValue' num2str(counter)]);
			eval(['state.lm.paramValue' num2str(counter) '=NaN;']);
			updateGUIByGlobal(['state.lm.paramValue' num2str(counter)]);
		end
		counter=counter+1;
	end
	
	
	if ~state.lm.lineMonitorActive
		return
	end
	
	if ~isempty(state.lm.devices)
		for counter=1:length(state.lm.devices)
			try
				delete(state.lm.devices.deviceHandle);
			catch
			end
		end
		state.lm.devices=struct;
	end
	if isempty(devList)	
		return
	end
	
	minDevList=unique(devList);
	
	state.lm.devices=struct;
	for devCounter=1:length(minDevList)
        try
			ad=[];
			state.lm.devices(devCounter).deviceHandle=analoginput('nidaq',minDevList{devCounter});
            ind=[];
            for cc=1:length(devList)
                if strcmp(devList{cc}, minDevList{devCounter})
                    ind(end+1)=cc;
                end
            end
			if length(adList(ind))~=length(unique(adList(ind)))
				error('Multiple lines on a single device have the same ad channel assigned')
			end
			state.lm.devices(devCounter).channels=adList(ind);
			state.lm.devices(devCounter).params=activeList(ind);
			for ad=adList(ind)
				channel=addchannel(state.lm.devices(devCounter).deviceHandle, ad);
				channel.InputRange = [-10 10];
				channel.SensorRange = [-10 10];
				channel.UnitsRange = [-10 10];
			end
		catch
			state.lm.devices(devCounter).deviceHandle=[];
			state.lm.devices(devCounter).channels=[];
			state.lm.devices(devCounter).params=[];
			if isempty(ad)
				adTxt='all';
			else 
				adTxt=num2str(ad);
			end
			disp(['LineMonitor: Failed to create DAQ for device: Dev' minDevList{devCounter} ' line: ' adTxt]);
		end
		
	end
		