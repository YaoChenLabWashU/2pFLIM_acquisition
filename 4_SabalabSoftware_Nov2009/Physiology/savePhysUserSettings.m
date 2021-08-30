function savePhysUserSettings
	global state gh
	
	if isempty(state.phys.internal.userSettingsPath) | isempty(state.phys.internal.userSettingsName)
		savePhysUserSettingsAs;
	else
		setPhysStatusString('Saving user settings...');

		[fid, message]=fopen(fullfile(state.phys.internal.userSettingsPath, [state.phys.internal.userSettingsName '.usr']), 'wt');
		if fid==-1
			disp(['savePhysUserSettings: Error cannot open output file ' ...
					fullfile(state.phys.internal.userSettingsPath, [state.phys.internal.userSettingsName '.usr']) ]);
			setPhysStatusString('Can''t open file...');
			return
		end
				
		wins=fieldnames(gh);
		
		for winCount=1:length(wins)
			winName=wins{winCount};
			h=getfield(getfield(gh, winName), 'figure1');
			if ishandle(h)
				pos=get(h, 'Position');
				eval(['state.phys.windowPositions.' winName '_position=pos;']);
			end
		end
	
		if ishandle(state.phys.internal.scopeHandle)
			pos=get(state.phys.internal.scopeHandle, 'Position');
			state.phys.windowPositions.scopeWindow_position = pos;
		end
			
		if ishandle(state.phys.internal.pulsePatternPlot)
			pos=get(state.phys.internal.pulsePatternPlot, 'Position');
			state.phys.windowPositions.pulsePatternPlotWindow_position = pos;
		end

		createConfigFileFast(8, fid, 1);
		fclose(fid);
		makeUserSettingsMenu;
		savePhysUserSettingsPath;
		setPhysStatusString('');
	end

	