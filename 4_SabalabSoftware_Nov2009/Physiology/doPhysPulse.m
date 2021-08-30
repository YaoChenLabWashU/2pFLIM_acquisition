function doPhysPulse
	global state
	
	setPhysStatusString('Acquiring...');
	timerStart_Physiology;
	triggerPhys;