function selectConfigurationFromMenu(forceName)
	global state gh

	h=gcbo;
		
	setStatusString('Reading config file...');
	children=get(gh.siGUI_ImagingControls.Configurations, 'Children');

	if nargin<1
		index=find(children==h);
	else
		index=find(strcmp(get(children, 'Label'), forceName));
	end
	[path,name,ext] = fileparts(get(children(index), 'Label'));
	state.configName=name;
	state.configPath=get(children(end), 'Label');

    loadConfig
	%loadStandardModeConfig;
