function navSelSpine

    global state

    figure(state.navigator.navFigure)
   
    [x,y]=ginput(2);
    if size(x,1)~=2
        return
    end
    
    cx=mean(x);
    cy=mean(y);
   
    alpha=atan((y(2)-y(1))/(x(2)-x(1)));
    
    sx=size(state.navigator.storedMaxImage,1);
    sy=size(state.navigator.storedMaxImage,2);
    
    magnification=35/state.navigator.navZoom;
    
    maxReference=zeros(128,128);
    
    x1=cx-cos(alpha)*(sx/2)/magnification+sin(alpha)*(sx/2)/magnification;
    y1=cy-sin(alpha)*(sy/2)/magnification-cos(alpha)*(sx/2)/magnification;
    
    for i=1:128
        for j=1:128
           	px=x1+cos(alpha)*(i/128)*(sx/magnification)...
                -sin(alpha)*(j/128)*(sy/magnification);
			py=y1+sin(alpha)*(i/128)*(sx/magnification)...
                +cos(alpha)*(j/128)*(sy/magnification);
            maxReference(i,j)=...
                state.navigator.storedMaxImage(round(px),round(py));
        end
    end
    figure, imshow(maxReference);
    %from trackimage
    
    shifts=zeros(3, state.navigator.numberOfZSlices);
		maxCC=-1000;
		for sliceCounter=1:state.navigator.numberOfZSlices
			if state.acq.averaging
				startSlice=sliceCounter;
				stopSlice=sliceCounter;
			else
				startSlice=(sliceCounter-1)*state.navigator.numberOfFrames+1;
				stopSlice=startSlice+state.navigator.numberOfFrames-1;
            end

            for i=1:128
                 for j=1:128
                   	px=x1+cos(alpha)*(i/128)*(sx/magnification)-sin(alpha)*(j/128)*(sy/magnification);
                	py=y1+sin(alpha)*(i/128)*(sx/magnification)+cos(alpha)*(j/128)*(sy/magnification);
                   
                    
                    trackerImage(i,j)=mean(state.navigator.storedAllImages(round(px),round(py), startSlice:stopSlice), 3);
                 end
            end
            
            trackerImage=mean(state.navigator.storedAllImages(:,:,startSlice:stopSlice),3);
			shifts(:, sliceCounter)...
				=findShift(maxReference, state.navigator.storedAllImages(:,:,sliceCounter));
            disp(['CC ' num2str(shifts(3, sliceCounter))])
            if shifts(3, sliceCounter)>maxCC
				maxCC=state.acq.shifts(3, sliceCounter);
				maxCCSlice=sliceCounter;
                tempReference=trackerImage;
			end
        end     
            
    state.acq.trackerReferenceAll=tempReference;
    
    updateReferenceImage;
    
    %go to correct position and savescan
    
    state.acq.zoomFactor=35;
	state.acq.averaging=0;
	state.acq.numberOfFrames=3;
	state.acq.numberOfZSlices=1;
	    
    %sub-trackerreference
    sx=size(state.acq.trackerReferenceAll,1);
	sy=size(state.acq.trackerReferenceAll,2);

    x0=round(sx*0.10);
	y0=round(sy*0.10);
	x1=round(sx*0.90);
	y1=round(sy*0.90);
	
	state.acq.trackerReference=state.acq.trackerReferenceAll(y0:y1, x0:x1);
	state.internal.trackerX0=x0;
	state.internal.trackerY0=y0;

    state.internal.refShiftX= state.acq.postRotOffsetX + state.acq.scanOffsetX;
	state.internal.refShiftY= state.acq.postRotOffsetY + state.acq.scanOffsetY;
	state.internal.refAngle= state.acq.scanRotation;
	state.internal.refZoom= state.acq.zoomFactor;

    %piezo
    state.piezo.next_pos=state.motor.stackStart+state.acq.zStepSize*(sliceCounter-1);
    piezoUpdatePosition    
    
    %rotation
    state.acq.scanRotation = alpha*180/pi;

    %offset
    index = round(mean(y)-1) * state.navigator.lengthOfXData + round(state.navigator.lengthOfXData*(state.navigator.fractionStart+mean(x)*state.navigator.fractionPerPixel));
	
    state.acq.postRotOffsetX = state.navigator.repeatedMirrorData(index,1);
	state.acq.postRotOffsetY = state.navigator.repeatedMirrorData(index,2);
		    
    %savescan;
    
    