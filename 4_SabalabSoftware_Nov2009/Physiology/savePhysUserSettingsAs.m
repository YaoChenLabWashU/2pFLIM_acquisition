function savePhysCycleAs
% save pulse set to disk with new name

	global state
	
	if ~isempty(state.phys.internal.userSettingsPath)
		try
			cd(state.phys.internal.userSettingsPath)
		catch
		end
	end
	
	[fname, pname]=uiputfile('*.usr', 'Choose file for physiology user settings');

	if ~isnumeric(fname)
		periods=findstr(fname, '.');
		if any(periods)								
			fname=fname(1:periods(1)-1);
		end		
		state.phys.internal.userSettingsName = fname;
		fname=[fname '.usr'];
		
		state.phys.internal.userSettingsPath = pname;
		savePhysUserSettings;
	else
		setPhysStatusString('Cannot open file');
	end
	