function makeAnalysisFunctionMenu
	
	global state gh
	
	children=get(gh.physControls.Analysis, 'Children');
	
	if length(children)>3
		delete(children(1:end-3));
	end
	children=get(gh.physControls.Analysis, 'Children');
	
	if ~isempty(state.phys.settings.analysisFunctionPath)
		flist=dir([state.phys.settings.analysisFunctionPath '\postAnalysis*.m']);
		
		set(children(1), 'Label', state.phys.settings.analysisFunctionPath);
		
		for counter=1:length(flist)	
			period=find(flist(counter).name=='.');
			fname=flist(counter).name(1:period-1);
			if counter==1
				uimenu(gh.physControls.Analysis, 'Label', fname, 'Callback', 'selectFunctionFromMenu' ...
					, 'Separator', 'on');
			else
				uimenu(gh.physControls.Analysis, 'Label', fname, 'Callback', 'selectFunctionFromMenu');
			end
		end
	else
		uimenu(gh.physControls.Analysis, 'Label', 'Set Analysis Function Path...', 'Enable', 'on', ...
			'Callback', 'setAnalysisFunctionPath');
	end		