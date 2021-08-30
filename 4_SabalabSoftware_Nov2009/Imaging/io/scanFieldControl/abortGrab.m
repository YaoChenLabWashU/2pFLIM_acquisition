function abortGrab
	global state gh
	global grabInput grabOutput pcellGrabOutput
	setStatusString('Aborting Grab...');

	stop(grabInput)

	stop([pcellGrabOutput grabOutput grabInput]);

	while ~strcmp(get(pcellGrabOutput, 'Running'), 'Off')
		pause(0.01);
	end
	state.internal.abortActionFunctions=0;
	setPcellsToDefault;

	set(gh.siGUI_ImagingControls.grabOneButton, 'Enable', 'off');

	while ~any(strcmp(get([pcellGrabOutput grabOutput grabInput], 'Running'), 'Off'))
		pause(0.001);
	end

	state.internal.status=0;
	try
		flushData(grabInput);
	catch
%		disp('abortGrab: error in input flush data.  proceeding...');
	end
		
	mp285Flush;
	
	executeGoHome;

	set(gh.siGUI_ImagingControls.grabOneButton, 'String', 'GRAB');
	set(gh.siGUI_ImagingControls.grabOneButton, 'Enable', 'on');
	set(gh.siGUI_ImagingControls.focusButton, 'Visible', 'On');

%	siRedrawImages([], max(state.internal.frameCounter,1));
	timerSetPackageStatus(0, 'Imaging');
	timerCheckIfAllAborted;
	resetCounters;
	setStatusString('');

