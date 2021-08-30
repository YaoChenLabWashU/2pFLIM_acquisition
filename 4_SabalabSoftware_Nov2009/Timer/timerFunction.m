function timerFunction
	state.timer.status=1;
	% tell each package to "setup"
	timerCallPackageFunctions('Start');
	
	% send trigger
	triggerPhys;
	disp('trigger done');
	
	% Wait for each package to say that it is done
	
	% process each package
	timerCallPackageFunctions('ProcessAll');
	
	% tell each package to setup for the next one
	timerCallPackageFunctions('setupAgain');
	
	% countdown
	
	
	