function ivMarkObject(objectNumber)
	global state

	ivBringSelectionToFront;	
	[x,y]=ginput(1);
	if isempty(x)
		return
	end
	x=round(x);
	y=round(y);

	if nargin<1
		objectNumber=size(state.imageViewer.objStructs,2)+1;
	end
		
	state.imageViewer.currentObjectX=x;
	state.imageViewer.currentObjectY=y;
	
	if ~state.imageViewer.selectionChannelIsProj
		state.imageViewer.currentObjectZ=state.imageViewer.displayedSlice;
	else
		i=state.imageViewer.tsCoredFlatProjectionIndex{state.imageViewer.tsFileCounter, state.imageViewer.selectionChannel} ...
			(state.imageViewer.currentObjectY-1:state.imageViewer.currentObjectY+1, ...
			state.imageViewer.currentObjectX-1:state.imageViewer.currentObjectX+1);
		state.imageViewer.currentObjectZ=mode(i);
		state.imageViewer.displayedSlice=state.imageViewer.currentObjectZ;
		ivUpdateFigures;
	end

	if length(state.imageViewer.objStructs)<objectNumber
		if isempty(state.imageViewer.objStructs)
			state.imageViewer.objStructs = ...
				ivEmptyObjectStruct(state.imageViewer.tsNumberOfFiles, length(state.imageViewer.validAnaChannels));
		else
			state.imageViewer.objStructs(end+1:objectNumber) = ...
				ivEmptyObjectStruct(state.imageViewer.tsNumberOfFiles, length(state.imageViewer.validAnaChannels));
		end
		state.imageViewer.objStructs(objectNumber).status(:)=1;
	else
		ivDeleteAllHandles(objectNumber);
		state.imageViewer.objStructs(objectNumber).boundBoxHandle=[];
		state.imageViewer.objStructs(objectNumber).boundBoxLabelHandle=[];
		state.imageViewer.objStructs(objectNumber).axisLineHandle1=[];
		state.imageViewer.objStructs(objectNumber).axisLineHandle2=[];
		state.imageViewer.objStructs(objectNumber).boxHandle=[];
	end

	state.imageViewer.objStructs(objectNumber).coords = ...
		[state.imageViewer.currentObjectX state.imageViewer.currentObjectY state.imageViewer.currentObjectZ];
	state.imageViewer.currentObject=objectNumber;


	updateGUIByGlobal('state.imageViewer.currentObject');
	updateGUIByGlobal('state.imageViewer.currentObjectX');
	updateGUIByGlobal('state.imageViewer.currentObjectY');
	updateGUIByGlobal('state.imageViewer.currentObjectZ');

	ivDrawObjectBound(objectNumber);


