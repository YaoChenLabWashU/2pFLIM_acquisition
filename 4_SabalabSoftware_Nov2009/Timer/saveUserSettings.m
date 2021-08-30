function saveUserSettings
	global state gh
	
	if isempty(state.userSettingsPath) || isempty(state.userSettingsName)
		saveUserSettingsAs;
	else
		setStatusString('Saving user settings...');

		[fid, message]=fopen(fullfile(state.userSettingsPath, [state.userSettingsName '.usr']), 'wt');
		if fid==-1
			disp(['saveUserSettings: Error cannot open output file ' ...
			fullfile(state.userSettingsPath, [state.userSettingsName '.usr']) ]);
			setStatusString('Can''t open file...');
			return
		end
	
		recordWindowPositions
		createConfigFileFast(4, fid, 1);
		fclose(fid);
		setStatusString('Saved user settings');
	end

	