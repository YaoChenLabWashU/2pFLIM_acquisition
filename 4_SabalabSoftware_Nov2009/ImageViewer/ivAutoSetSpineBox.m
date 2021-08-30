function ivAutoSetSpineBox(objects, timePoints)
% function ivAutoSetSpineBox(objects, timePoints)
% This function automatically generates the 2-D ROI mask for box
% analysis???
	
	global state

	if nargin<2
		timePoints=state.imageViewer.tsFileCounter;
	end
	
	if nargin<1
		objects=state.imageViewer.currentObject;
	end
	
	if isempty(timePoints)
		timePoints=1:state.imageViewer.tsNumberOfFiles;
	end
	
	if isempty(objects)
		objects=1:size(state.imageViewer.objStructs,2);
	end

	for timePoint=timePoints
		ivFlipTimeSeries(timePoint)
		for objectNumber=objects
			xMajor = squeeze(state.imageViewer.objStructs(objectNumber).axis1x(timePoint, :));
			yMajor = squeeze(state.imageViewer.objStructs(objectNumber).axis1y(timePoint, :));
			xMinor = squeeze(state.imageViewer.objStructs(objectNumber).axis2x(timePoint, :));
			yMinor = squeeze(state.imageViewer.objStructs(objectNumber).axis2y(timePoint, :));
			peakVal = state.imageViewer.objStructs(objectNumber).max(timePoint);
			dataMajor = state.imageViewer.objStructs(objectNumber).axisData1{timePoint};
			dataMinor = state.imageViewer.objStructs(objectNumber).axisData2{timePoint};
			if state.imageViewer.autoSetSpineStart
				startDataMajor=state.imageViewer.objStructs(objectNumber).axisMask1{timePoint}(1);
			else
				startDataMajor=1;
			end
			
			smoOffset=floor(state.imageViewer.smoothingWidth/2);	% correction for shift introduced by smoothing
			[xi, yi]=ivLineIntersection([xMajor xMinor], [yMajor yMinor]);	% find where the major and minor axes cross
			startToMaxPix = ...
				round(length(dataMajor)*sqrt((xi-xMajor(1))^2 + (yi-yMajor(1))^2)/sqrt((xMajor(2)-xMajor(1))^2 + (yMajor(2)-yMajor(1))^2));
			
			boxMajorMask=dataMajor>=(peakVal*state.imageViewer.boxFraction);
			boxMajorMask(1:startDataMajor)=0;
			boxMinorMask=dataMinor>=(peakVal*state.imageViewer.boxFraction);
		
 			if startDataMajor>startToMaxPix
				startToMaxPix=startDataMajor;
			end
			[xm, ind]=min(dataMajor(startDataMajor:startToMaxPix));
			majorMinExt=imregionalmin(dataMajor(startDataMajor:startToMaxPix));
			if majorMinExt(ind)~=1	% the min doesn't occur in a local minima
				ind=1;
			end
			ind=ind+startDataMajor-1;
			
			majorMinFraction = max(ind - 1 - smoOffset) / (length(boxMajorMask)-1);
			majorMaxFraction = (max(find(boxMajorMask))-1) / (length(boxMajorMask)-1);
			dxMajor=xMajor(2)-xMajor(1);
			dyMajor=yMajor(2)-yMajor(1);
			if dxMajor==0
				xMajorTrim=xMajor;
			else
				xMajorTrim=xMajor(1)+dxMajor*[majorMinFraction majorMaxFraction]';
			end
			if dyMajor==0
				yMajorTrim=yMajor;
			else
				yMajorTrim=yMajor(1)+dyMajor*[majorMinFraction majorMaxFraction]';
			end
				
			minorMinFraction=max((min(find(boxMinorMask))-1-smoOffset)/(length(boxMinorMask)-1), 0);
			minorMaxFraction=(max(find(boxMinorMask))-1-smoOffset)/(length(boxMinorMask)-1);
			dxMinor=xMinor(2)-xMinor(1);
			dyMinor=yMinor(2)-yMinor(1);
		
			if dxMinor==0
				xMinorTrim=xMinor;
			else
				xMinorTrim=xMinor(1)+dxMinor*[minorMinFraction minorMaxFraction]';
			end
			if dyMinor==0
				yMinorTrim=yMinor;
			else
				yMinorTrim=yMinor(1)+dyMinor*[minorMinFraction minorMaxFraction]';
			end
			range=-state.imageViewer.objectRadius:state.imageViewer.objectRadius;
		
			minorTopX=xMinorTrim-xi+xMajorTrim(1);
			minorTopY=yMinorTrim-yi+yMajorTrim(1);
			minorBottomX=xMinorTrim-xi+xMajorTrim(2);
			minorBottomY=yMinorTrim-yi+yMajorTrim(2);
		
			if minorTopX(1)==minorTopX(2)
				minorTopX=minorTopX';
				minorBottomX=minorBottomX';
			end
			state.imageViewer.objStructs(objectNumber).boxX(timePoint, :) = ...
				[minorTopX' flipdim(minorBottomX', 2)];
			
			if minorTopY(1)==minorTopY(2)
				minorTopY=minorTopY';
				minorBottomY=minorBottomY';
			end
			state.imageViewer.objStructs(objectNumber).boxY(timePoint, :) = ...
				[minorTopY' flipdim(minorBottomY', 2)];
		end
	end
		