function ivFindObjectShift(objectNumber, fileNumber)
	global state

	if nargin<1
		objectNumber=state.imageViewer.currentObject;
	end
	if nargin<2
		fileNumber=state.imageViewer.tsFileCounter;
	end

	if fileNumber==1
		state.imageViewer.lastObjectShift=[];
		return
	end
	
	minX1=max(state.imageViewer.objStructs(objectNumber).coords(1)-2*state.imageViewer.objectRadius, 1);
	maxX1=min(state.imageViewer.objStructs(objectNumber).coords(1)+2*state.imageViewer.objectRadius, state.imageViewer.nPixelsX);
	minY1=max(state.imageViewer.objStructs(objectNumber).coords(2)-2*state.imageViewer.objectRadius, 1);
	maxY1=min(state.imageViewer.objStructs(objectNumber).coords(2)+2*state.imageViewer.objectRadius, state.imageViewer.nPixelsY);

	minX2=max(state.imageViewer.objStructs(objectNumber).coords(1)-state.imageViewer.objectRadius, 1);
	maxX2=min(state.imageViewer.objStructs(objectNumber).coords(1)+state.imageViewer.objectRadius, state.imageViewer.nPixelsX);
	minY2=max(state.imageViewer.objStructs(objectNumber).coords(2)-state.imageViewer.objectRadius, 1);
	maxY2=min(state.imageViewer.objStructs(objectNumber).coords(2)+state.imageViewer.objectRadius, state.imageViewer.nPixelsY);
	
	origImage=state.imageViewer.tsCoredFlatProjection{fileNumber-1, state.imageViewer.morphChannel}(minY1:maxY1, minX1:maxX1);

	testImage=state.imageViewer.tsCoredFlatProjection{fileNumber, state.imageViewer.morphChannel}(minY2:maxY2, minX2:maxX2);
				
	state.imageViewer.lastObjectShift=ivFindShift(testImage, origImage)-[minY2-minY1 minX2-minX1 0];
	
