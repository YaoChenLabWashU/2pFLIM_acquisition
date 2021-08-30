function setConfigurationsPath
	global state

	if nargin<1
		if ~isempty(state.configPath)
			try
				cd(state.configPath);
			catch
			end
		end
		[fname, pname]=uiputfile('configPath.cfg', 'Choose configuration path');
	end

	if ~isnumeric(pname) 
		state.configPath = pname;
	end
	makeConfigurationMenu;

	
	