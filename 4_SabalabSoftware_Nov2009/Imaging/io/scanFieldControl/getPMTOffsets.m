function getPMTOffsets
	global state
	
	setStatusString('Reading PMT offsets...');
	
	start(state.daq.pmtOffsetInput);
	
	while strcmp(state.daq.pmtOffsetInput.Running, 'On')
		pause(0.001);
	end
	
	try
		tempData = mean(double(getdata(state.daq.pmtOffsetInput, 'native')))/state.internal.intensityScaleFactor;
	
		inputChannelCounter = 0;
		for channelCounter = 1:state.init.maximumNumberOfInputChannels
			if getfield(state.acq, ['acquiringChannel' num2str(channelCounter)]) % if statement only gets executed when there is a channel to acquire.
				inputChannelCounter = inputChannelCounter + 1;
				eval(['state.acq.pmtOffsetChannel' num2str(channelCounter) ' = tempData(inputChannelCounter);']);
				updateHeaderString(['state.acq.pmtOffsetChannel' num2str(channelCounter)]);
			end
			%state.acq.pmtOffsetChannel4 = tempData(4);
			%updateHeaderString('state.acq.pmtOffsetChannel4');
		end
	catch
		setStatusString('Error in pmt offsets');
		disp(['getPMTOffsets: caught error :' lasterr]);
	end
	
	setStatusString('');
	
	
