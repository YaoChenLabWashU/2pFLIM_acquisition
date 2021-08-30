function restoreScan(posNum)
	
	global state
	
	try
		if size(state.internal.saveScanInfo,2)~=14
			beep
			disp(['ERROR : restoreScan position' num2str(posNum) 'does not exist' ]);
			return
		end
	catch
		beep
		disp(['ERROR : restoreScan position' num2str(posNum) 'does not exist' ]);
		return
	end
	
	if size(state.internal.saveScanInfo,1)<posNum
		beep
		disp(['ERROR : restoreScan position' num2str(posNum) 'does not exist' ]);
		return
	end
			
	state.acq.zoomFactor = state.internal.saveScanInfo(posNum, 1);
	state.acq.scanRotation  = state.internal.saveScanInfo(posNum, 2);
	state.acq.postRotOffsetX = state.internal.saveScanInfo(posNum, 3);
	state.acq.postRotOffsetY  = state.internal.saveScanInfo(posNum, 4);
	state.internal.trackerX0 = state.internal.saveScanInfo(posNum, 5);
	state.internal.trackerY0 = state.internal.saveScanInfo(posNum, 6);
	state.acq.scanShiftX = state.internal.saveScanInfo(posNum, 7);
	state.acq.scanShiftY = state.internal.saveScanInfo(posNum, 8);
	state.acq.pixelShiftX = state.internal.saveScanInfo(posNum, 9);
	state.acq.pixelShiftY = state.internal.saveScanInfo(posNum, 10);
	state.internal.refShiftX = state.internal.saveScanInfo(posNum, 11);
	state.internal.refShiftY = state.internal.saveScanInfo(posNum, 12);
	state.piezo.next_pos=state.internal.saveScanInfo(posNum, 13);
	piezoUpdatePosition;

	state.acq.trackerReference=state.internal.trackerReferences{posNum};
	state.acq.trackerReferenceAll	= state.acq.trackerReferencesAll{posNum};

	state.internal.needNewRotatedMirrorOutput=1;
	state.internal.needNewPcellRepeatedOutput=1;
	
	if state.piezo.usePiezo
        if(state.cycle.trackerList(state.cycle.currentCyclePosition))
            state.motor.stackStart=state.piezo.next_pos-state.cycle.zStepSize;
            state.motor.stackStop=state.piezo.next_pos+2*state.cycle.zStepSize;
            if state.motor.stackStart<0
                disp(['ERROR : restoreScan position' num2str(posNum) 'too close to Z=0' ]);
                state.motor.stackStart=0
                state.motor.stackStop=4;
            end
            
            calculateStackParameters;
            state.piezo.next_pos=state.motor.stackStart;
            disp(['Stack from ' num2str(state.motor.stackStart) ' to ' num2str(state.motor.stackStop) ' step ' num2str(state.cycle.zStepSize)]);
        else
            state.piezo.next_pos=state.internal.saveScanInfo(posNum, 13);
        end
        piezoUpdatePosition;
    end
	
	applyChangesToOutput(1);
	updateReferenceImage;
	updateGUIByGlobal('state.acq.scanRotation');
	updateGUIByGlobal('state.acq.zoomFactor');
	
	disp(['*** LOADED POSITION ' num2str(posNum) ]);
