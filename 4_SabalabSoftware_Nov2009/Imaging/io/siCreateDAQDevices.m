function siCreateDAQDevices
	global state 

% setups components of AO Objects that are config independent
    if state.analysisMode
        return
	end

	global focusInput focusOutput pcellFocusOutput
	global grabInput grabOutput pcellGrabOutput
	evalin('base','global focusInput focusOutput pcellFocusOutput');
	evalin('base','global grabInput grabOutput pcellGrabOutput');
	
% Mirror Data Output Acquisition (FOCUS)
	focusOutput = analogoutput('nidaq',state.init.mirrorOutputBoardIndex);			
	addchannel(focusOutput, state.init.XMirrorChannelIndex);
	addchannel(focusOutput, state.init.YMirrorChannelIndex);
	set(focusOutput, 'SampleRate', state.acq.outputRate);
    set(focusOutput, 'TriggerType', 'HwDigital');
    set(focusOutput, 'HwDigitalTriggerSource', 'RTSI0');
    set(focusOutput, 'TriggerCondition', 'PositiveEdge');
	set(focusOutput, 'ExternalClockDriveLine', 'RTSI5');
	set(focusOutput, 'RepeatOutput', state.internal.numberOfFocusFrames);
	
% Mirror Data Output Acquisition (GRAB)
	grabOutput = analogoutput('nidaq',state.init.mirrorOutputBoardIndex);
	addchannel(grabOutput, state.init.XMirrorChannelIndex);
	addchannel(grabOutput, state.init.YMirrorChannelIndex);
	set(grabOutput, 'SampleRate', state.acq.outputRate);
	set(grabOutput, 'TriggerType', 'HwDigital');					
    set(grabOutput, 'HwDigitalTriggerSource', 'RTSI0');
    set(grabOutput, 'TriggerCondition', 'PositiveEdge');
	set(grabOutput, 'ExternalClockDriveLine', 'RTSI5');

% Laser Parking Mirror Data Output Acquisition
	state.daq.parkMirrorsOutput = analogoutput('nidaq', state.init.mirrorOutputBoardIndex);			
	addchannel(state.daq.parkMirrorsOutput, state.init.XMirrorChannelIndex);
	addchannel(state.daq.parkMirrorsOutput, state.init.YMirrorChannelIndex);
	set(state.daq.parkMirrorsOutput, 'SampleRate', state.acq.outputRate);
	set(state.daq.parkMirrorsOutput, 'TriggerType', 'Immediate');					

	if state.pcell.pcellOn	% if using pockel cells
	% PCell output board for FOCUS
		pcellFocusOutput = analogoutput('nidaq', state.pcell.pcellBoardIndex);			
		for counter=1:state.pcell.numberOfPcells
			addchannel(pcellFocusOutput, counter-1); % getfield(state.pcell, ['pcellChannelIndex' num2str(counter)]));
		end

		for counter=1:state.pcell.numberOfPcells
			addchannel(pcellFocusOutput, counter-1 + state.pcell.numberOfPcells); %getfield(state.pcell, ['pcellShutterIndex' num2str(counter)]));
		end

		set(pcellFocusOutput, 'SampleRate', state.acq.outputRate);
		set(pcellFocusOutput, 'ClockSource', 'External')
		set(pcellFocusOutput, 'ExternalClockSource', 'RTSI5')
        set(pcellFocusOutput, 'TriggerType', 'HwDigital');
        set(pcellFocusOutput, 'HwDigitalTriggerSource', 'RTSI0');
        set(pcellFocusOutput, 'TriggerCondition', 'PositiveEdge');
		set(pcellFocusOutput, 'RepeatOutput', state.internal.numberOfFocusFrames);
		
	% PCell output board for GRAB
		pcellGrabOutput = analogoutput('nidaq', state.pcell.pcellBoardIndex);			
		for counter=1:state.pcell.numberOfPcells
			addchannel(pcellGrabOutput, counter-1); %getfield(state.pcell, ['pcellChannelIndex' num2str(counter)]));
		end

		for counter=1:state.pcell.numberOfPcells
			addchannel(pcellGrabOutput, counter-1 + state.pcell.numberOfPcells); %getfield(state.pcell, ['pcellShutterIndex' num2str(counter)]));
		end

		set(pcellGrabOutput, 'SampleRate', state.acq.outputRate);
		set(pcellGrabOutput, 'ClockSource', 'External')
		set(pcellGrabOutput, 'ExternalClockSource', 'RTSI5')
        set(pcellGrabOutput, 'TriggerType', 'HwDigital');
        set(pcellGrabOutput, 'HwDigitalTriggerSource', 'RTSI0');
        set(pcellGrabOutput, 'TriggerCondition', 'PositiveEdge');

	end
	
	
%  Piezoelectrode focus control

	if state.piezo.usePiezo  %if using pz electrode
		state.piezo.Output=analogoutput('nidaq', state.piezo.pzBoardIndex);
		addchannel(state.piezo.Output, state.piezo.pzChannelIndex);
		set(state.piezo.Output, 'SampleRate', state.piezo.sampleRate);
	end

% INPUT OBJECTS BELOW
	
% GRAB input object
	grabInput = analoginput('nidaq',state.init.acquisitionBoardIndex);
	set(grabInput, 'SampleRate', state.acq.inputRate);
	set(grabInput, 'SamplesAcquiredFcn', {'makeFrameByStripes'});
    set(grabInput, 'TriggerType', 'Manual');
    set(grabInput, 'ExternalTriggerDriveLine', 'RTSI0');
    set(grabInput, 'ManualTriggerHwOn', 'Trigger');
    
% Focus Input object
	focusInput = analoginput('nidaq',state.init.acquisitionBoardIndex);
	set(focusInput, 'SampleRate', state.acq.inputRate);
	set(focusInput, 'SamplesAcquiredFcn', {'makeStripe'});
    set(focusInput, 'TriggerType', 'Immediate');
    set(focusInput, 'ExternalTriggerDriveLine', 'RTSI0');
	set(pcellFocusOutput, 'RepeatOutput', state.internal.numberOfFocusFrames)	

   
% PMT offsets
	state.daq.pmtOffsetInput = analoginput('nidaq', state.init.acquisitionBoardIndex);
	set(state.daq.pmtOffsetInput, 'TriggerType', 'Immediate');										% 6110E NI Board Set to Trigger PFI0
	set(state.daq.pmtOffsetInput, 'SampleRate', state.acq.inputRate);
	set(state.daq.pmtOffsetInput, 'SamplesAcquiredFcn', {});

