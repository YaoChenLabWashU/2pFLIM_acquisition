function loadUserSettings(pname, fname)
% Allows user to select a settings file (*.ini) from disk and loads it
% Author: Bernardo Sabatini

	global state gh
	setStatusString('Loading user settings...');

	if nargin<2
		if ~isempty(state.userSettingsPath)
			try
				cd(state.userSettingsPath);
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
			disp('loadUserSettings: Error: found file name without extension');
			setStatusString('Can''t open file...');
			return
		end		
		
		fileName=fullfile(pname, [fname '.usr']);
		
		[fid, message]=fopen(fileName);
		if fid<0
			disp(['loadUserSettings: Error opening ' fileName ': ' message]);
			return
		end
		[fileName,permission, machineormat] = fopen(fid);
		fclose(fid);

		setStatusString('Reading User Settings...');
		
		disp(['*** CURRENT USER SETTINGS FILE = ' fileName ' ***']);
		initGUIs(fileName);

		[path,name,ext] = fileparts(fileName);
		
		global state
		state.userSettingsName=name;
		state.userSettingsPath=pname;

		saveUserSettingsPath;
		makeUserSettingsMenu;
        initialActivePackages = state.timer.activePackages;
        
		loadCycle(state.cycle.cyclePath, state.cycle.cycleName);
        cycleActivePackages = state.timer.activePackages;
		loadPulseSet(state.pulses.pulseSetPath, state.pulses.pulseSetName);        
		
		if ~isempty(state.analysis.setupName) && ~isempty(state.analysis.setupPath)
			loadAnalysisSetup(state.analysis.setupPath, state.analysis.setupName)
		end
		
        state.timer.activePackages = initialActivePackages;
		timerCallPackageFunctions('UserSettings');
        state.timer.activePackages = cycleActivePackages;


		if ~isempty(state.figurePath)
			try
				loadFiguresFromPath(state.figurePath);
			catch
				disp('loadUserSettings : *** Error loading figure set ***');
			end	
		end
	
		global gh	% BSMOD added 1/30/1 with lines below

		wins=fieldnames(gh);
	
		for winCount=1:length(wins)
			winName=wins{winCount};
			if isfield(state.windowPositions, [winName '_position'])  
				if (length(getfield(state.windowPositions, [winName '_position']))==4) ...
						&& ishandle(getfield(getfield(gh, winName), 'figure1'))
					oldPos=get(getfield(getfield(gh, winName), 'figure1'), 'Position');
					newPos=getfield(state.windowPositions, [winName '_position']);
					newPos(3)=oldPos(3);
					newPos(4)=oldPos(4);
					set(getfield(getfield(gh, winName), 'figure1'), 'Position', newPos);
				end
			end
			if isfield(state.windowPositions, [winName '_visible']) ... 
					&& ishandle(getfield(getfield(gh, winName), 'figure1'))
				vis=getfield(state.windowPositions, [winName '_visible']);
				set(getfield(getfield(gh, winName), 'figure1'), 'Visible', vis);
			end
        end
        % GY 20110127 added to position the image windows
         try
                for channelCounter = 1:state.init.maximumNumberOfInputChannels
        			eval(['set(state.internal.GraphFigure(channelCounter), ''Position'',state.windowPositions.image' num2str(channelCounter) '_position);']);
        			eval(['set(state.internal.MaxFigure(channelCounter), ''Position'',state.windowPositions.maxImage' num2str(channelCounter) '_position);']);
                end
         catch
         end

		try
			if ishandle(state.phys.internal.scopeHandle) && isfield(state.windowPositions, 'scopeWindow_position') 
				if length(state.windowPositions.scopeWindow_position)==4
					set(state.phys.internal.scopeHandle, 'Position', state.windowPositions.scopeWindow_position);
				end
			end
		catch
		end
		
		try	
			if ishandle(state.phys.internal.pulsePatternPlot) && isfield(state.windowPositions, 'pulsePatternPlotWindow_position') 
				if length(state.windowPositions.pulsePatternPlotWindow_position)==4
					set(state.phys.internal.pulsePatternPlot, 'Position', state.windowPositions.pulsePatternPlotWindow_position);
				end
			end
		catch
		end
					
		setStatusString('User Settings Loaded');
%       MRB_SetSavePath;
	end
	
	
