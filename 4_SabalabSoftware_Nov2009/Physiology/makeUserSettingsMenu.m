function makeUserSettingsMenu
	global state gh
	
	children=get(gh.timerMainControls.Users, 'Children');
	if ~isempty(children)
		delete(children);
	end
	
	if ~isempty(state.userSettingsPath)
		flist=dir(fullfile(state.userSettingsPath, '*.usr'));
		uimenu(gh.timerMainControls.Users, 'Label', state.userSettingsPath, 'Enable', 'on', 'Callback', 'setUserSettingsPath');
		
		for counter=1:length(flist)	
			if counter==1
				uimenu(gh.timerMainControls.Users, 'Label', flist(counter).name, 'Callback', 'selectUserSettingsFromMenu' ...
					, 'Separator', 'on');
			else
				uimenu(gh.timerMainControls.Users, 'Label', flist(counter).name, 'Callback', 'selectUserSettingsFromMenu');
			end
		end
	else		
		uimenu(gh.timerMainControls.Users, 'Label', 'Set User Settings Path...', 'Enable', 'on', 'Callback', 'setUserSettingsPath');
	end