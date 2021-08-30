function timerInit_LineMonitor
	global  gh state
    
	gh.lmSettings=guihandles(lmSettings);
	initGUIs('linemonitor.ini');
    if ~state.analysisMode
        lmMakeDeviceIDList
        lmBuildDAQs
        lmReadDAQs
    end