function selectFluorAnalysisFromMenu
	global state

	h=gcbo;
	children=get(state.analysis.analysisSetupMenu, 'Children');
	index=find(children==h);
	loadFluorAnalysisSettings(get(children(end), 'Label'), get(children(index), 'Label'));