function TNDefCycle()
	global state
    
    nscans=state.internal.saveScanLastPos;
	ncycles=2*nscans+1 ; % track image + line scan, plus physiological assay
	
    for scan=1:nscans 
          
		cyc=2*scan-1; %track image trials

		state.cycle.delayList(cyc) = 5;
			
		cyc=2*scan;%line scan trials

		state.cycle.repeatsList(cyc) = 1;
		state.cycle.delayList(cyc) = 10;
	
	end
	
	%phys assay
 	
	state.cycle.repeatsList(ncycles) = 1;
	state.cycle.delayList(ncycles) = 10;
	
	state.internal.cycleChanged=1;
	updateCycleDisplay(1);
