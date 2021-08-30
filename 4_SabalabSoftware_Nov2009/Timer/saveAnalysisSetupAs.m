function saveAnalysisSetupAs


	global state
	
	if ~isempty(state.analysis.setupPath)
		try
			cd(state.analysis.setupPath)
		catch
		end			
	end
	
	[fname, pname]=uiputfile('*.ana', 'Choose file for analysis setup');

	if ~isnumeric(fname)
		periods=findstr(fname, '.');
		if any(periods)								
			fname=fname(1:periods(1)-1);
		end		
		fname=[fname '.ana'];
		
		state.analysis.setupName = fname;
		state.analysis.setupPath = pname;
		saveAnalysisSetup;
% 		makeAnalysisMenu;
% 		checkCurrentAnalysis;		
	else
		setStatusString('Cannot open file');
	end