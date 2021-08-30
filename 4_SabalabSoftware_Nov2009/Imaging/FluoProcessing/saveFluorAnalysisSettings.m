function saveFluorAnalysisSettings
	global state gh
	
	if isempty(state.analysis.analysisSetupPath) | isempty(state.analysis.analysisSetupFileName)
		saveFluorAnalysisSettingsAs;
	else
		setStatusString('Saving analysis settings...');

		[fid, message]=fopen(fullfile(state.analysis.analysisSetupPath, [state.analysis.analysisSetupFileName '.ana']), 'wt');
		if fid==-1
			disp(['saveFluorAnalysisSettings: Error cannot open output file ' ...
					fullfile(state.analysis.analysisSetupPath, [state.analysis.analysisSetupFileName '.ana']) ]);
			setStatusString('Can''t open file...');
			return
		end
				
		wins=fieldnames(gh);

		createConfigFileFast(16, fid, 1);
		fclose(fid);
		makeFluorAnalysisMenu;
		setStatusString('');
	end

	