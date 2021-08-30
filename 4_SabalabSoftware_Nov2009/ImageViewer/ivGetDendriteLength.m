function ivgetDendriteLength
	global state
	
% 	% if state.imageViewer.denLength is empty initialize it with zeros
% 	if size(state.imageViewer.denLength,1) == 0   %How do I get denLength field to reset to zero when next time series is loaded???
% 		state.imageViewer.denLength=zeros(1,state.imageViewer.tsNumberOfFiles);
% 	end
% 	
	
	timePoint=state.imageViewer.tsFileCounter;
	[x,y]=getpts(state.imageViewer.projAxis(state.imageViewer.selectionChannel));
	
	points = [x y];
	totalLines= length(x)-1;
	total = 0;
	
	for i = 1:totalLines
		x = points(i:(i+1),1);
		y = points(i:(i+1),2);
		a = x(2)-x(1);
		b = y(2) - y(1);
		lengthD = ((state.imageViewer.micronsPerPixelX*a)^2 + (state.imageViewer.micronsPerPixelY*b)^2)^.5; 
		total = total + lengthD;
	end
	
	state.imageViewer.tsDendriteLength(timePoint) = state.imageViewer.tsDendriteLength(timePoint)+total;
	state.imageViewer.currentDendriteLength=state.imageViewer.tsDendriteLength(timePoint);
	updateGUIByGlobal('state.imageViewer.currentDendriteLength');



