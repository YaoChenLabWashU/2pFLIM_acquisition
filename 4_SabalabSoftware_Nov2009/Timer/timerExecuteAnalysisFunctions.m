function timerExecuteAnalysisFunctions
	global gh state
	
	if ~ishandle(gh.timerMainControls.Analysis)
		return
	end
	
	if isempty(state.timer.analysisFunctionPath)
		return
	end
	current_cd=cd;
	
	global state
	cd(state.timer.analysisFunctionPath);
	children=get(gh.timerMainControls.Analysis, 'Children');
	checked=children(strcmp(get(children, 'Checked'), 'on'));

	for counter=1:length(checked)
		disp(['Executing user analysis ' get(checked(length(checked)-counter+1), 'Label')]);
		eval(get(checked(length(checked)-counter+1), 'Label'));
	end
	cd(current_cd);