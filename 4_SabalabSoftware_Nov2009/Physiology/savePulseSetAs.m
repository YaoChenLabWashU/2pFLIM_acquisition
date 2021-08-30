function savePulseSetAs
% save pulse set to disk with new name

	global state
	
	if ~isempty(state.pulses.pulseSetPath)
		try
			cd(state.pulses.pulseSetPath)
		catch
		end
	end
	
	[fname, pname]=uiputfile('*.mat', 'Choose file for pulse set');

	if ~isnumeric(fname)
		periods=findstr(fname, '.');
		if any(periods)								
			fname=fname(1:periods(1)-1);
		end		
		state.pulses.pulseSetName = fname;
		state.pulses.pulseSetPath = pname;
		updateGUIByGlobal('state.pulses.pulseSetName');
		savePulseSet;
	else
		setPhysStatusString('Cannot open file');
	end
	