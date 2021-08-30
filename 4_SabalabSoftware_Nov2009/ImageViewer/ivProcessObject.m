function ivProcessObject(objects, timePoints)
% function ivProcessObject(objects, timePoints)
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

    first=1;
	for timePoint=timePoints
		ivFlipTimeSeries(timePoint)
		for objectNumber=objects
			ivFlipSlice(state.imageViewer.objStructs(objectNumber).analysisSlice(timePoint));
            disp(['Time point ' num2str(timePoint) ' object ' num2str(objectNumber) ]);
            
            if first
    			state.imageViewer.objStructs(objectNumber).results = ...
				    repmat(ivEmptyChannelAnalysisStruct, 1, state.imageViewer.tsNumberOfFiles);
            end
			
			channelCounter=1;
			for channelCode=state.imageViewer.validAnaChannels
				if channelCode<0 	% it's a max projection
					channel=-channelCode;
					isMax=1;
				else
					channel=channelCode;
					isMax=0;
				end
				
				if state.imageViewer.analyzeBoxes
					if isMax
						sliceData = state.imageViewer.tsCoredFlatProjection{state.imageViewer.tsFileCounter, channel}...
							(1:state.imageViewer.nPixelsY, 1:state.imageViewer.nPixelsX);
						boxData = double(sliceData(state.imageViewer.objStructs(objectNumber).boxMask{timePoint}))...
							- state.imageViewer.offsets(channel);
					else
						boxData = double(state.imageViewer.displaySliceData{channel}...
							(state.imageViewer.objStructs(objectNumber).boxMask{timePoint}))...
							- state.imageViewer.offsets(channel);
					end	
					state.imageViewer.objStructs(objectNumber).results(timePoint).analysisChannel(channelCounter) = ...
						channelCode;
					state.imageViewer.objStructs(objectNumber).results(timePoint).morphChannel(channelCounter) = ...
						state.imageViewer.morphChannel;
					state.imageViewer.objStructs(objectNumber).results(timePoint).isBox(channelCounter)=1;
					state.imageViewer.objStructs(objectNumber).results(timePoint).avg(channelCounter) = mean(boxData);
					state.imageViewer.objStructs(objectNumber).results(timePoint).max(channelCounter)= max(boxData);
			%		- state.imageViewer.offsets(channel);
					state.imageViewer.objStructs(objectNumber).results(timePoint).size(channelCounter)= length(boxData);
					roiData=boxData(state.imageViewer.objStructs(objectNumber).boxROIDef{timePoint});
					state.imageViewer.objStructs(objectNumber).results(timePoint).maskAvg(channelCounter) = mean(roiData);
					state.imageViewer.objStructs(objectNumber).results(timePoint).maskMax(channelCounter)= max(roiData);
					state.imageViewer.objStructs(objectNumber).results(timePoint).maskSize(channelCounter)= length(roiData);
					channelCounter=channelCounter+1;
				end
				
				if state.imageViewer.analyzeLines
					xMinor = squeeze(state.imageViewer.objStructs(objectNumber).axis2x(timePoint, :));
					yMinor = squeeze(state.imageViewer.objStructs(objectNumber).axis2y(timePoint, :));
					dataMinor=ivImageProfile(channel, isMax, state.imageViewer.lineBlur, xMinor, yMinor);
					
					state.imageViewer.objStructs(objectNumber).results(timePoint).analysisChannel(channelCounter) = ...
						channelCode;
					state.imageViewer.objStructs(objectNumber).results(timePoint).morphChannel(channelCounter) = ...
						state.imageViewer.morphChannel;
					state.imageViewer.objStructs(objectNumber).results(timePoint).isBox(channelCounter)=0;
					
					state.imageViewer.objStructs(objectNumber).results(timePoint).avg(channelCounter) = mean(dataMinor);
					state.imageViewer.objStructs(objectNumber).results(timePoint).max(channelCounter)= max(dataMinor);
						- state.imageViewer.offsets(channel);
					state.imageViewer.objStructs(objectNumber).results(timePoint).size(channelCounter)= length(dataMinor);
					
					roiData=dataMinor(state.imageViewer.objStructs(objectNumber).axisMask2{timePoint});
					state.imageViewer.objStructs(objectNumber).results(timePoint).maskAvg(channelCounter) = mean(roiData);
					state.imageViewer.objStructs(objectNumber).results(timePoint).maskMax(channelCounter)= max(roiData);
					state.imageViewer.objStructs(objectNumber).results(timePoint).maskSize(channelCounter)= length(roiData);
					channelCounter=channelCounter+1;
				end
			end
		end
        first=0;
	end