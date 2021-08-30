function ivExtendMajorAxis(extendPixels, objects, timePoints)
	global state

	display=1;
	
	if nargin<3
		timePoints=state.imageViewer.tsFileCounter;
	end
	
	if nargin<2
		objects=state.imageViewer.currentObject;
	end
	
	if isempty(timePoints)
		timePoints=1:state.imageViewer.tsNumberOfFiles;
	end
	
	if isempty(objects)
		objects=1:size(state.imageViewer.objStructs,2);
	end

	if nargin<1
		extendPixels=12;
	end
		
	for timePoint=timePoints
		ivFlipTimeSeries(timePoint)
		
		for objectNumber=objects
			if state.imageViewer.objStructs(objectNumber).status(timePoint)==2 	%  everything defined
				
				xMajor = squeeze(state.imageViewer.objStructs(objectNumber).axis1x(timePoint, :));
				yMajor = squeeze(state.imageViewer.objStructs(objectNumber).axis1y(timePoint, :));
	
				majorLen = sqrt((xMajor(2)-xMajor(1))^2 + (yMajor(2)-yMajor(1))^2);
				
				dxMajor=xMajor(2)-xMajor(1);
				dyMajor=yMajor(2)-yMajor(1);
	
				moreX=dxMajor*extendPixels/majorLen;
				moreY=dyMajor*extendPixels/majorLen;
				
				xMajor(1)=xMajor(1)-round(moreX);
				yMajor(1)=yMajor(1)-round(moreY);
				
				state.imageViewer.objStructs(objectNumber).axis1x(timePoint, :) = xMajor;
				state.imageViewer.objStructs(objectNumber).axis1y(timePoint, :) = yMajor;
			end
			ivDefineObjectAxes(1, objectNumber, timePoint, 1);
		end
	end
	
	

		