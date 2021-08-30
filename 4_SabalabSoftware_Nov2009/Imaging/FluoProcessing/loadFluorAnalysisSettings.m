function loadFluorAnalysisSettings(pname, fname)

	global state gh
	setStatusString('Loading analysis settings...');

	if nargin<2
		if ~isempty(state.analysis.analysisSetupPath)
			try
				cd(state.analysis.analysisSetupPath);
			catch
			end
		end
		
		[fname, pname]=uigetfile('*.ana', 'Choose fluorescence analysis settings file to load');
	end

	if ~isnumeric(fname)
		periods=findstr(fname, '.');
		if any(periods)								
			fname=fname(1:periods(1)-1);
		else
			disp('loadFluorAnalysisSettings: Error: found file name without extension');
			setStatusString('Can''t open file...');
			return
		end		
		
		fileName=fullfile(pname, [fname '.ana']);
		
		[fid, message]=fopen(fileName);
		if fid<0
			disp(['loadFluorAnalysisSettings: Error opening ' fileName ': ' message]);
			return
		end
		[fileName, permission, machineormat] = fopen(fid);
		fclose(fid);

		setStatusString('Reading analysis settings...');
		
		disp(['*** CURRENT FLUORESCENCE ANALYSIS SETTINGS FILE = ' fileName ' ***']);
		initGUIs(fileName);

		[path,name,ext] = fileparts(fileName);
		
		global state
		state.analysis.analysisSetupFileName=name;
		state.analysis.analysisSetupPath=pname;

		setStatusString('Analysis Settings Loaded');
	end
	
	
