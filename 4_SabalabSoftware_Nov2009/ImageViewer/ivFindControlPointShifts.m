function ivFindControlPointShifts
	global state
	
	if state.imageViewer.selectionChannel<=4
		state.imageViewer.multiTestImage=double(state.imageViewer.stackData{state.imageViewer.selectionChannel}(:,:, state.imageViewer.displayedSlice));
	else
		state.imageViewer.multiTestImage=double(state.imageViewer.projectionData{state.imageViewer.selectionChannel-4});
	end
	
	for counter=1:size(state.imageViewer.multiReferenceCoords,1)
		minX=max(state.imageViewer.multiReferenceCoords(counter, 1)-2*state.imageViewer.multiReferenceSpan, 1);
		minY=max(state.imageViewer.multiReferenceCoords(counter, 2)-2*state.imageViewer.multiReferenceSpan, 1);
		maxX=min(state.imageViewer.multiReferenceCoords(counter, 1)+2*state.imageViewer.multiReferenceSpan, state.imageViewer.nPixelsX);
		maxY=min(state.imageViewer.multiReferenceCoords(counter, 2)+2*state.imageViewer.multiReferenceSpan, state.imageViewer.nPixelsY);
		shift=ivFindShift(...
			state.imageViewer.multiReferenceImages{counter}, ...
			state.imageViewer.multiTestImage(minX:maxX, minY:maxY));
		shift=[shift(2) shift(1) shift(3)];
		state.imageViewer.multiShifts(counter, :)= ...
			shift-...
			[...
				state.imageViewer.multiReferenceCoords(counter, 1)-minX-state.imageViewer.multiReferenceSpan ...
				state.imageViewer.multiReferenceCoords(counter, 2)-minY-state.imageViewer.multiReferenceSpan ...
				0];
	end
	state.imageViewer.multiTestCoords=state.imageViewer.multiReferenceCoords-state.imageViewer.multiShifts(:, 1:2);
% 		
% 	state.imageViewer.pixelShiftY=shift(1)-state.imageViewer.trackerY0+1;
% 	state.imageViewer.pixelShiftX=shift(2)-state.imageViewer.trackerX0+1;
% 
% 	updateGUIByGlobal('state.imageViewer.pixelShiftX');
% 	updateGUIByGlobal('state.imageViewer.pixelShiftY');
% 	ivUpdateReferenceImage;
% 	ivApplyShiftToLines;

	