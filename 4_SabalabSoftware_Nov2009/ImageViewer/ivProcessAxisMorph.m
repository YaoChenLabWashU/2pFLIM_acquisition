function ivProcessAxisMorph(objects, timePoints, display)
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
			disp(['*** Defining object axes for object #' num2str(objectNumber) ' time point #' num2str(timePoint) ]);

			if state.imageViewer.objStructs(objectNumber).status(timePoint)~=2 	% not everything defined
				state.imageViewer.objStructs(objectNumber).width(timePoint)=0;
				state.imageViewer.objStructs(objectNumber).length(timePoint)=0;
				state.imageViewer.objStructs(objectNumber).max(timePoint)=0 ;
			else
				xMajor = squeeze(state.imageViewer.objStructs(objectNumber).axis1x(timePoint, :));
				yMajor = squeeze(state.imageViewer.objStructs(objectNumber).axis1y(timePoint, :));
				xMinor = squeeze(state.imageViewer.objStructs(objectNumber).axis2x(timePoint, :));
				yMinor = squeeze(state.imageViewer.objStructs(objectNumber).axis2y(timePoint, :));
				if state.imageViewer.selectionChannelIsProj
					[xi, yi]=ivLineIntersection([xMajor xMinor], [yMajor yMinor]);	% find where the major and minor axes cross
					i=state.imageViewer.tsCoredFlatProjectionIndex{state.imageViewer.tsFileCounter, state.imageViewer.selectionChannel}(yi-1:yi+1, xi-1:xi+1);
					state.imageViewer.objStructs(objectNumber).analysisSlice(timePoint)=mode(i);
					ivFlipSlice(state.imageViewer.objStructs(objectNumber).analysisSlice(timePoint));
				end
				
				dataMajor=ivImageProfile(state.imageViewer.morphChannel, state.imageViewer.morphChannelIsProj, ...
					state.imageViewer.lineBlur, xMajor, yMajor);
				dataMinor=ivImageProfile(state.imageViewer.morphChannel, state.imageViewer.morphChannelIsProj, ...
					state.imageViewer.lineBlur, xMinor, yMinor);
			
				if state.imageViewer.offsetMode==1
					offset=getfield(state.imageViewer, ['offsetChannel' num2str(state.imageViewer.morphChannel)]);
				elseif state.imageViewer.offsetMode==2
					offset=min(dataMinor);
				else 
					offset=0;
				end	
				dataMajor=smooth(dataMajor-offset, state.imageViewer.smoothingWidth);
				dataMinor=smooth(dataMinor-offset, state.imageViewer.smoothingWidth);
				

				if state.imageViewer.autoSetSpineStart
					rMax=find(imregionalmax(dataMajor));
					if isempty(rMax)
						[denPeakVal, denPeakInd]=max(dataMajor);
					else
						denPeakInd=rMax(1);
						denPeakVal=dataMajor(denPeakInd);
					end
					denPeakThresh=denPeakVal*state.imageViewer.spineStartThresh;
					belowThresh=find(dataMajor(denPeakInd:end)<denPeakThresh)+denPeakInd-1;
					firstNonDen=belowThresh(1);
					rMin=find(imregionalmin(dataMajor(denPeakInd:firstNonDen)));
					if ~isempty(rMin)
						firstNonDen=rMin(1)+denPeakInd-1;
					end
					
					nonDenMask=[repmat(0, 1, firstNonDen-1) repmat(1, 1, length(dataMajor)-firstNonDen+1)];
				else
					nonDenMask=dataMajor > -1e20;
					firstNonDen=1;
				end
				
				if state.imageViewer.numTopPixels>1
					data2=sort(dataMinor);
					peakVal=mean(data2(end-state.imageViewer.numTopPixels+1:end));
				else
					peakVal=max(dataMinor);
				end
				thresh=peakVal*state.imageViewer.widthFraction;
				maskMinor=dataMinor>=thresh;
				maskMajor=(dataMajor>=thresh) & nonDenMask;
				firstMask=find(maskMajor);
				if firstMask(1)>firstNonDen
					maskMajor(firstNonDen:firstMask(1))=1;
				end
				maskMajorIndices=find(maskMajor);
				maskMinorIndices=find(maskMinor);
				
				state.imageViewer.objStructs(objectNumber).width(timePoint) = length(maskMinorIndices);
				state.imageViewer.objStructs(objectNumber).length(timePoint) = length(maskMajorIndices);
				state.imageViewer.objStructs(objectNumber).max(timePoint) = peakVal;
				state.imageViewer.objStructs(objectNumber).analysisSlice(timePoint) ...
					= state.imageViewer.displayedSlice;
				state.imageViewer.objStructs(objectNumber).threshold(timePoint) = thresh;
				state.imageViewer.objStructs(objectNumber).offset(timePoint) = offset;
				state.imageViewer.objStructs(objectNumber).axisMask1{timePoint} = maskMajorIndices;
				state.imageViewer.objStructs(objectNumber).axisMask2{timePoint} = maskMinorIndices;
				state.imageViewer.objStructs(objectNumber).status(timePoint)=2;
				state.imageViewer.objStructs(objectNumber).axisData1{timePoint} = dataMajor;  %line analysis data
				state.imageViewer.objStructs(objectNumber).axisData2{timePoint} = dataMinor;
			
				if display
					setWave('objectMinorProfile', 'data', dataMinor);
					setWave('objectMinorMaskX', 'data', maskMinorIndices-1);
					setWave('objectMinorMaskY', 'data', thresh*ones(1, length(maskMinorIndices)));
								
					setWave('objectMajorProfile', 'data', dataMajor);
					setWave('objectMajorMaskX', 'data', maskMajorIndices-1);
					setWave('objectMajorMaskY', 'data', thresh*ones(1, length(maskMajorIndices)));
				end
				if state.imageViewer.autoSetAnalysisBox
					ivAutoSetSpineBox(objectNumber, timePoint);
				else
					disp('Using manually set box');
				end
				ivProcessSpineBox(objectNumber, timePoint)
			end			
			if display
				ivMakeObjectVisible(objectNumber, timePoint);
			end
		end
	end
	
