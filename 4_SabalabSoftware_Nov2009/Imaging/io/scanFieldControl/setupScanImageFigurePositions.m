function setupScanImageFigurePositions

	global state

	aspectRatio = state.internal.imageAspectRatioBias*state.acq.scanAmplitudeY/state.acq.scanAmplitudeX;
	
	for channelCounter = 1:state.init.maximumNumberOfInputChannels
		if state.acq.scanAmplitudeY > 0 & state.acq.scanAmplitudeX > 0
			if aspectRatio <= 1 
				eval(['state.windowPositions.image' num2str(channelCounter) '_position(4) = aspectRatio * state.windowPositions.image' ...
						num2str(channelCounter) '_position(3);'])
				eval(['state.windowPositions.maxImage' num2str(channelCounter) '_position(4) = aspectRatio * state.windowPositions.maxImage' ...
						num2str(channelCounter) '_position(3);'])
			elseif aspectRatio > 1
				eval(['state.windowPositions.image' num2str(channelCounter) '_position(3) = 1/aspectRatio * state.windowPositions.image' ...
						num2str(channelCounter) '_position(4);'])
				eval(['state.windowPositions.maxImage' num2str(channelCounter) '_position(3) = 1/aspectRatio * state.windowPositions.maxImage' ...
						num2str(channelCounter) '_position(4);'])
			end
		end
	end
	
	if state.acq.scanAmplitudeY > 0 & state.acq.scanAmplitudeX > 0
		if aspectRatio <= 1 
			state.windowPositions.compositeImage_position(4) = aspectRatio * state.windowPositions.compositeImage_position(3);
		elseif aspectRatio > 1
			state.windowPositions.compositeImage_position(3) = 1/aspectRatio * state.windowPositions.compositeImage_position(4);
		end
	end