function ivSelectAnalysisBox(objectNumber, timePoint, nPnts)
% function ivSelectAnalysisBox(objectNumber, timePoint, nPnts)
	global state

	if nargin<3
		nPnts=4;
	end
	
	if nargin<2
		timePoint=state.imageViewer.tsFileCounter;
	end
	
	if nargin<1
		objectNumber=state.imageViewer.currentObject;
	end
		
	ivFlipTimeSeries(timePoint)
	if state.imageViewer.objStructs(state.imageViewer.currentObject).status ~= 2
		state.imageViewer.objStructs(state.imageViewer.currentObject).axis1x(1:state.imageViewer.tsNumberOfFiles, 1:2) = NaN;
		state.imageViewer.objStructs(state.imageViewer.currentObject).axis1y(1:state.imageViewer.tsNumberOfFiles, 1:2) = NaN;
		state.imageViewer.objStructs(state.imageViewer.currentObject).axis2x(1:state.imageViewer.tsNumberOfFiles, 1:2) = NaN;
		state.imageViewer.objStructs(state.imageViewer.currentObject).axis2y(1:state.imageViewer.tsNumberOfFiles, 1:2) = NaN;
		state.imageViewer.objStructs(state.imageViewer.currentObject).status(state.imageViewer.tsFileCounter)=2;			% axis are defined	
	end

	ivBringSelectionToFront;	
	if isempty(nPnts)
		[xCorners, yCorners]=ginput;
		if size(xCorners, 1)<3
			return
		end
		if size(state.imageViewer.objStructs(objectNumber).boxX, 2)~=length(xCorners)
			state.imageViewer.objStructs(objectNumber).boxX = ...
				zeros(size(state.imageViewer.objStructs(objectNumber).boxX, 1), length(xCorners));
			state.imageViewer.objStructs(objectNumber).boxY = ...
				zeros(size(state.imageViewer.objStructs(objectNumber).boxX, 1), length(xCorners));
			disp('*** Resized box ***')	
		end
	else
		[xCorners, yCorners]=ginput(nPnts);
		if size(xCorners, 1)<nPnts
			return
		end
	end

	xCorners=round(xCorners);
	yCorners=round(yCorners);
	
	state.imageViewer.objStructs(objectNumber).boxX(timePoint, :) = ...
		xCorners;
		
	state.imageViewer.objStructs(objectNumber).boxY(timePoint, :) = ...
		yCorners;
			
	ivProcessSpineBox(objectNumber, timePoint)
	ivMakeObjectVisible(objectNumber, timePoint);
