function selectPackageFromMenu
	global state gh

	h=gcbo;
	children=get(gh.timerMainControls.Packages, 'Children');
	index=find(children==h);
	checked=get(children(index), 'Checked');
	if strcmp(checked, 'off')
		timerSetActiveStatus(get(children(index), 'Label'), 1); 	% it was off, turn it on
	else
		timerSetActiveStatus(get(children(index), 'Label'), 0); 	% it was on, turn it off
	end
	
