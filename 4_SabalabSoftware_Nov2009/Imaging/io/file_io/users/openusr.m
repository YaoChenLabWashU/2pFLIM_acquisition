function out=openusr(fileName)
	out=1;
	[fid, message]=fopen(fileName);
	if fid<0
		disp(['openusr: Error opening ' fileName ': ' message]);
		out=1;
		return
	end
	[fileName,permission, machineormat] = fopen(fid);
	fclose(fid);
	
	disp(['*** CURRENT USER SETTINGS FILE = ' fileName ' ***']);
	initGUIs(fileName);
	
	[path,name,ext] = fileparts(fileName);
	
	global state
	
	state.userSettingsName=name;
	state.userSettingsPath=path;

	saveUserSettingsPath;
	makeUserSettingsMenu;
		


