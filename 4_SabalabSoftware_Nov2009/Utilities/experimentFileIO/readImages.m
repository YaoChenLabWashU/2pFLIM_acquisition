function readImages(fname, pname)
	global state imageData projectionData
	
	if isnumeric(fname)
		fname=[state.files.baseName zeroPadNum2Str(fname)];
		pname=state.files.savePath;
	end
		
	state.internal.lastTaskDone=3;
	state.internal.status=0;
	try
		imageInfo=imfinfo(fullfile(pname, [fname '.tif']));
		length(imageInfo);
		state.lastHeader=imageInfo(1).ImageDescription;
	catch
		lasterr
		return
	end
	
	disp(['*** READING from : ' fullfile(pname, [fname '.tif'])]);
	chanOn=[valueFromHeaderString('state.acq.savingChannel1', state.lastHeader) ...
			valueFromHeaderString('state.acq.savingChannel2', state.lastHeader) ...
			valueFromHeaderString('state.acq.savingChannel3', state.lastHeader)];

	nChannels=sum(chanOn);
	chans=find(chanOn);
	
	nFrames=valueFromHeaderString('state.acq.numberOfFrames', state.lastHeader);

	imageData=cell(1,state.init.maximumNumberOfInputChannels);
	try
		for frameCounter=1:valueFromHeaderString('state.acq.numberOfFrames', state.lastHeader)
			for channelCounter=1:length(chans)
				channel=chans(channelCounter);
				disp(['    reading channel #' num2str(channel) ' frame ' num2str(frameCounter)])
				if frameCounter==1
					imageData{channel}=imread(fullfile(pname, [fname '.tif']), channelCounter);
				%	set(state.internal.maximagehandle(counter), 'EraseMode', 'none', 'CData', projectionData{counter});
				else
					imageData{channel}(:,:,frameCounter) = ...
						imread(fullfile(pname, [fname '.tif']), channelCounter+(frameCounter-1)*nChannels);
				%	set(state.internal.maximagehandle(counter), 'EraseMode', 'none', 'CData', projectionData{counter});
				end
			end
		end
	catch
		disp(['readImages : ' lasterr]);
	end
	updateClim;
    
    state.acq.binFactor=valueFromHeaderString('state.acq.binFactor', state.lastHeader);
    
	for channel=1:state.init.maximumNumberOfInputChannels
        eval(['state.acq.pmtOffsetChannel' num2str(channel) '=' ...
            'valueFromHeaderString([''state.acq.pmtOffsetChannel'' num2str(channel)], state.lastHeader);']);
		scanSize = size(imageData{channel});
		if isempty(imageData{channel})
			waveo(['imageWave' num2str(channel)], []);
		elseif ndims(imageData{channel})==3
			tempData = permute(imageData{channel}, [2 1 3]);
			waveo(['imageWave' num2str(channel)], tempData(:,:)');
		else
			waveo(['imageWave' num2str(channel)], imageData{channel});
		end
	end