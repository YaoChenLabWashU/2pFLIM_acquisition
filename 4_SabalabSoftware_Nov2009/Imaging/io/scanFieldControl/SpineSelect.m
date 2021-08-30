function SpineSelect(num)
    if(nargin<1)
        num=0;
    end
	global state imageData

    %if ~ishandle(state.internal.refFigure)
    %    displayReferenceImage;
    %end
        
	old_zoomfactor=state.acq.zoomFactor;
	
	state.acq.zoomFactor=35;
	state.acq.averaging=1;
	state.acq.numberOfFrames=3;
	state.acq.numberOfZSlices=1;
	state.acq.autoTrack=0;
    state.internal.needNewRotatedMirrorOutput=1;
   	state.internal.needNewPcellRepeatedOutput=1;
    
	global grabInput
	
    try 
        set(grabInput, 'SamplesPerTrigger', state.internal.samplesPerFrame*state.acq.numberOfFrames);
	    
        applyChangesToOutput;
       
    	preallocateMemory;
        executeGrabOneCallback; wait(grabInput, 20);
    catch
        error('Spineselect: error in grabbing reference image')
    end
    if num==0
        try
			pos=state.internal.saveScanLastPos+1;
		catch
			pos=1;
        end
    else
        pos=num;
    end
    
    addEntryToNotebook(2, ['SpineSelect scan ' num2str(pos) ', RefImage Acq ' num2str(state.files.fileCounter-1)]);

    
	state.acq.trackerReferenceAll=medfilt2(mean(imageData{state.acq.trackerChannel},3));

	sx=size(state.acq.trackerReferenceAll,1);
	sy=size(state.acq.trackerReferenceAll,2);
	
	x0=round(sx*0.10);
	y0=round(sy*0.10);
	x1=round(sx*0.90);
	y1=round(sy*0.90);
	
	state.acq.trackerReference=state.acq.trackerReferenceAll(y0:y1, x0:x1);
	state.internal.trackerX0=x0;
	state.internal.trackerY0=y0;

	state.acq.scanShiftX=0;
	state.acq.scanShiftY=0;
	state.acq.pixelShiftX=0;
	state.acq.pixelShiftY=0;
	
	state.internal.refShiftX= state.acq.postRotOffsetX + state.acq.scanOffsetX;
	state.internal.refShiftY= state.acq.postRotOffsetY + state.acq.scanOffsetY;
	state.internal.refAngle= state.acq.scanRotation;
	state.internal.refZoom= state.acq.zoomFactor;
	
	updateGUIByGlobal('state.acq.scanShiftX');
	updateGUIByGlobal('state.acq.scanShiftY');
	updateGUIByGlobal('state.acq.pixelShiftX');
	updateGUIByGlobal('state.acq.pixelShiftY');
	updateReferenceImage;
	
    if(num==0)
	saveScan;
    else
        saveScan(num);
    end
	
	state.acq.averaging=0;
	state.acq.numberOfFrames=1;
	state.acq.zoomFactor=old_zoomfactor;
	state.acq.scanRotation=0;
    set(grabInput, 'SamplesPerTrigger', state.internal.samplesPerFrame*state.acq.numberOfFrames);
	
    state.internal.needNewRotatedMirrorOutput=1;
	applyChangesToOutput;
        
    state.acq.autoTrack=1;