function ivHighlightObject(objectNumber, timePoint)
	global state
	
	persistent lastObjectNumber lastFileCounter
	if ~isnumeric(lastObjectNumber) | isempty(lastObjectNumber)
		lastObjectNumber=0;
		lastFileCounter=0;
	end
		
	if nargin<2
		timePoint=state.imageViewer.tsFileCounter;
	end

	if nargin<1
		objectNumber=state.imageViewer.currentObject;
	end
	
	if isempty(objectNumber)
		objectNumber=state.imageViewer.currentObject;
	end

	if length(state.imageViewer.objStructs)==0
		return
	end
	objectNumber=max(min(objectNumber, length(state.imageViewer.objStructs)), 1);
	state.imageViewer.currentObject=objectNumber;
	updateGUIByGlobal('state.imageViewer.currentObject');

	if state.imageViewer.objectAutoCenter
		try
			ivSetWindowBounds(...
				[state.imageViewer.objStructs(objectNumber).coords(1) - 2*state.imageViewer.objectRadius ...
				state.imageViewer.objStructs(objectNumber).coords(1) + 2*state.imageViewer.objectRadius], ...
				[state.imageViewer.objStructs(objectNumber).coords(2) - 2*state.imageViewer.objectRadius ...
				state.imageViewer.objStructs(objectNumber).coords(2) + 2*state.imageViewer.objectRadius]);
		catch
		end
	end
	
	if lastObjectNumber~=objectNumber
		if lastObjectNumber>0 & lastObjectNumber<=length(state.imageViewer.objStructs)
			handles=[state.imageViewer.objStructs(lastObjectNumber).boundBoxHandle ...
					state.imageViewer.objStructs(lastObjectNumber).boundBoxLabelHandle  ...
					state.imageViewer.objStructs(lastObjectNumber).axisLineHandle1 ...
					state.imageViewer.objStructs(lastObjectNumber).axisLineHandle2 ...
					state.imageViewer.objStructs(lastObjectNumber).boxHandle...
				];
			vHandles=handles(find(ishandle(handles)));
			
			if lastObjectNumber ~= 0 & ~state.imageViewer.objectShowTraces
				set(vHandles, 'Visible', 'off');
			end
		end
	lastObjectNumber=objectNumber;
	end
 	lastFileCounter=state.imageViewer.tsFileCounter;
	ivMakeObjectVisible(objectNumber, timePoint);
	
 	