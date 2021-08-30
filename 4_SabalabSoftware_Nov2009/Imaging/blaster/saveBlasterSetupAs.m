function saveBlasterSetupAs
% save pulse set to disk with new name

	global state
	
	if ~isempty(state.blaster.setupPath)
		try
			cd(state.blaster.setupPath)
		catch
		end			
	end
	
	[fname, pname]=uiputfile('*.mat', 'Choose file for blaster setup');

	if ~isnumeric(fname)
		periods=findstr(fname, '.');
		if any(periods)								
			fname=fname(1:periods(1)-1);
		end		
		fname=[fname '.mat'];
		
		state.blaster.setupName = fname;
		state.blaster.setupPath = pname;
		saveBlasterSetup;
		makeBlasterConfigMenu
	else
		setStatusString('Cannot open file');
	end
	