function setPhysUserSettingsPath
	fid=fopen(fullfile(matlabroot, 'work', 'BS_Phys', ['lastUserPath.mat']), 'r');	% try to open file to ensure it exists
	if fid==-1												% error on opening, abort
		return
	end
	fclose(fid);	% no error, file exists, close it
	userPath=[];
	load(fullfile(matlabroot, 'work', 'BS_Phys', ['lastUserPath.mat']), '-mat');			% load file as MATLAB workspace file
	if exist(userPath, 'dir')
		cd(userPath);
	end
	