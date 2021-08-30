function figureButtonOverCallback
	global state projectionData
	% This function will grab the current position and intensity from the figure
	% and display it in the imageGUI Window.

	% Figure out which window you ar ein
	name = get(gcf,'Name');
	lengthOfName = length(name);
	channel = str2num(name(lengthOfName));

	currentPoint = recordCurrentPoint(gca);
	state.internal.currentPointX = round(currentPoint(1,1));
	updateGUIByGlobal('state.internal.currentPointX');
	state.internal.currentPointY = round(currentPoint(1,2));
	updateGUIByGlobal('state.internal.currentPointY');

	global lastAcquiredFrame



	if strcmp('Max', name(1:3))	 % Looking at a max projection
		state.internal.intensity = projectionData{channel}(state.internal.currentPointY, state.internal.currentPointX);
	else
		state.internal.intensity = lastAcquiredFrame{channel}(state.internal.currentPointY, state.internal.currentPointX);
	end

	updateGUIByGlobal('state.internal.intensity');






