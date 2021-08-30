function ivUpdateReferenceImage
	global state

	try
		chanS=num2str(state.imageViewer.morphChannel);
		startImage=	zeros(state.imageViewer.nPixelsY, state.imageViewer.nPixelsX, 3);
		
		lowLUT=getfield(state.imageViewer, ['lowLUT' chanS]);
		highLUT=getfield(state.imageViewer, ['highLUT' chanS]);
		if all(size(state.imageViewer.trackerReferenceAll)==[state.imageViewer.nPixelsY state.imageViewer.nPixelsX])
			startImage(:,:,1) = ...
				min(max((state.imageViewer.trackerReferenceAll - lowLUT) / max(highLUT-lowLUT,1),0),1);
		end
		
		if ~isempty(state.imageViewer.trackerImage)
			if state.imageViewer.pixelShiftX>=0
				lowPixOutX=1;
				highPixOutX=state.imageViewer.nPixelsX-state.imageViewer.pixelShiftX;
				lowPixInX=state.imageViewer.pixelShiftX+1;
				highPixInX=state.imageViewer.nPixelsX;
			else
				lowPixInX=1;
				highPixInX=state.imageViewer.nPixelsX+state.imageViewer.pixelShiftX;
				lowPixOutX=-state.imageViewer.pixelShiftX+1;
				highPixOutX=state.imageViewer.nPixelsX;
			end
			if state.imageViewer.pixelShiftY>=0
				lowPixOutY=1;
				highPixOutY=state.imageViewer.nPixelsY-state.imageViewer.pixelShiftY;
				lowPixInY=state.imageViewer.pixelShiftY+1;
				highPixInY=state.imageViewer.nPixelsY;
			else
				lowPixInY=1;
				highPixInY=state.imageViewer.nPixelsY+state.imageViewer.pixelShiftY;
				lowPixOutY=-state.imageViewer.pixelShiftY+1;
				highPixOutY=state.imageViewer.nPixelsY;
			end

			startImage(lowPixOutY:highPixOutY,lowPixOutX:highPixOutX,2) = ...
				min(max((state.imageViewer.trackerImage(lowPixInY:highPixInY,lowPixInX:highPixInX) - lowLUT) ...
				/ max(highLUT-lowLUT,1),0),1);
		end

		set(state.imageViewer.referenceImagehandle, 'CData', startImage);
		set(state.imageViewer.referenceFigure, 'Visible', 'on');
		
	catch
		disp(['ivUpdateReferenceImage : ' lasterr]);
	end
	

