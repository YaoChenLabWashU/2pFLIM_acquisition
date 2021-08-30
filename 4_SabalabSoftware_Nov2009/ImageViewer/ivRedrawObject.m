function ivRedrawObject(objectNumber)
	global state
	
	if nargin<1
		objectNumber=state.imageViewer.currentObject;
	end
	
	if isempty(objectNumber)
		objectNumber=state.imageViewer.currentObject;
	end
	
	if (state.imageViewer.selectionChannel>=1 & state.imageViewer.selectionChannel<=4) ...
		| (state.imageViewer.selectionChannel>=11 & state.imageViewer.selectionChannel<=14)
		channel=state.imageViewer.selectionChannel;
	else
		channel=state.imageViewer.selectionChannel-4;
	end

	if size(state.imageViewer.objectCenters,1)==0
		return
	end

	objectNumber=max(min(objectNumber, size(state.imageViewer.objectCenters,1)), 1);
	state.imageViewer.currentObject=objectNumber;
	updateGUIByGlobal('state.imageViewer.currentObject');

	if state.imageViewer.objectStatus(objectNumber)==0
		return
	end
	
	if state.imageViewer.objectAutoCenter
		state.imageViewer.displayedSlice=state.imageViewer.objectCenters(objectNumber,3);
		updateGUIByGlobal('state.imageViewer.displayedSlice');
		ivSetWindowBounds(...
			[state.imageViewer.objectCenters(state.imageViewer.currentObject,1)-2*state.imageViewer.objectRadius ...
			state.imageViewer.objectCenters(state.imageViewer.currentObject,1)+2*state.imageViewer.objectRadius], ...
			[state.imageViewer.objectCenters(state.imageViewer.currentObject,2)-2*state.imageViewer.objectRadius ...
			state.imageViewer.objectCenters(state.imageViewer.currentObject,2)+2*state.imageViewer.objectRadius]);
	%	ivUpdateFigures;
	end
	
	axes=[state.imageViewer.axis(channel) state.imageViewer.projAxis(channel)];

	for counter=1:length(axes)
		try 
			delete(state.imageViewer.objectBoundHandle(counter));
		catch
		end
		state.imageViewer.objectBoundHandle(counter) = rectangle('Position', ...
			[state.imageViewer.objectCenters(objectNumber,1)-state.imageViewer.objectRadius,...
				state.imageViewer.objectCenters(objectNumber,2)-state.imageViewer.objectRadius, ...
				2*state.imageViewer.objectRadius, 2*state.imageViewer.objectRadius], ...
			 'edgecolor', 'r', 'LineWidth', 2, 'LineStyle', '--', 'Parent', axes(counter));
	
		try 
			delete(state.imageViewer.objectLabelHandle(counter));
		catch
		end
		state.imageViewer.objectLabelHandle(counter) = ...
			text(state.imageViewer.objectCenters(objectNumber,1)-state.imageViewer.objectRadius, ...
			state.imageViewer.objectCenters(objectNumber,2)-state.imageViewer.objectRadius, ...
			num2str(objectNumber), 'BackgroundColor', [.7 .9 .7], 'Parent', axes(counter));
	end
	
	for counter=1:length(axes)
		try 
			delete(state.imageViewer.objectMajorLineHandle(counter));
		catch
		end

		try 
			delete(state.imageViewer.objectMinorLineHandle(counter));
		catch
		end
		if state.imageViewer.objectStatus(state.imageViewer.tsFileCounter, objectNumber)==2
			state.imageViewer.objectMinorLineHandle(counter) = line(...
				squeeze(state.imageViewer.objectMinorAxisX(state.imageViewer.tsFileCounter, objectNumber, :)), ...
				squeeze(state.imageViewer.objectMinorAxisY(state.imageViewer.tsFileCounter, objectNumber, :)), ...
				 'color', 'b', 'LineWidth', 2, 'LineStyle', '--', 'Parent', axes(counter));

			 state.imageViewer.objectMajorLineHandle(counter) = line(...
				squeeze(state.imageViewer.objectMajorAxisX(state.imageViewer.tsFileCounter, objectNumber, :)), ...
				squeeze(state.imageViewer.objectMajorAxisY(state.imageViewer.tsFileCounter, objectNumber, :)), ...
				 'color', 'r', 'LineWidth', 2, 'LineStyle', '--', 'Parent', axes(counter));
		 end
	
	end

	switch state.imageViewer.objectStatus(state.imageViewer.tsFileCounter, objectNumber)
		case 0
			color='r';
			lineWidth=1;
		case 1
			color='r';
			lineWidth=1;
		case 2
			color='g';
			lineWidth=1;
		case 3
			color='b';
			lineWidth=2;
	end
			
	
	for counter=1:length(axes)
		try
			delete(state.imageViewer.objectTraceBoundHandle(3*(objectNumber-1)+counter))
		catch
		end
		state.imageViewer.objectTraceBoundHandle(3*(objectNumber-1)+counter) = rectangle('Position', ...
			[state.imageViewer.objectCenters(objectNumber,1)-state.imageViewer.objectRadius/2,...
				state.imageViewer.objectCenters(objectNumber,2)-state.imageViewer.objectRadius/2, ...
				2*state.imageViewer.objectRadius/2, 2*state.imageViewer.objectRadius/2], ...
			 'edgecolor', color, 'LineWidth', lineWidth, 'Curvature', [1 1], 'Parent', axes(counter));
	 end

	if state.imageViewer.objectStatus(state.imageViewer.tsFileCounter, objectNumber)==2
		dataMajor=state.imageViewer.objectMajorProfile{state.imageViewer.tsFileCounter, state.imageViewer.currentObject};
		maskMajor=state.imageViewer.objectMajorMask{state.imageViewer.tsFileCounter, state.imageViewer.currentObject};
		dataMinor=state.imageViewer.objectMinorProfile{state.imageViewer.tsFileCounter, state.imageViewer.currentObject};
		maskMinor=state.imageViewer.objectMinorMask{state.imageViewer.tsFileCounter, state.imageViewer.currentObject};

		state.imageViewer.currentObjectThresh=state.imageViewer.objectThresh(state.imageViewer.tsFileCounter, state.imageViewer.currentObject);
		state.imageViewer.currentObjectWidth=state.imageViewer.objectWidth(state.imageViewer.tsFileCounter, state.imageViewer.currentObject);
		state.imageViewer.currentObjectLength=state.imageViewer.objectLength(state.imageViewer.tsFileCounter, state.imageViewer.currentObject);
		state.imageViewer.currentObjectMass=state.imageViewer.objectMass(state.imageViewer.tsFileCounter, state.imageViewer.currentObject);
		state.imageViewer.currentObjectStatus=state.imageViewer.objectStatus(state.imageViewer.tsFileCounter, state.imageViewer.currentObject)+1;
		
		waveo('objectMinorProfile', dataMinor);
		waveo('objectMinorMaskX', find(maskMinor)-1);
		waveo('objectMinorMaskY', state.imageViewer.currentObjectThresh*ones(1, length(find(maskMinor))));
	
		waveo('objectMajorProfile', dataMajor);
		waveo('objectMajorMaskX', find(maskMajor)-1);
		waveo('objectMajorMaskY', state.imageViewer.currentObjectThresh*ones(1, length(find(maskMajor))));
	else
		state.imageViewer.currentObjectThresh=0;
		state.imageViewer.currentObjectWidth=0;
		state.imageViewer.currentObjectLength=0;
		state.imageViewer.currentObjectMass=0;
		state.imageViewer.currentObjectStatus=state.imageViewer.objectStatus(state.imageViewer.tsFileCounter, state.imageViewer.currentObject)+1;
		
		waveo('objectMinorProfile', []);
		waveo('objectMinorMaskX', []);
		waveo('objectMinorMaskY', []);
	
		waveo('objectMajorProfile', []);
		waveo('objectMajorMaskX', []);
		waveo('objectMajorMaskY', []);
	end		
	updateGUIByGlobal('state.imageViewer.currentObjectThresh');
	updateGUIByGlobal('state.imageViewer.currentObjectWidth');
	updateGUIByGlobal('state.imageViewer.currentObjectLength');
	updateGUIByGlobal('state.imageViewer.currentObjectMass');
	updateGUIByGlobal('state.imageViewer.currentObjectStatus');
	
