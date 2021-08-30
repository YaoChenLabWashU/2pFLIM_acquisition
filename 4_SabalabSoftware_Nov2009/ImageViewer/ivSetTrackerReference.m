function ivSetTrackerReference(redo)
	global state
	
	if nargin<1
		redo=0;
	end
	ivBringSelectionToFront(1);
	
	k = waitforbuttonpress;

	if isempty(findobj(gcf, 'Type', 'axes'))
		disp('*** NO axes***');
		return
	end
		
	point1 = get(gca,'CurrentPoint');    % button down detected
	finalRect = rbbox;                   % return figure units

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
	
	if ~redo
	%	state.imageViewer.trackerReferenceAll=double(get(gco, 'CData'));
		state.imageViewer.trackerReferenceAll = ...
			double(squeeze(state.imageViewer.projectionDataAll{3,state.imageViewer.morphChannel}));
		state.imageViewer.trackerReferenceXZ = ...
			double(squeeze(state.imageViewer.projectionDataAll{2,state.imageViewer.morphChannel}));
		state.imageViewer.trackerReferenceYZ = ...
			double(squeeze(state.imageViewer.projectionDataAll{1,state.imageViewer.morphChannel}));
	end
	state.imageViewer.trackerReference=state.imageViewer.trackerReferenceAll(y0:y1, x0:x1);

	state.imageViewer.trackerX0=x0;
	state.imageViewer.trackerY0=y0;
	state.imageViewer.trackerImage=[];
	state.imageViewer.pixelShiftX=0;
	state.imageViewer.pixelShiftY=0;
	updateGUIByGlobal('state.imageViewer.pixelShiftX');
	updateGUIByGlobal('state.imageViewer.pixelShiftY');
	ivUpdateReferenceImage;


