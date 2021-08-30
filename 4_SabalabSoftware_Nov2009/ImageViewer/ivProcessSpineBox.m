function ivProcessSpineBox(objects, timePoints)
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
			state.imageViewer.objStructs(objectNumber).boxMask{timePoint} = ...				% Mask Defined within an arbitrary nPixelsX by nPixelsY matrix using  
				find(roipoly(state.imageViewer.nPixelsY, state.imageViewer.nPixelsX, ...	% .objStructs.boxX and .objStructs.BoxY
				state.imageViewer.objStructs(objectNumber).boxX(timePoint, :), ...
				state.imageViewer.objStructs(objectNumber).boxY(timePoint, :)));

			
			% define the box MASK roi as the region within the box that is
			% above the threshold
			
			if state.imageViewer.morphChannelIsProj
		%		sliceData = state.imageViewer.projectionData{state.imageViewer.morphChannel}...
				sliceData = state.imageViewer.tsCoredFlatProjection{state.imageViewer.tsFileCounter, state.imageViewer.morphChannel}...
					(1:state.imageViewer.nPixelsY, 1:state.imageViewer.nPixelsX);
				boxData = sliceData(state.imageViewer.objStructs(objectNumber).boxMask{timePoint});
				if state.imageViewer.autoSetAnalysisSlice
% 					sliceData = state.imageViewer.projectionIndexData{state.imageViewer.morphChannel}...
					sliceData = state.imageViewer.tsCoredFlatProjectionIndex{state.imageViewer.tsFileCounter, state.imageViewer.morphChannel}...
						(1:state.imageViewer.nPixelsY, 1:state.imageViewer.nPixelsX);
					indexData = sliceData(state.imageViewer.objStructs(objectNumber).boxMask{timePoint});
					[boxDataSort, boxDataSortIndex]=sort(boxData);
					len=round(size(boxData,1)/5);
					state.imageViewer.objStructs(objectNumber).analysisSlice(timePoint) ...
						= mode(indexData(boxDataSortIndex(end-len:end)));
				end				
			else
				boxData = state.imageViewer.displaySliceData{state.imageViewer.morphChannel}...
					(state.imageViewer.objStructs(objectNumber).boxMask{timePoint});
			end
			
			if state.imageViewer.autoSetBoxPeak
				if state.imageViewer.numTopPixels>1
					data2=sort(boxData);
					peakVal=mean(data2(end-state.imageViewer.numTopPixels+1:end))...
						-state.imageViewer.objStructs(objectNumber).offset(timePoint);
				else
					peakVal=max(boxData)...
						-state.imageViewer.objStructs(objectNumber).offset(timePoint);
				end
				thresh = peakVal * state.imageViewer.widthFraction...
					+ state.imageViewer.objStructs(objectNumber).offset(timePoint);
			else
				thresh=state.imageViewer.objStructs(objectNumber).threshold(timePoint) ...
					+ state.imageViewer.objStructs(objectNumber).offset(timePoint);
			end
			
			state.imageViewer.objStructs(objectNumber).boxROIDef{timePoint}=find(boxData>=thresh);
			state.imageViewer.objStructs(objectNumber).area(timePoint) = ...
				length(state.imageViewer.objStructs(objectNumber).boxROIDef{timePoint});	
		
		end
	end
		