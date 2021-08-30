function ivProcessObject(objects, timePoints, store)
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
	state.imageViewer.momentsResults=zeros(max(timePoints), max(objects), length(state.imageViewer.validAnaChannels), 9);
	
	for timePoint=timePoints
		ivFlipTimeSeries(timePoint)
		for objectNumber=objects
	%		ivFlipSlice(state.imageViewer.objStructs(objectNumber).analysisSlice(timePoint));
            disp(['Time point ' num2str(timePoint) ' object ' num2str(objectNumber) ]);

			channelCounter=1;
			x1=state.imageViewer.objStructs(objectNumber).coords(1);
			y1=state.imageViewer.objStructs(objectNumber).coords(2);
			len=state.imageViewer.objectRadius;
			
			for channelCode=[-1 -2]; % state.imageViewer.validAnaChannels
				if channelCode<0 	% it's a max projection
					channel=-channelCode;
					isMax=1;
				else
					channel=channelCode;
					isMax=0;
				end
				
				if state.imageViewer.analyzeBoxes
					if isMax
						boxData = double(state.imageViewer.tsCoredFlatProjection{state.imageViewer.tsFileCounter, channel} ...
							(y1-len:y1+len, x1-len:x1+len)) ...
							- state.imageViewer.offsets(channel);
					else
						boxData = double(state.imageViewer.displaySliceData{channel} ...
							(y1-len:y1+len, x1-len:x1+len)) ...
							- state.imageViewer.offsets(channel);
					end	
					[xc, yc, mass, peakVal, pixSize, lineParam]=ivCenterOfMass(boxData);

					lineAngle=180*atan2(lineParam(1), 1)/pi;
					[mI, rTotal, rMinor, rMajor]=ivMomentOfInertia(boxData, xc, yc, mass, lineAngle);

%					ivBringSelectionToFront;
%					state.lh=line(x1-len+xc-1+[-10 0 +10], y1-len+yc-1+lineParam(1)*[-10 0 10]);
					
					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 1)=[xc-len];
					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 2)=[yc-len];
					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 3)=mass;
					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 4)=pixSize;
					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 5)=lineAngle;
					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 6)=mI;
					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 7)=rTotal;
					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 8)=rMinor;
					state.imageViewer.momentsResults(timePoint, objectNumber, channelCounter, 9)=rMajor;
					channelCounter=channelCounter+1;
				end
			end
		end
        first=0;
	end