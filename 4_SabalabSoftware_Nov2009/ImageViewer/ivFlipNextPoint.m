function ivFlipNextPoint
	global state

	newTimePoint=state.imageViewer.tsFileCounter+1;
	if newTimePoint>state.imageViewer.tsNumberOfFiles			%switch to next object if end of time series has been reached
		newTimePoint=1;
		state.imageViewer.currentObject=state.imageViewer.currentObject+1;
		if state.imageViewer.currentObject>length(state.imageViewer.objStructs)
			state.imageViewer.currentObject=1;
		end
		updateGUIByGlobal('state.imageViewer.currentObject');
		ivFlipTimeSeries(newTimePoint);
		ivHighlightObject;
		beep;
	else
		ivFlipTimeSeries(newTimePoint);
	end
	if ((state.imageViewer.tsFileCounter>1) & ...
		state.imageViewer.objStructs(state.imageViewer.currentObject).status(state.imageViewer.tsFileCounter)<2)
		if state.imageViewer.objStructs(state.imageViewer.currentObject).status(state.imageViewer.tsFileCounter-1)==2		%if axis are defined in the previous time point
			if state.imageViewer.autoLocalTrack
				ivFindObjectShift;																	%if auto track is on, figure out new axis coordinates
				state.imageViewer.objStructs(state.imageViewer.currentObject).axis1x(state.imageViewer.tsFileCounter, :) = ...
					state.imageViewer.objStructs(state.imageViewer.currentObject).axis1x(state.imageViewer.tsFileCounter-1, :) - ...
					state.imageViewer.lastObjectShift(2);
				state.imageViewer.objStructs(state.imageViewer.currentObject).axis1y(state.imageViewer.tsFileCounter, :) = ...
					state.imageViewer.objStructs(state.imageViewer.currentObject).axis1y(state.imageViewer.tsFileCounter-1, :) - ...
					state.imageViewer.lastObjectShift(1);
				state.imageViewer.objStructs(state.imageViewer.currentObject).axis2x(state.imageViewer.tsFileCounter, :) = ...
					state.imageViewer.objStructs(state.imageViewer.currentObject).axis2x(state.imageViewer.tsFileCounter-1, :) - ...
					state.imageViewer.lastObjectShift(2);
				state.imageViewer.objStructs(state.imageViewer.currentObject).axis2y(state.imageViewer.tsFileCounter, :) = ...
					state.imageViewer.objStructs(state.imageViewer.currentObject).axis2y(state.imageViewer.tsFileCounter-1, :) - ...
					state.imageViewer.lastObjectShift(1);
				state.imageViewer.objStructs(state.imageViewer.currentObject).boxX(state.imageViewer.tsFileCounter, :) = ...
					state.imageViewer.objStructs(state.imageViewer.currentObject).boxX(state.imageViewer.tsFileCounter-1, :) - ...
					state.imageViewer.lastObjectShift(2);
				state.imageViewer.objStructs(state.imageViewer.currentObject).boxY(state.imageViewer.tsFileCounter, :) = ...
					state.imageViewer.objStructs(state.imageViewer.currentObject).boxY(state.imageViewer.tsFileCounter-1, :) - ...
					state.imageViewer.lastObjectShift(1);		
				state.imageViewer.objStructs(state.imageViewer.currentObject).status(state.imageViewer.tsFileCounter)=2;
			else																					% otherwise, use the coordinates from the previous time point
				state.imageViewer.objStructs(state.imageViewer.currentObject).axis1x(state.imageViewer.tsFileCounter, :) = ...
					state.imageViewer.objStructs(state.imageViewer.currentObject).axis1x(state.imageViewer.tsFileCounter-1, :);
				state.imageViewer.objStructs(state.imageViewer.currentObject).axis1y(state.imageViewer.tsFileCounter, :) = ...
					state.imageViewer.objStructs(state.imageViewer.currentObject).axis1y(state.imageViewer.tsFileCounter-1, :);
				state.imageViewer.objStructs(state.imageViewer.currentObject).axis2x(state.imageViewer.tsFileCounter, :) = ...
					state.imageViewer.objStructs(state.imageViewer.currentObject).axis2x(state.imageViewer.tsFileCounter-1, :);
				state.imageViewer.objStructs(state.imageViewer.currentObject).axis2y(state.imageViewer.tsFileCounter, :) = ...
					state.imageViewer.objStructs(state.imageViewer.currentObject).axis2y(state.imageViewer.tsFileCounter-1, :);
				state.imageViewer.objStructs(state.imageViewer.currentObject).boxX(state.imageViewer.tsFileCounter, :) = ...
					state.imageViewer.objStructs(state.imageViewer.currentObject).boxX(state.imageViewer.tsFileCounter-1, :);
				state.imageViewer.objStructs(state.imageViewer.currentObject).boxY(state.imageViewer.tsFileCounter, :) = ...
					state.imageViewer.objStructs(state.imageViewer.currentObject).boxY(state.imageViewer.tsFileCounter-1, :);
				state.imageViewer.objStructs(state.imageViewer.currentObject).status(state.imageViewer.tsFileCounter)=2;
			end
			ivDefineObjectAxes(1, state.imageViewer.currentObject, state.imageViewer.tsFileCounter, 1);
%			set(state.imageViewer.objectBoundHandle, 'edgecolor', 'b');
		elseif state.imageViewer.objStructs(state.imageViewer.currentObject).status(state.imageViewer.tsFileCounter-1)==3
			state.imageViewer.objStructs(state.imageViewer.currentObject).status(state.imageViewer.tsFileCounter)=3;
			ivHighlightObject;
	%		set(state.imageViewer.objectBoundHandle, 'edgecolor', 'b');
		else
			ivHighlightObject;
		end
	else
		ivHighlightObject;
	end
	