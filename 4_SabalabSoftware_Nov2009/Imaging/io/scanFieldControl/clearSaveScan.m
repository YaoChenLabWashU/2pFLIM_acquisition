function clearSaveScan

	global state
	
	state.internal.saveScanLastPos=0;
	state.internal.saveScanInfo=[];
	clear state.internal.saveScanInfo;