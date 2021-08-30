function ivAutoSetSpineBox(translate)
	global state

	if nargin<1 
		translate=0;
	end
	
	objectNumber=state.imageViewer.currentObject;
	timePoint=state.imageViewer.tsFileCounter;

	[xNew, yNew]=ginput(1);
	if isempty(xNew)
		return
	end
	xMajor = squeeze(state.imageViewer.objStructs(objectNumber).axis1x(timePoint, :));
	yMajor = squeeze(state.imageViewer.objStructs(objectNumber).axis1y(timePoint, :));
	xMinor = squeeze(state.imageViewer.objStructs(objectNumber).axis2x(timePoint, :));
	yMinor = squeeze(state.imageViewer.objStructs(objectNumber).axis2y(timePoint, :));

	[xi, yi]=ivLineIntersection([xMajor xMinor], [yMajor yMinor]);	% find where the major and minor axes cross

	if translate % shift the lines to the new intersection
		xMinor=round(xMinor+xNew-xi);
		yMinor=round(yMinor+yNew-yi);
		xMajor=round(xMajor+xNew-xi);
		yMajor=round(yMajor+yNew-yi);

		state.imageViewer.objStructs(objectNumber).axis1x(timePoint, :) = xMajor;
		state.imageViewer.objStructs(objectNumber).axis1y(timePoint, :) = yMajor;
		state.imageViewer.objStructs(objectNumber).axis2x(timePoint, :) = xMinor;
		state.imageViewer.objStructs(objectNumber).axis2y(timePoint, :) = yMinor;
		state.imageViewer.objStructs(objectNumber).status(timePoint)=2;
	else % pivot the lines to the new intersection
		majorLen=sqrt((xMajor(2)-xMajor(1))^2 + (yMajor(2)-yMajor(1))^2);
		tipLen=sqrt((xMajor(2)-xi)^2 + (yMajor(2)-yi)^2);
		newBaseLen=sqrt((xNew-xMajor(1))^2 + (yNew-yMajor(1))^2);
		
		xMajor(2) = xNew + tipLen*(xNew-xMajor(1))/newBaseLen;
		yMajor(2) = yNew + tipLen*(yNew-yMajor(1))/newBaseLen;
		xMinor=xMinor+xNew-xi;
		yMinor=yMinor+yNew-yi;
		
		xMajor=round(xMajor);
		yMajor=round(yMajor);
		xMinor=round(xMinor);
		yMinor=round(yMinor);
					
		state.imageViewer.objStructs(objectNumber).axis1x(timePoint, :) = xMajor;
		state.imageViewer.objStructs(objectNumber).axis1y(timePoint, :) = yMajor;
		state.imageViewer.objStructs(objectNumber).axis2x(timePoint, :) = xMinor;
		state.imageViewer.objStructs(objectNumber).axis2y(timePoint, :) = yMinor;
		state.imageViewer.objStructs(objectNumber).status(timePoint)=2;
	end
	state.imageViewer.objStructs(objectNumber).boxX(timePoint, :) = ...
		round(state.imageViewer.objStructs(objectNumber).boxX(timePoint, :) + xNew-xi);
	state.imageViewer.objStructs(objectNumber).boxY(timePoint, :) = ...
		round(state.imageViewer.objStructs(objectNumber).boxY(timePoint, :) + yNew-yi);
	
	ivProcessAxisMorph(objectNumber, timePoint, 1);
