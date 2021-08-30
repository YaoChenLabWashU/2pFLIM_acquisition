function index=timerPackageIndex(package)
	global state

	index=find(strcmp(package, state.timer.packageList)); 
