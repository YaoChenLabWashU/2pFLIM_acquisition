function makeFluorAnalysisMenu
	global state gh
	
	if ishandle(state.analysis.analysisSetupMenu)
		delete(state.analysis.analysisSetupMenu);
	end
	
	if ~isempty(state.analysis.analysisSetupPath)
		state.analysis.analysisSetupMenu=uimenu(gh.fluorAnalysisSettings.figure1, 'Label', 'Setups');
		flist=dir(fullfile(state.analysis.analysisSetupPath, '*.ana'));
		uimenu(state.analysis.analysisSetupMenu, 'Label', state.analysis.analysisSetupPath, 'Enable', 'on');
		
		for counter=1:length(flist)	
			if counter==1
				uimenu(state.analysis.analysisSetupMenu, 'Label', flist(counter).name, 'Callback', 'selectFluorAnalysisFromMenu' ...
					, 'Separator', 'on');
			else
				uimenu(state.analysis.analysisSetupMenu, 'Label', flist(counter).name, 'Callback', 'selectFluorAnalysisFromMenu');
			end
		end
	end		