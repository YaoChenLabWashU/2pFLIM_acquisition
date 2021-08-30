function saveFluorAnalysisSettingsAs

	global state
	
	if ~isempty(state.analysis.analysisSetupPath)
		try
			cd(state.analysis.analysisSetupPath)
		catch
		end
	end
	
	[fname, pname]=uiputfile('*.ana', 'Choose file for fluorescence analysis settings');

	if ~isnumeric(fname)
		periods=findstr(fname, '.');
		if any(periods)								
			fname=fname(1:periods(1)-1);
		end		
		state.analysis.analysisSetupFileName = fname;
		fname=[fname '.ana'];
		
		state.analysis.analysisSetupPath = pname;
		saveFluorAnalysisSettings;
	else
		setStatusString('Cannot open file');
	end
	