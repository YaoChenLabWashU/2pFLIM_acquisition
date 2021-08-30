function setupInputChannels
	global state
	
	global focusInput grabInput
	% delete active channels 
	delete(get(focusInput, 'Channel'));
	delete(get(grabInput, 'Channel'));
	delete(get(state.daq.pmtOffsetInput, 'Channel'));
	
	if state.acq.dualLaserMode==1 % if the lasers are on simulataneously then nothing special
		sampleFactor=1;
	elseif state.acq.dualLaserMode==2
		sampleFactor=2;	% if they are alternating, then double the number of acqs before trigger the trigger function
	else
		disp('	setupInputChannels needs more for lasermodes');
	end
	% add channels that are wanted but not active
    
	for channelCounter=1:state.init.maximumNumberOfInputChannels
		if getfield(state.acq, ['acquiringChannel' num2str(channelCounter)]) 
			channel=addchannel(focusInput, channelCounter-1);
			channel.InputRange = [-10 10];
			channel.SensorRange = [-10 10];
			channel.UnitsRange = [-10 10];
			channel.Coupling='DC';
			channel=addchannel(grabInput, channelCounter-1);
			channel.InputRange = [-10 10];
			channel.SensorRange = [-10 10];
			channel.UnitsRange = [-10 10];
			channel.Coupling='DC';
			channel=addchannel(state.daq.pmtOffsetInput, channelCounter-1);
			channel.InputRange = [-10 10];
			channel.SensorRange = [-10 10];
			channel.UnitsRange = [-10 10];
			channel.Coupling='DC';
		end
	end
	
	selectNumberOfStripes;	% select number of stripes based on # channels and resolution
	
	% GRAB acquisition: set up total acquisition duration
	actualInputRate = get(grabInput, 'SampleRate');	
	state.internal.samplesPerLine = round(actualInputRate*state.acq.msPerLine/1000);	
	state.internal.samplesPerFrame = state.internal.samplesPerLine*state.acq.linesPerFrame;
	
	% GRAB acquisition: set up action function trigger (1 per stripe)
	set(grabInput, 'SamplesPerTrigger', sampleFactor*state.internal.samplesPerFrame*state.acq.numberOfFrames);
	set(grabInput, 'SamplesAcquiredFcnCount', sampleFactor*state.internal.samplesPerFrame/state.internal.numberOfStripes); 

	% FOCUS acquisition: set up total acquisition duration
	actualInputRate = get(focusInput, 'SampleRate');
	state.internal.samplesPerStripe = sampleFactor*state.internal.samplesPerLine*state.acq.linesPerFrame/state.internal.numberOfStripes; 		 
	set(focusInput, 'SamplesPerTrigger', ...
		state.internal.samplesPerStripe*state.internal.numberOfStripes); % 1 frame per trigger *state.internal.numberOfFocusFrames);
	set(focusInput, 'TriggerRepeat', state.internal.numberOfFocusFrames)
	
	% FOCUS acquisition: set up action function trigger (1 per stripe)
	set(focusInput, 'SamplesAcquiredFcnCount', state.internal.samplesPerStripe); 
	
	% PMT Offset: set up total acquisition duration 
	actualInputRate = get(state.daq.pmtOffsetInput, 'SampleRate');
	totalSamplesInputOffsets = 50*state.acq.samplesAcquiredPerLine;		% acquire 50 lines of Data
	set(state.daq.pmtOffsetInput, 'SamplesPerTrigger', totalSamplesInputOffsets);

