function clearOneSaveScan(pos)

	global state
	keep = 1:length(state.internal.saveScanInfo);
    keep = setdff(keep, pos);
    
    if state.internal.saveScanLastPos>0
    	state.internal.saveScanLastPos=state.internal.saveScanLastPos-length(pos);
        state.internal.saveScanInfo=state.internal.saveScanInfo(keep);
        
    end