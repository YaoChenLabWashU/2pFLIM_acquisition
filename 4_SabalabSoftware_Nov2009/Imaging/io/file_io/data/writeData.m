function writeData
	global state imageData

% writeData.m******
% Function that searches through all the channels and sees which to save.
% It then will save the acquired Data from the global imageData{i} (i = 1:numberOFChannels)
% as tif files.  
% The images are interleaved....They are stored as frame 1, Channel 1, frame 1, Channel 2, ....
% frame 2, channel 1, frame 2, channel 2, ....and Z-slice stacks are stored one after the other.
%
% Each new Z-slice has the string header state.headerString stored in the tif header under the 
% field ImageDescription.
%
% Written By: Bernardo Sabatini and Thomas Pologruto
% Cold Spring Harbor Labs
% Februarry 1, 2001
		
	% Make the file name witht the tif extension
	fileName = [state.files.fullFileName '.tif'];
	
	if state.internal.zSliceCounter == 1
		first = 1;
	else 
		first = 0;
	end
	
	
	% If we are averaging, then there is only 1 frame per Z-Slice
	if state.acq.averaging 
		numberOfFrames = 1;
	else  % If we are not averaging,, there are state.acq.numberOfFrames per slice
		numberOfFrames = state.acq.numberOfFrames;
	end
	
	if state.internal.keepAllSlicesInMemory		% BSMOD 1/18/2
		startingFrame=(state.internal.zSliceCounter-1)*numberOfFrames;
	else
		startingFrame=0;
	end
	
    if state.acq.dualLaserMode==1   % lasers go simulataneously therefor one image window per laser
	    channelList=1:state.init.maximumNumberOfInputChannels;
    else
        channelList=[1:state.init.maximumNumberOfInputChannels 11:10+state.init.maximumNumberOfInputChannels];
    end
    updateHeaderString('state.blaster.indexXList'); %Fitz MOD
    updateHeaderString('state.blaster.indexYList');

    for frameCounter=1:numberOfFrames % Loop through all the frames
   %     first, state.internal.zSliceCounter, startingFrame, frameCounter
		for channelCounter = channelList % Loop through all the channels
	        inputChannel=mod(channelCounter, 10);	
			if inputChannel == 3
				offset=1000;
			else
				offset=0;
			end
			if getfield(state.acq, ['savingChannel' num2str(inputChannel)]) % If saving..
				if first % if its the first frame of first channel, then overwrite...
					imwrite(uint16(offset+imageData{channelCounter}(:,:,frameCounter + startingFrame)) ... % BSMOD 1/18/2
						, fileName,  'WriteMode', 'overwrite', 'Compression', 'none', 'Description', state.headerString);
					first = 0;
				else
					imwrite(uint16(offset+imageData{channelCounter}(:,:,frameCounter + startingFrame)) ... % BSMOD 1/18/2
						, fileName,  'WriteMode', 'append', 'Compression', 'none', ...
						'Description', ['state.internal.triggerTimeInSeconds=' num2str(state.internal.triggerTimeInSeconds) 13]);
				end	
			end
		end
	end
