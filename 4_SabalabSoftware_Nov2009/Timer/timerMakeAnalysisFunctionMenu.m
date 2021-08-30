function timerMakeAnalysisFunctionMenu
	
	global state gh
	
	children=get(gh.timerMainControls.Analysis, 'Children');
	
	if length(children)>1
		delete(children(1:end-1));
	end
	children=get(gh.timerMainControls.Analysis, 'Children');
	
	if ~isempty(state.timer.analysisFunctionPath)
		flist=dir([state.timer.analysisFunctionPath '\*.m']);
		
		set(children(1), 'Label', state.timer.analysisFunctionPath);
		
		for counter=1:length(flist)	
			period=find(flist(counter).name=='.');
			fname=flist(counter).name(1:period-1);
			if counter==1
				uimenu(gh.timerMainControls.Analysis, ...
					'Label', fname, 'Callback', 'timerSelectFunctionFromMenu' ...
					, 'Separator', 'on');
			else
				uimenu(gh.timerMainControls.Analysis, 'Label', fname, 'Callback', 'timerSelectFunctionFromMenu');
			end
		end
	else
		uimenu(gh.timerMainControls.Analysis, 'Label', 'Set Analysis Function Path...', 'Enable', 'on', ...
			'Callback', 'timerSetAnalysisFunctionPath');
	end		