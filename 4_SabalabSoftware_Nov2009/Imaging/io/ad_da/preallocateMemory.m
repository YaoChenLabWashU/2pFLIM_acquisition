function preallocateMemory
	global state lastAcquiredFrame imageData projectionData compositeData

	% This function Preallocates the appropriate memory for each acquisition mode.
	%
	% Written by: Thomas Pologruto and Bernardo Sabatini
	% Cold Spring Harbor Labs
	% February 1, 2001

	if state.acq.dualLaserMode==1   % lasers go simulataneously therefor one image window per laser
		channelList=1:state.init.maximumNumberOfInputChannels;
	else
		channelList=[1:state.init.maximumNumberOfInputChannels 11:10+state.init.maximumNumberOfInputChannels];
	end
	
	if ~iscell(projectionData)
		projectionData = cell(1,10+state.init.maximumNumberOfInputChannels);
	end
	
	for channelCounter = channelList
		inputChannelCounter=mod(channelCounter, 10);
		if getfield(state.acq, ['acquiringChannel' num2str(inputChannelCounter)])			% BSMOD 1/18/2 - removed eval for channelOn
			
			if any(size(lastAcquiredFrame{channelCounter})~=[state.acq.linesPerFrame state.acq.pixelsPerLine])
				lastAcquiredFrame{channelCounter} = zeros(state.acq.linesPerFrame, state.acq.pixelsPerLine);
			end
			
			if state.internal.keepAllSlicesInMemory==0
				sliceFactor=1;
			else
				sliceFactor=state.acq.numberOfZSlices;
			end
			
			if state.acq.averaging==1
				frameFactor=1;
			else
				frameFactor=state.acq.numberOfFrames;
			end
			
			if (size(imageData{channelCounter},1)~=state.acq.linesPerFrame)...
					|| (size(imageData{channelCounter},2)~=state.acq.pixelsPerLine)...
					|| (size(imageData{channelCounter},3)~=frameFactor*sliceFactor)
				imageData{channelCounter}=zeros(...
					state.acq.linesPerFrame, ...	% Y
					state.acq.pixelsPerLine, ...	% X
					frameFactor*sliceFactor);		% Z
			end
			
			if getfield(state.acq, ['maxImage' num2str(inputChannelCounter)])
				if (size(projectionData{channelCounter}, 1) ~= state.acq.linesPerFrame) |  ...
						(size(projectionData{channelCounter}, 2) ~= state.acq.pixelsPerLine)
					projectionData{channelCounter} = zeros(state.acq.linesPerFrame, state.acq.pixelsPerLine);
				end
			end
		else
			imageData{channelCounter}=[];
			lastAcquiredFrame{channelCounter}=[];
			projectionData{channelCounter}=[];
		end
	end
	
	if (ndims(compositeData)~=3) || any(size(compositeData)~=[state.acq.linesPerFrame state.acq.pixelsPerLine 3])
		compositeData = (zeros(state.acq.linesPerFrame, state.acq.pixelsPerLine, 3));
	end

