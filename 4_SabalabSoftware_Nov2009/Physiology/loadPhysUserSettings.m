function loadPhysUserSettings(pname, fname)
% Allows user to select a settings file (*.ini) from disk and loads it
% Author: Bernardo Sabatini

	global state gh physOutputDevice physInputDevice
	setPhysStatusString('Loading user settings...');

	if nargin<2
		if ~isempty(state.phys.internal.userSettingsPath)
			try
				cd(state.phys.internal.userSettingsPath);
			catch
			end			
		end
		
		[fname, pname]=uigetfile('*.usr', 'Choose user settings file to load');
	end

	if ~isnumeric(fname)
		periods=findstr(fname, '.');
		if any(periods)								
			fname=fname(1:periods(1)-1);
		else
			disp('loadPhysUserSettings: Error: found file name without extension');
			setPhysStatusString('Can''t open file...');
			return
		end		
		
		fileName=fullfile(pname, [fname '.usr']);
		
		[fid, message]=fopen(fileName);
		if fid<0
			disp(['loadPhysUserSettings: Error opening ' fileName ': ' message]);
			return
		end
		[fileName,permission, machineormat] = fopen(fid);
		fclose(fid);

		setPhysStatusString('Reading User Settings...');
		
		disp(['*** CURRENT PHYSIOLOGY USER SETTINGS FILE = ' fileName ' ***']);
		initGUIs(fileName);

		[path,name,ext] = fileparts(fileName);
		
		global state
		state.phys.internal.userSettingsName=name;
		state.phys.internal.userSettingsPath=pname;
		loadPhysCycle(state.phys.cycle.cyclePath, state.phys.cycle.cycleName);
	
		makeAnalysisFunctionMenu;
		makeUserSettingsMenu;
		savePhysUserSettingsPath;

		changeChannelType(0);
		changeChannelType(1);
		
		if ~state.analysisMode
			state.phys.settings.outputRate=setverify(physOutputDevice, 'SampleRate', state.phys.settings.outputRate);
			state.phys.settings.inputRate=setverify(physInputDevice, 'SampleRate', state.phys.settings.inputRate);
		end
		updateGUIByGlobal('state.phys.settings.outputRate');
		updateGUIByGlobal('state.phys.settings.inputRate');

		setupPhysDaqInputChannels;
		
		global gh	% BSMOD added 1/30/1 with lines below

		wins=fieldnames(gh);
	
		for winCount=1:length(wins)
			winName=wins{winCount};
			if isfield(state.phys.windowPositions, [winName '_position']) 
				if length(getfield(state.phys.windowPositions, [winName '_position']))==4
					oldPos=get(getfield(getfield(gh, winName), 'figure1'), 'Position');
					newPos=getfield(state.phys.windowPositions, [winName '_position']);
					newPos(3)=oldPos(3);
					newPos(4)=oldPos(4);
					set(getfield(getfield(gh, winName), 'figure1'), 'Position', newPos);
				end
			end
		end
		
		if ishandle(state.phys.internal.scopeHandle) & isfield(state.phys.windowPositions, 'scopeWindow_position') 
			if length(state.phys.windowPositions.scopeWindow_position)==4
				set(state.phys.internal.scopeHandle, 'Position', state.phys.windowPositions.scopeWindow_position);
			end
		end
			
		if ishandle(state.phys.internal.pulsePatternPlot) & isfield(state.phys.windowPositions, 'pulsePatternPlotWindow_position') 
			if length(state.phys.windowPositions.pulsePatternPlotWindow_position)==4
				set(state.phys.internal.pulsePatternPlot, 'Position', state.phys.windowPositions.pulsePatternPlotWindow_position);
			end
		end
		
		setPhysStatusString('User Settings Loaded');
	end
	
	
