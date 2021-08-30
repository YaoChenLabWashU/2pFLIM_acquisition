function writeMaxData
% saves the max projection data into a 16 bit tiff files.  Each channel is saved sequentially in
% the same file
	global state projectionData
	
	if (~state.acq.averaging) && (state.acq.numberOfFrames > 1)		% if it is not possible to do a max
		return													% then return
	end
	
	if state.acq.dualLaserMode==1   % lasers go simulataneously therefor one image window per laser
		channelList=1:state.init.maximumNumberOfInputChannels;
	else
		channelList=[1:state.init.maximumNumberOfInputChannels 11:10+state.init.maximumNumberOfInputChannels];
	end
	
	first = 1;
	for channelCounter = channelList % Loop through all the channels
		inputChannel=mod(channelCounter, 10);	
		if getfield(state.acq, ['maxImage' num2str(inputChannel)]) ...	% if max is on
				&& getfield(state.acq, ['savingChannel' num2str(inputChannel)])	% and channel is saved
			if state.acq.maxMode==1
				projectionData{channelCounter}=uint16(projectionData{channelCounter});
			end
			if first
				fileName = [state.files.fullFileName 'max.tif'];
				imwrite(uint16(projectionData{channelCounter}), fileName,  'WriteMode', 'overwrite', ...
					'Compression', 'none', 'Description', state.headerString);	
				first = 0;
			else
				imwrite(uint16(projectionData{channelCounter}), fileName,  'WriteMode', 'append', ...
					'Compression', 'none', 'Description', state.headerString);	
			end
		end	
	end
	
