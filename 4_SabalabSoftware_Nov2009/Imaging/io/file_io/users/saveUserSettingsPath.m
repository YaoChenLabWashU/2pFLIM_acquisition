function saveUserSettingsPath(userPath)

	if nargin<1
		global state
		userPath=state.userSettingsPath;
	end
	save(...
		fullfile(matlabroot, 'lastUserPath.mat'), 'userPath', '-mat');
	

	