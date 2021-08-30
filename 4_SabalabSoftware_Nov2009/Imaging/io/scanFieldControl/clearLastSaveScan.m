function clearLastSaveScan

	global state
	
    if state.internal.saveScanLastPos>0
	state.internal.saveScanLastPos=state.internal.saveScanLastPos-1;
    end