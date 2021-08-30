function executeFocusCallback
	global state gh
    global focusInput focusOutput grabOutput 
    
	persistent multipleAbortAttempts
	
	if (exist('multipleAbortAttempts', 'var')~=1)
		multipleAbortAttempts=0;
	end
	
	if strcmp(get(gh.siGUI_ImagingControls.focusButton, 'String'), 'FOCUS')
		if strcmp(get(gh.basicConfigurationGUI.figure1, 'Visible'), 'on')
			beep;
			setStatusString('Close ConfigurationGUI');
			return
		end
		
		if timerGetPackageStatus('Imaging')
			beep;
			setStatusString('Running. Stop processes');
			return
		end

		timerRequestPause('Imaging');
		setStatusString('Focusing...');
		set(gh.siGUI_ImagingControls.focusButton, 'String', 'ABORT');
		set(gh.fieldAdjustGUI.focusButton, 'String', 'abort');

		set(gh.siGUI_ImagingControls.grabOneButton, 'Visible', 'Off');

		if state.internal.looping
			state.internal.cyclePaused=1;
		end
		turnOffMenus;
		
		if state.init.autoReadPMTOffsets
			getPMTOffsets;
		end
		
 		if state.internal.updatedZoomOrRot % need to reput the data with the approprite rotation and zoom.
			if get(focusOutput, 'SamplesAvailable')>0
				flushFocusData;
			end
			if get(grabOutput, 'SamplesAvailable')>0
				flushGrabData;
			end
		
			putDataFocus;
			putDataGrab;
			state.internal.updatedZoomOrRot=0;
 		end
		
		mp285Flush;
		resetCounters;
		
		state.internal.abortActionFunctions=0;
		
		multipleAbortAttempts=0;
		startFocus;
 
	else
		multipleAbortAttempts=multipleAbortAttempts+1;
		if strcmp(get(focusInput, 'Running'),'Off')
			abortFocus;
		else
			state.internal.abortActionFunctions=1;
			if multipleAbortAttempts>1
				disp('Multiple abort attempts.  Will force abort.');
				abortFocus;
			end
		end
	end
	

