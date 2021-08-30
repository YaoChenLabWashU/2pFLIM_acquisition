function ivIterativeAxisAdjust(objects, timePoints)
	global state
	
	if nargin<3
		display=0;
	end
	
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
			dxMajor=xMajor(2)-xMajor(1);
			dyMajor=yMajor(2)-yMajor(1);
			lenMajor=sqrt(dxMajor^2 + dyMajor^2);
			dxMinor=xMinor(2)-xMinor(1);
			dyMinor=yMinor(2)-yMinor(1);
			lenMinor=sqrt(dxMinor^2 + dyMinor^2);
			

			done=0;
			while ~done
				dataMajor=ivImageProfile(state.imageViewer.morphChannel, state.imageViewer.morphChannelIsProj, ...
					state.imageViewer.lineBlur, xMajor, yMajor);
				[m, i]=max(dataMajor);
				
				
			end
			dataMinor=ivImageProfile(state.imageViewer.morphChannel, state.imageViewer.morphChannelIsProj, ...
				state.imageViewer.lineBlur, xMinor, yMinor);

			
			peakVal = state.imageViewer.objStructs(objectNumber).max(timePoint);
			dataMajor = state.imageViewer.objStructs(objectNumber).axisData1{timePoint};
			dataMinor = state.imageViewer.objStructs(objectNumber).axisData2{timePoint};
		
			smoOffset=floor(state.imageViewer.smoothingWidth/2);	% correction for shift introduced by smoothing
			[xi, yi]=ivLineIntersection([xMajor xMinor], [yMajor yMinor]);	% find where the major and minor axes cross
			startToMaxPix = ...
				round(length(dataMajor)*sqrt((xi-xMajor(1))^2 + (yi-yMajor(1))^2)/sqrt((xMajor(2)-xMajor(1))^2 + (yMajor(2)-yMajor(1))^2));
			
			
		end
		
	end