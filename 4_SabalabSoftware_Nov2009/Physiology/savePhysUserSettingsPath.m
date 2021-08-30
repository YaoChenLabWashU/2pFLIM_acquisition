function savePhysUserSettingsPath(userPath)

	if nargin<1
		global state
		userPath=state.phys.internal.userSettingsPath;
	end
	save(fullfile(matlabroot, 'work', 'BS_Phys', ['lastUserPath.mat']), ...
		'userPath', '-mat');
	

	