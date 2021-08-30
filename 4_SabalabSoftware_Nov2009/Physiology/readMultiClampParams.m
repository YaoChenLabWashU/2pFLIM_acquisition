function readMultiClampParams(channel)
	global state

    filename=['c:\multiclamptextfiles\MClampChannel' num2str(channel+1) '.txt'];
	try
		text = textread(filename, '%s', 'headerlines', 0, 'delimiter', '\n');
	catch
		disp(['!!! readMultiClampParams: ' filename ' does not exist']);
		return
	end

	mode=text{2};
	switch mode(7:end)
	case 'V-Clamp'
		if getfield(state.phys.settings, ['currentClamp' num2str(channel)])
			setVoltageClamp(channel);
		end
	case 'I-Clamp'
		if ~getfield(state.phys.settings, ['currentClamp' num2str(channel)])
			setCurrentClamp(channel);
		end
	case 'I = 0'
		if ~getfield(state.phys.settings, ['currentClamp' num2str(channel)])
			setCurrentClamp(channel);
		end
	otherwise
		error(['readMultiClampParams: read unknown mode: ' mode]);
	end
	
	gain=text{3};
	gain=str2num(gain(7:end));
	
	eval(['state.phys.settings.inputGain' num2str(channel) '=gain;']);
	updateGUIByGlobal(['state.phys.settings.inputGain' num2str(channel)]);