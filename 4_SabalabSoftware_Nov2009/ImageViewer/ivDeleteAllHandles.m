function ivDeleteAllHandles(objects)
	global state

	if nargin<1
		objects=state.imageViewer.currentObject;
	end
	
	if isempty(objects)
		objects=1:size(state.imageViewer.objStructs,2);
	end

	if isempty(objects)
		return
	end
	
	for objectNumber=objects
		axes=[state.imageViewer.objStructs(objectNumber).boundBoxHandle ...
			state.imageViewer.objStructs(objectNumber).boundBoxLabelHandle ...
			state.imageViewer.objStructs(objectNumber).axisLineHandle1 ...
			state.imageViewer.objStructs(objectNumber).axisLineHandle2 ...
			state.imageViewer.objStructs(objectNumber).boxHandle];
		for axis=axes
			if ishandle(axis)
				delete(axis)
			end
		end
	end