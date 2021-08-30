function executeAnalysisFunctions
	global state gh
	
	if ~ishandle(gh.physControls.Analysis)
		return
	end
	
	children=get(gh.physControls.Analysis, 'Children');
	checked=children(strcmp(get(children, 'Checked'), 'on'));

	for counter=1:length(checked)
		eval(get(checked(length(checked)-counter+1), 'Label'));
	end