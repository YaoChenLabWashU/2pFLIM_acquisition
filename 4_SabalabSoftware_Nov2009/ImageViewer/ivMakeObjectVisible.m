function ivMakeObjectVisible(objectNumbers, timePoints)
	global state

	if nargin<2
		timePoints=state.imageViewer.tsFileCounter;
	end
	if nargin<1
		objectNumbers=state.imageViewer.currentObject;
	end
	
	if length(state.imageViewer.objStructs)==0
		return
	end

	if isempty(timePoints)
		timePoints=1:state.imageViewer.tsNumberOfFiles;
	end
	if isempty(objectNumbers)
		objectNumbers=1:length(state.imageViewer.objStructs);
	end
    if isempty(objectNumbers)
        return
    end

	axis=ivSelectionAxisHandle;		

	for timePoint=timePoints
		ivFlipTimeSeries(timePoint);
	
		for objectNumber=objectNumbers
			if state.imageViewer.autoFlipToSlice
				if state.imageViewer.objStructs(objectNumber).analysisSlice(timePoint)
					ivFlipSlice(state.imageViewer.objStructs(objectNumber).analysisSlice(timePoint));
				else
					ivFlipSlice(state.imageViewer.objStructs(objectNumber).coords(3));
				end
			end
			
			if ishandle(state.imageViewer.objStructs(objectNumber).boundBoxHandle)
				colors='rbyg';
				set(state.imageViewer.objStructs(objectNumber).boundBoxHandle, 'Visible', 'on', 'EdgeColor', ...
					colors(state.imageViewer.objStructs(objectNumber).status(timePoint)));
			end
			if ishandle(state.imageViewer.objStructs(objectNumber).boundBoxLabelHandle)
				set(state.imageViewer.objStructs(objectNumber).boundBoxLabelHandle, 'Visible', 'on');
			end
			xMajor = squeeze(state.imageViewer.objStructs(objectNumber).axis1x(timePoint, :));
			yMajor = squeeze(state.imageViewer.objStructs(objectNumber).axis1y(timePoint, :));
			xMinor = squeeze(state.imageViewer.objStructs(objectNumber).axis2x(timePoint, :));
			yMinor = squeeze(state.imageViewer.objStructs(objectNumber).axis2y(timePoint, :));
		
			if ishandle(state.imageViewer.objStructs(objectNumber).axisLineHandle1)
				set(state.imageViewer.objStructs(objectNumber).axisLineHandle1, ...
					'XData', xMajor, 'YData', yMajor, 'Visible', 'on');
			else
				state.imageViewer.objStructs(objectNumber).axisLineHandle1 = ...
					line(xMajor, yMajor, 'color', 'r', 'LineWidth', 2, 'LineStyle', '--', 'Parent', axis);
			end
			if ishandle(state.imageViewer.objStructs(objectNumber).axisLineHandle2)
				set(state.imageViewer.objStructs(objectNumber).axisLineHandle2, ...
					'XData', xMinor, 'YData', yMinor, 'Visible', 'on');
			else	
				state.imageViewer.objStructs(objectNumber).axisLineHandle2 = ...
					line(xMinor, yMinor, 'color', 'b', 'LineWidth', 2, 'LineStyle', '--', 'Parent', axis);
			end
		
			xBoxData=[state.imageViewer.objStructs(objectNumber).boxX(timePoint, :) state.imageViewer.objStructs(objectNumber).boxX(timePoint, 1)];
			yBoxData=[state.imageViewer.objStructs(objectNumber).boxY(timePoint, :) state.imageViewer.objStructs(objectNumber).boxY(timePoint, 1)];
				
			if ishandle(state.imageViewer.objStructs(objectNumber).boxHandle)
				set(state.imageViewer.objStructs(objectNumber).boxHandle, ...
					'XData', xBoxData, 'YData', yBoxData, 'Visible', 'on');
			else
				state.imageViewer.objStructs(objectNumber).boxHandle = ...
					line(xBoxData, yBoxData, 'color', 'g', 'LineStyle', '--', 'Parent', axis);
			end
		end
		drawnow		
	end

	state.imageViewer.currentObject = objectNumber;
	state.imageViewer.currentObjectWidth = state.imageViewer.objStructs(objectNumber).width(timePoint) ;			% fs- set to zero for box selection mode?
	state.imageViewer.currentObjectLength = state.imageViewer.objStructs(objectNumber).length(timePoint) ;
	state.imageViewer.currentObjectMass = state.imageViewer.objStructs(objectNumber).max(timePoint) ;
	state.imageViewer.currentObjectStatus = state.imageViewer.objStructs(objectNumber).status(timePoint) ;
	state.imageViewer.currentObjectX = state.imageViewer.objStructs(objectNumber).coords(1);
	state.imageViewer.currentObjectY = state.imageViewer.objStructs(objectNumber).coords(2);
	state.imageViewer.currentObjectZ = state.imageViewer.objStructs(objectNumber).coords(3);
	state.imageViewer.currentObjectThresh = state.imageViewer.objStructs(objectNumber).threshold(timePoint);
	state.imageViewer.currentObjectText = state.imageViewer.objStructs(objectNumber).text ;

	updateGUIByGlobal('state.imageViewer.currentObject');
	updateGUIByGlobal('state.imageViewer.currentObjectWidth');
	updateGUIByGlobal('state.imageViewer.currentObjectLength');
	updateGUIByGlobal('state.imageViewer.currentObjectMass');
	updateGUIByGlobal('state.imageViewer.currentObjectX');
	updateGUIByGlobal('state.imageViewer.currentObjectY');
	updateGUIByGlobal('state.imageViewer.currentObjectZ');
	updateGUIByGlobal('state.imageViewer.currentObjectThresh');
	updateGUIByGlobal('state.imageViewer.currentObjectText');
	updateGUIByGlobal('state.imageViewer.currentObjectStatus')	
	