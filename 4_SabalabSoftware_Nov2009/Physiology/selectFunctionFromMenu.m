function selectFunctionFromMenu
	
	global state gh
	h=gcbo;
	children=get(gh.physControls.Analysis, 'Children');
	index=find(children==h);
	checked=get(children(index), 'Checked');
	if ~strcmp(checked, 'off')
		set(children(index), 'Checked', 'off');
	else
		set(children(index), 'Checked', 'on');
	end		
		
