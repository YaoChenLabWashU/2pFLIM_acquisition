function initTimer(analysisMode, packages)

	global state gh
	
	if nargin==0
		analysisMode=0;
		packages=[];
	elseif nargin==1
		packages=analysisMode;
		analysisMode=0;
	end
			
	gh.timerMainControls = guihandles(timerMainControls);
	gh.pulseMaker=guihandles(pulseMaker);
	set(gh.timerMainControls.statusString, 'String', 'Opening GUIS...')
	gh.advancedCycleGui=guihandles(advancedCycleGUI);
	set(gh.timerMainControls.statusString, 'String', 'Read timer.ini ...')
	openini('timer.ini');
	set(gh.timerMainControls.statusString, 'String', 'Read machineSpecific.ini ...')
	openini('machineSpecific.ini');
	setStatusString('Opening packages...');
	makeTimerPackagesMenu;

	if analysisMode
		state.analysisMode=1;
	else
		state.analysisMode=0;
	end

	state.pulses.addCompList={''};
	state.pulses.patternNameList={''};
	waveo('currentPulsePattern', 0);
	waveo('currentPulseVectorX', [0 0]);
	waveo('currentPulseVectorY', [0 0]);
	changePulsePatternNumber(1);
	global currentPulsePattern
	plot(currentPulsePattern);
%	plotxy('currentPulseVectorX', 'currentPulseVectorY')
	state.internal.pulsePatternPlot=gcf;
	set(state.internal.pulsePatternPlot, 'visible', 'off', ...
		'CloseRequestFcn', 'hideCurrentWindow', ...
		'Name', 'PULSE PATTERN', ...
		'NumberTitle', 'off', ...
		'Position', [400   656   321   144], ...
		'MenuBar', 'none');
	
	state.internal.startupTime=clock;
	state.internal.startupTimeString=clockToString(state.internal.startupTime);
	updateHeaderString('state.internal.startupTimeString');

	state.internal.cycleListNames={};
	allfields=fieldnames(state.cycle);
	for counter=1:length(allfields)
		if ~isempty(findstr(allfields{counter}, 'List'))
			tag=allfields{counter};
			state.internal.cycleListNames{end+1}=tag(1:end-4);
		end
	end
	
	state.internal.triggerTime=clock;
	
	state.initializing=1;
	initNotebooks;
	seeGUI('gh.advancedCycleGui.figure1');
	
	timerSetActiveStatus(packages, 1);
		
	initTraceAnalysis;
	loadUserSettingsPath;
	loadUserSettings;
	updateCycleDisplay(1);
	
	if state.analysisMode
		set(gh.timerMainControls.loop, 'Enable', 'off');
		set(gh.timerMainControls.doOne, 'Enable', 'off');
		state.files.autoSave=0;
		updateGUIByGlobal('state.files.autoSave');
	end
	
	timerMakeAnalysisFunctionMenu
	
	waveo('timerAcqTime', []);
	setStatusString('Ready to Use');
    
    %try
    %    TNSetPath;
    %catch
    %end
