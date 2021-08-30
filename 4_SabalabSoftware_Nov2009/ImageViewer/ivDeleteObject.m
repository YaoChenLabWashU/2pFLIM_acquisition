function ivDeleteObject(objectNumber)
	global state
	if nargin<1
		objectNumber=state.imageViewer.currentObject;
	end
	if isempty(objectNumber)
		objectNumber=size(state.imageViewer.objStructs, 2);
	end
	
	if objectNumber>size(state.imageViewer.objStructs, 2)
		return
	end

	ivDeleteAllHandles(objectNumber);
	state.imageViewer.objStructs(objectNumber)=[];

	for counter=1:length(state.imageViewer.objStructs)
		if ishandle(state.imageViewer.objStructs(counter).boundBoxLabelHandle)
			set(state.imageViewer.objStructs(counter).boundBoxLabelHandle, ...
				'String', num2str(counter));
		end
	end

	if state.imageViewer.currentObject==objectNumber | objectNumber>=length(state.imageViewer.objStructs)
		state.imageViewer.currentObject=max(min(objectNumber+1, length(state.imageViewer.objStructs)), 1);
		updateGUIByGlobal('state.imageViewer.currentObject');	
		ivHighlightObject
	end
	