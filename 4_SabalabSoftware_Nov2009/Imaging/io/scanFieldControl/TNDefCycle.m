function TNDefCycle()
	global state
    
    nscans=state.internal.saveScanLastPos;
	ncycles=2*nscans+1 ; % track image + line scan, plus physiological assay
	
    state.cycle.imageOnList(:) = 0;
    state.cycle.physOnList(:) = 0;
    
    for scan=1:nscans 
          
		cyc=2*scan-1; %track image trials

		state.cycle.imageOnList(cyc) = 1;
		state.cycle.repeatsList(cyc) = 1;
		state.cycle.delayList(cyc) = 3;
		state.cycle.framesList(cyc) = 1;
		state.cycle.numberOfZSlicesList(cyc) = 3;
		state.cycle.zStepSizeList(cyc) = 1;
		state.cycle.blasterList(cyc) = 0;
		state.cycle.trackerList(cyc) = 1;
		state.cycle.avgFramesList(cyc) = 0;
		state.cycle.linescanList(cyc) = 0;
		state.cycle.physOnList(cyc) = 0;
		state.cycle.stagePosList(cyc) = 0;
		state.cycle.scanSetupList(cyc) = scan;
		state.cycle.da0List(cyc) = 0;
		state.cycle.da1List(cyc) = 0;
		state.cycle.aux4List(cyc) = 0;
		state.cycle.aux5List(cyc) = 0;
		state.cycle.aux6List(cyc) = 0;
		state.cycle.aux7List(cyc) = 0;
			
		cyc=2*scan;%line scan trials

		state.cycle.imageOnList(cyc) = 1;
		state.cycle.repeatsList(cyc) = 4;
		state.cycle.delayList(cyc) = 5;
		state.cycle.framesList(cyc) = 1;
		state.cycle.numberOfZSlicesList(cyc) = 1;
		state.cycle.zStepSizeList(cyc) = 1;
		state.cycle.blasterList(cyc) = 0;
		state.cycle.trackerList(cyc) = 0;
		state.cycle.avgFramesList(cyc) = 0;
		state.cycle.linescanList(cyc) = 1;
		state.cycle.physOnList(cyc) = 1;
		state.cycle.stagePosList(cyc) = 0;
		state.cycle.scanSetupList(cyc) = scan;
		state.cycle.da0List(cyc) = 19;
		state.cycle.da1List(cyc) = 0;
		state.cycle.aux4List(cyc) = 0;
		state.cycle.aux5List(cyc) = 0;
		state.cycle.aux6List(cyc) = 0;
		state.cycle.aux7List(cyc) = 0;

		
	end
	
	%phys assay
 	
	state.cycle.imageOnList(ncycles) = 0;
	state.cycle.repeatsList(ncycles) = 2;
	state.cycle.delayList(ncycles) = 8;
	state.cycle.framesList(ncycles) = 1;
	state.cycle.numberOfZSlicesList(ncycles) = 1;
	state.cycle.zStepSizeList(ncycles) = 1;
	state.cycle.blasterList(ncycles) = 0;
	state.cycle.trackerList(ncycles) = 0;
	state.cycle.avgFramesList(ncycles) = 0;
	state.cycle.linescanList(ncycles) = 0;
	state.cycle.physOnList(ncycles) = 1;
	state.cycle.stagePosList(ncycles) = 0;
	state.cycle.scanSetupList(ncycles) = 1;
	state.cycle.da0List(ncycles) = 22;
	state.cycle.da1List(ncycles) = 0;
	state.cycle.aux4List(ncycles) = 0;
	state.cycle.aux5List(ncycles) = 0;
	state.cycle.aux6List(ncycles) = 0;
	state.cycle.aux7List(ncycles) = 0;
	
	state.internal.cycleChanged=1;
	updateCycleDisplay(1);
