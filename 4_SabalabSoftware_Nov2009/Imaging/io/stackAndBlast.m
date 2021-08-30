function stackAndBlast
	global state
	
	if state.pcell.boxPowerLevel1 == 0 && state.pcell.boxPowerLevel2 == 0
		disp('!!!!!Select a Box Power Level!!!!!');
		beep;
		return;
	end

	oldReturnHome=state.acq.returnHome;
	state.acq.returnHome=0;
	executeGrabOneCallback

    while state.internal.status
		if state.internal.abort
			return;
		end
		state.internal.status;
     	pause(.05);
    end
	if state.internal.abort
		return;
	end

	pickPcellBoxCenters(1);
	oldStepSize=state.acq.zStepSize;
	state.acq.zStepSize=-1*state.acq.zStepSize;
	updateGUIByGlobal('state.acq.zStepSize');

	executeGrabOneCallback;
  	saveMaxInFigure(1); % added fitz
    while state.internal.status && ~state.internal.abort
     	pause(.05);
    end
	state.acq.returnHome=oldReturnHome;
	state.acq.zStepSize=oldStepSize;
	updateGUIByGlobal('state.acq.zStepSize');
	
	setLength=settingsManager('getsetlength', 'pcellBox');
	for counter=1:setLength
		state.pcell.boxActiveStatus=0;
		settingsManager('storeone', 'pcellBox', counter, 'state.pcell.boxActiveStatus');
	end
	state.pcell.boxNumber=1;
	updateGUIByGlobal('state.pcell.boxNumber');
	settingsManager('recall', 'pcellBox', state.pcell.boxNumber);

		
 	state.internal.needNewPcellPowerOutput=1;
	applyChangesToOutput;
