function makeBlasterConfigMenu
	global state gh
	
	children=get(gh.blaster.Config, 'Children');
	if ~isempty(children)
		delete(children);
	end

	if ~isempty(state.blaster.setupName)
		uimenu(gh.blaster.Config, 'Label', [state.blaster.setupName ' now loaded'], 'Enable', 'on');
	else
		uimenu(gh.blaster.Config, 'Label', ['Setup not save'], 'Enable', 'on');
	end	
	uimenu(gh.blaster.Config, 'Label', 'Add configuration to setup', 'Enable', 'on', 'Callback', 'blasterNewConfiguration', 'Separator', 'on');
	
	for counter=1:size(state.blaster.allConfigs,1)
		if counter==state.blaster.currentConfig
			check='on';
		else
			check='off';
		end
		if counter==1
			uimenu(gh.blaster.Config, 'Label', [num2str(counter) ' ' state.blaster.allConfigs{counter, 1}], 'Callback', 'selectBlasterConfigFromMenu', 'Checked', check ...
				, 'Separator', 'on');
		else
			uimenu(gh.blaster.Config, 'Label', [num2str(counter) ' ' state.blaster.allConfigs{counter, 1}], 'Callback', 'selectBlasterConfigFromMenu', 'Checked', check);
		end
	end
