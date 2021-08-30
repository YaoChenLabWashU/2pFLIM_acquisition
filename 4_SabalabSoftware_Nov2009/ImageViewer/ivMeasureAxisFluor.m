function ivProcessAxisMorph(pick, objects, timePoints, channels)
	global state
	
	if nargin<4
		channels=find(state.imageViewer.channelsOn);
	end
	
	if nargin<3
		timePoints=state.imageViewer.tsFileCounter;
	end
	
	if nargin<2
		objects=state.imageViewer.currentObject;
	end

	if nargin<1
		pick=1;
	end
	
	if isempty(channels)
		channels=find(state.imageViewer.channelsOn);
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
		
			if pick
				ivBringSelectionToFront;	
				beep;
				[xMajor, yMajor]=ginput(2);
				if size(xMajor, 1)~=2
					return
				end
			
				[xMinor, yMinor]=ginput(2);
				if size(xMinor,1)~=2
					return
				end
			
				xMajor=round(xMajor);
				yMajor=round(yMajor);
				xMinor=round(xMinor);
				yMinor=round(yMinor);
			else	
				xMajor = squeeze(state.imageViewer.objStructs(objectNumber).axis1x(timePoint, :));
				yMajor = squeeze(state.imageViewer.objStructs(objectNumber).axis1y(timePoint, :));
				xMinor = squeeze(state.imageViewer.objStructs(objectNumber).axis2x(timePoint, :));
				yMinor = squeeze(state.imageViewer.objStructs(objectNumber).axis2y(timePoint, :));
			end
% 			if state.imageViewer.selectionChannelIsProj
% 				[xi, yi]=ivLineIntersection([xMajor xMinor], [yMajor yMinor]);	% find where the major and minor axes cross
% 				i=state.imageViewer.tsCoredFlatProjectionIndex{state.imageViewer.tsFileCounter, state.imageViewer.selectionChannel}(yi-1:yi+1, xi-1:xi+1);
% 				analysisSlice=mode(i);
% 				ivFlipSlice(analysisSlice);
% 			end
			
			for channel=channels			
				dataMajor=ivImageProfile(channel, state.imageViewer.morphChannelIsProj, ...
					state.imageViewer.lineBlur, xMajor, yMajor);
				dataMinor=ivImageProfile(channel, state.imageViewer.morphChannelIsProj, ...
					state.imageViewer.lineBlur, xMinor, yMinor);
			
				if state.imageViewer.offsetMode==1
					offset=getfield(state.imageViewer, ['offsetChannel' num2str(channel)]);
				elseif state.imageViewer.offsetMode==2
					offset=min(dataMinor);
				else 
					offset=0;
				end	
				dataMajor=smooth(dataMajor-offset, state.imageViewer.smoothingWidth);
				dataMinor=smooth(dataMinor-offset, state.imageViewer.smoothingWidth);
	
				setWave('objectMinorProfile', 'data', dataMinor);
				setWave('objectMajorProfile', 'data', dataMajor);
				waveo(['objectMinorProfile_' num2str(channel)], dataMinor);
				waveo(['objectMajorProfile_' num2str(channel)], dataMajor);
				m=max(dataMinor);
				waveo(['objectMinorProfile_n' num2str(channel)], dataMinor/m);
				m=max(dataMajor);
				waveo(['objectMajorProfile_n' num2str(channel)], dataMajor/m);
				global denG denR spineG spineR
				if channel==1
					denG.data(end+1)=mean(dataMajor);
					spineG.data(end+1)=mean(dataMinor);
				elseif channel==2
					denR.data(end+1)=mean(dataMajor);
					spineR.data(end+1)=mean(dataMinor);
				end
					
			end
		end
	end
	