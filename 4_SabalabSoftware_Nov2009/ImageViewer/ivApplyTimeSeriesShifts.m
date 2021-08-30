function ivApplyTimeSeriesShifts
	global state

	channelList=find(state.imageViewer.dataChannels(1:14).*state.imageViewer.anaChannels(1:14));
	state.imageViewer.tsMinShift=min([state.imageViewer.tsShift; [0 0 0]]);		
	state.imageViewer.tsMaxShift=max([state.imageViewer.tsShift; [0 0 0]]);		
	oldSize=size(state.imageViewer.tsStackData{1, channelList(1)});
	state.imageViewer.nPixelsX=oldSize(2);
	state.imageViewer.nPixelsY=oldSize(1);
	if length(oldSize)>2
		state.imageViewer.nSlices=oldSize(3);
	else
		state.imageViewer.nSlices=1;
	end
	updateGUIByGlobal('state.imageViewer.nPixelsX');
	updateGUIByGlobal('state.imageViewer.nPixelsY');
	updateGUIByGlobal('state.imageViewer.nSlices');
	
	if state.imageViewer.trackMode<=2		% no auto track action, just take whole image
		state.imageViewer.tsDataRangeLow=state.imageViewer.tsShift + ...
			repmat([1 1 1], [state.imageViewer.tsNumberOfFiles 1]);
		state.imageViewer.tsDataRangeHigh=state.imageViewer.tsShift + ...
			repmat([state.imageViewer.nPixelsX state.imageViewer.nPixelsY state.imageViewer.nSlices], [state.imageViewer.tsNumberOfFiles 1]);
	elseif state.imageViewer.trackMode==3 % calculate boundaries for coring 
		state.imageViewer.tsDataRangeLow=state.imageViewer.tsShift + ...
			repmat([1 1 1]-state.imageViewer.tsMinShift, [state.imageViewer.tsNumberOfFiles 1]);
		state.imageViewer.tsDataRangeHigh = ...
			repmat(...
				[state.imageViewer.nPixelsX state.imageViewer.nPixelsY state.imageViewer.nSlices]-state.imageViewer.tsMaxShift , ...
				[state.imageViewer.tsNumberOfFiles 1]...
			) + state.imageViewer.tsShift;
	elseif state.imageViewer.trackMode==4 % calculate boundaries for padding 
		state.imageViewer.tsDataRangeLow=...
			repmat([1 1 1]+state.imageViewer.tsMaxShift, [state.imageViewer.tsNumberOfFiles 1])-state.imageViewer.tsShift;
		state.imageViewer.tsDataRangeHigh = state.imageViewer.tsDataRangeLow + ...
			repmat(...
				[state.imageViewer.nPixelsX-1 state.imageViewer.nPixelsY-1 state.imageViewer.nSlices-1], ...
				[state.imageViewer.tsNumberOfFiles 1]);
		newSize=max(state.imageViewer.tsDataRangeHigh);
	end
	
	state.imageViewer.tsCoredStackData=cell(state.imageViewer.tsNumberOfFiles, 20);
	state.imageViewer.tsCoredFlatProjection=cell(state.imageViewer.tsNumberOfFiles, 20);
	state.imageViewer.tsCoredFlatProjectionIndex=cell(state.imageViewer.tsNumberOfFiles, 20);
	state.imageViewer.tsSelectedMask=cell(state.imageViewer.tsNumberOfFiles, 20);
		
	for fileCounter=1:state.imageViewer.tsNumberOfFiles
		for channel=channelList
			disp(['Shifting file ' num2str(fileCounter) ' channel ' num2str(channel) '...'])
			if state.imageViewer.trackMode<=2		% if tracking was off or tracking was but pad/core off...
				state.imageViewer.tsCoredStackData{fileCounter, channel} = ...
					state.imageViewer.tsStackData{fileCounter, channel};
			elseif state.imageViewer.trackMode==3	% track and core
				state.imageViewer.tsCoredStackData{fileCounter, channel} = ...
					state.imageViewer.tsStackData{fileCounter, channel}...
						(...
							state.imageViewer.tsDataRangeLow(fileCounter, 2):state.imageViewer.tsDataRangeHigh(fileCounter, 2), ...
							state.imageViewer.tsDataRangeLow(fileCounter, 1):state.imageViewer.tsDataRangeHigh(fileCounter, 1), ...
							state.imageViewer.tsDataRangeLow(fileCounter, 3):state.imageViewer.tsDataRangeHigh(fileCounter, 3) ...
						);
			elseif state.imageViewer.trackMode==4 % track and pad
				state.imageViewer.tsCoredStackData{fileCounter, channel} = zeros(newSize(2), newSize(1), newSize(3));
				state.imageViewer.tsCoredStackData{fileCounter, channel} (...
					state.imageViewer.tsDataRangeLow(fileCounter, 2):state.imageViewer.tsDataRangeHigh(fileCounter, 2), ...
					state.imageViewer.tsDataRangeLow(fileCounter, 1):state.imageViewer.tsDataRangeHigh(fileCounter, 1), ...
					state.imageViewer.tsDataRangeLow(fileCounter, 3):state.imageViewer.tsDataRangeHigh(fileCounter, 3) ...
					) = state.imageViewer.tsStackData{fileCounter, channel}(:,:,:);
			end
			
			dSize=size(state.imageViewer.tsCoredStackData{fileCounter, channel});
			if length(dSize)<3
				dSize(3)=1;
			end
			
			state.imageViewer.tsCoredFlatProjection{fileCounter, channel}=zeros(dSize(1)+dSize(3), dSize(2)+dSize(3));
			state.imageViewer.tsCoredFlatProjectionIndex{fileCounter, channel}=zeros(dSize(1)+dSize(3), dSize(2)+dSize(3));

			[Y, I]=max(state.imageViewer.tsCoredStackData{fileCounter, channel}, [], 3);
			state.imageViewer.tsCoredFlatProjection{fileCounter, channel}(1:dSize(1), 1:dSize(2))=squeeze(Y);
			state.imageViewer.tsCoredFlatProjectionIndex{fileCounter, channel}(1:dSize(1), 1:dSize(2))=squeeze(I);
			state.imageViewer.tsSelectedMask{fileCounter, channel}=zeros(dSize(1), dSize(2));
			
			if dSize(3)>1
				try
					[Y, I]=max(state.imageViewer.tsCoredStackData{fileCounter, channel}, [], 1);
					state.imageViewer.tsCoredFlatProjection{fileCounter, channel}(1+dSize(1):end, 1:dSize(2))=squeeze(Y)';
					state.imageViewer.tsCoredFlatProjectionIndex{fileCounter, channel}(1+dSize(1):end, 1:dSize(2))=squeeze(I)';
				catch
				end

				try
					[Y I]=max(state.imageViewer.tsCoredStackData{fileCounter, channel}, [], 2);
					state.imageViewer.tsCoredFlatProjection{fileCounter, channel}(1:dSize(1), 1+dSize(2):end)=squeeze(Y);
					state.imageViewer.tsCoredFlatProjectionIndex{fileCounter, channel}(1:dSize(1), 1+dSize(2):end)=squeeze(I);
				catch
				end
			end
		end
	end
	
	oldSize=size(state.imageViewer.tsCoredStackData{1, channelList(1)});
	state.imageViewer.nPixelsX=oldSize(2);
	state.imageViewer.nPixelsY=oldSize(1);
	if length(oldSize)>2
		state.imageViewer.nSlices=oldSize(3);
	else
		state.imageViewer.nSlices=1;
	end
	updateGUIByGlobal('state.imageViewer.nPixelsX');
	updateGUIByGlobal('state.imageViewer.nPixelsY');
	updateGUIByGlobal('state.imageViewer.nSlices');
	