function setTrackerReference
	global state gh
	
	figure(state.internal.GraphFigure(state.acq.trackerChannel));

	k = waitforbuttonpress;

	if isempty(findobj(gcf, 'Type', 'axes'))
		disp('*** NO axes***');
		return
	end
		
		
	point1 = get(gca,'CurrentPoint');    % button down detected
	finalRect = rbbox;                   % return figure units
	set(gh.pcellControl.selectBoxButton, 'ForeGroundColor', [0 0 0]);
	setStatusString('');

	point2 = get(gca,'CurrentPoint');    % button up detected
	point1 = point1(1,1:2);              % extract x and y
	point2 = point2(1,1:2);
	p1 = min(point1,point2);             % calculate locations
	offset = abs(point1-point2);         % and dimensions
	x = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
	y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
	x=round(x);
	y=round(y);
	x0=x(1);
	x1=x(2);
	y0=y(1);
	y1=y(3);
	
	global lastAcquiredFrame
	state.acq.trackerReferenceAll=medfilt2(lastAcquiredFrame{state.acq.trackerChannel});
	state.acq.trackerReference=state.acq.trackerReferenceAll(y0:y1, x0:x1);
	state.internal.trackerX0=x0;
	state.internal.trackerY0=y0;

	state.acq.scanShiftX=0;
	state.acq.scanShiftY=0;
	state.acq.pixelShiftX=0;
	state.acq.pixelShiftY=0;
	
	state.internal.refShiftX= state.acq.postRotOffsetX + state.acq.scanOffsetX;
	state.internal.refShiftY= state.acq.postRotOffsetY + state.acq.scanOffsetY;
	state.internal.refAngle= state.acq.scanRotation;
	state.internal.refZoom= state.acq.zoomFactor;
	
	updateGUIByGlobal('state.acq.scanShiftX');
	updateGUIByGlobal('state.acq.scanShiftY');
	updateGUIByGlobal('state.acq.pixelShiftX');
	updateGUIByGlobal('state.acq.pixelShiftY');
	updateReferenceImage;

	updateClim