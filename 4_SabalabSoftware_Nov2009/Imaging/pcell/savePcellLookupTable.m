function savePcellLookupTable(chan)
	if nargin<1
		chan=1;
	end
	
	global state
	
	if ~isempty(state.pcell.pcellTablePath)
		try
			cd(state.pcell.pcellTablePath)
		catch
		end
	end
	
	[fname, pname]=uiputfile('*.pow', 'Choose pcell power table name');

	if ~isnumeric(fname)
		setStatusString('Saving pcell power table...');
	
		periods=findstr(fname, '.');
		if any(periods)								
			fname=fname(1:periods(1)-1);
		end		
		eval(['state.pcell.pcellTableName' num2str(chan) '=fname;']);
		state.pcell.pcellTablePath=pname;

		plt = eval(['state.pcell.powerLookupTable' num2str(chan)]);
		save(fullfile(pname, [fname '.pow']), 'plt', '-mat');
		setStatusString('');
	else
		setStatusString('Cannot open file');
	end

