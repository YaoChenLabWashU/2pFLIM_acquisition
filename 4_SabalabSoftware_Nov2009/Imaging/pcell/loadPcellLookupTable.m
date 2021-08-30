function loadPcellLookupTable(chan)
	global state
	
	if ~isempty(state.pcell.pcellTablePath)
		try
			cd(state.pcell.pcellTablePath)
		catch
		end
	end
	
	[fname, pname]=uigetfile('*.pow', 'Choose pcell power table');

	if ~isnumeric(fname)
		periods=findstr(fname, '.');
		if any(periods)								
			fname=fname(1:periods(1)-1);
		end		

		setStatusString('Loading power table...');
		load(fullfile(pname, [fname '.pow']), '-mat');			% load file as MATLAB workspace file
		state.pcell.pcellTablePath=pname;
		eval(['state.pcell.pcellTableName' num2str(chan) '=fname;']);
		eval(['state.pcell.powerLookupTable' num2str(chan) '=plt;']);

		if ~state.analysisMode & ~state.initializing
			state.internal.needNewPcellPowerOutput=1;
			applyChangesToOutput;
		end
		global gh
		turnOnAllChildren(gh.pcellControl.figure1);
		setStatusString('');
	end
