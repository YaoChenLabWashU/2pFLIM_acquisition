function setUserSettingsPath
	global state

	if nargin<1
		if ~isempty(state.userSettingsPath)
			try
				cd(state.userSettingsPath);
			catch
			end
		end
		[fname, pname]=uiputfile('userPath.usr', 'Choose user settings path');
	end

	if ~isnumeric(pname) 
		state.userSettingsPath = pname;
	end
	makeUserSettingsMenu;

	
	