function ivSetBoxMask(objectNumber, timePoint, channel, useProjection)
	global state
	if nargin<4 
		useProjection=state.imageViewer.morphChannelIsProj;
	end
	if nargin<3
		channel=state.imageViewer.morphChannel;
	end
	if nargin<1
		objectNumber=state.imageViewer.currentObject;
	end
	if nargin<2
		timePoint=state.imageViewer.tsFileCounter;
	end

	try
		boxX=state.imageViewer.objStructs(objectNumber).boxX(timePoint,:);
		boxY=state.imageViewer.objStructs(objectNumber).boxY(timePoint,:);
	catch
		disp(['*** ivSetBoxMask : box not properly defined for object ' num2str(objectNumber) ' time point ' num2str(timePoint)]);
		return
	end

	if useProjection
		boxMask=roipoly(state.imageViewer.projectionData{channel}, boxX, boxY);
		boxData=state.imageViewer.projectionData{channel}.*boxMask;
	else
		if state.imageViewer.displayedSlice~=state.imageViewer.objStructs(objectNumber).analysisSlice
			state.imageViewer.displayedSlice=state.imageViewer.objStructs(objectNumber).analysisSlice;
			updateGUIByGlobal('state.imageViewer.displayedSlice');
			ivUpdateFigures;
		end
		boxMask=roipoly(state.imageViewer.displaySliceData{channel}, boxX, boxY);
		boxData=state.imageViewer.displaySliceData{channel}.*boxMask;
	end
	
	state.imageViewer.objStructs(objectNumber).boxROIDef{timePoint}=find(boxMask);
	
	boxSubData=boxData(state.imageViewer.objStructs(objectNumber).boxROIDef{timePoint});
	if state.imageViewer.numTopPixels>1
		data2=sort(boxSubData);
		peakVal=mean(data2(end-state.imageViewer.numTopPixels+1:end));
	else
		peakVal=max(boxSubData);
	end
	thresh=(peakVal-state.imageViewer.objStructs(objectNumber).offset(timePoint))*state.imageViewer.widthFraction;
	boxAboveThresh=find(boxSubData>=thresh);
	state.imageViewer.objStructs(objectNumber).boxMask{timePoint} = boxAboveThresh;
	
% 	waveo('allBoxWave', allBox);
% 	waveo('allBoxMaskWave', double(allBoxMask));
% 	waveo('allBoxMaskDataWave', allBoxMaskData);
% 	
% 	waveo('boxMaskWave', boxAboveThresh);
	