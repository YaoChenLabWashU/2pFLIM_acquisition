function setupPhysDaqPulse(force)
	if nargin<1
		force=0;
	end

	global state physOutputDevice physAuxOutputDevice physInputDevice

	if get(physOutputDevice, 'SamplesAvailable')>0
		flushPhysData;
    end
    
	state.cycle.lastPulseUsed0 = state.cycle.pulseToUse0;
	state.cycle.lastPulseUsed1 = state.cycle.pulseToUse1;
	if ~state.phys.internal.runningMode && ((state.cycle.pulseToUse0>0) || (state.cycle.pulseToUse1>0))
		if force || state.phys.internal.needNewChannels
			delete(get(physOutputDevice, 'Channel'));
			added=0;

			if state.cycle.lastPulseUsed0
				chanAdded=addchannel(physOutputDevice, 0);
				set(chanAdded, 'OutputRange', [-10 10], 'UnitsRange', [-10 10]);
				added=1;
			end
			if state.cycle.lastPulseUsed1
				chanAdded=addchannel(physOutputDevice, 1);
				set(chanAdded, 'OutputRange', [-10 10], 'UnitsRange', [-10 10]);
				added=1;
			end

			state.phys.internal.needNewChannels=0;
			state.phys.internal.needNewOutputData=1;
		end

		if state.phys.internal.needNewOutputData
			output=[];
			for counter=0:1
				patternNum= eval(['state.cycle.lastPulseUsed' num2str(counter)]);
				RSPattern=[];
				if patternNum
					makePulsePattern(patternNum, 0);
					if getfield(state.phys.settings, ['channelType' num2str(counter)])>1
						if getfield(state.phys.settings, ['currentClamp' num2str(counter)])
							extraGain=getfield(state.phys.settings, ['extraGain' num2str(counter)]);
							gain=getfield(state.phys.settings, ['pAPerVOut' num2str(counter)]);
							if state.cycle.CCRCPulse
								makePulsePattern(state.cycle.CCRCPulse, 0);
								RSPattern=eval(['state.pulses.pulsePattern' num2str(state.cycle.CCRCPulse)])';
							end
						else
							extraGain=getfield(state.phys.settings, ['extraGain' num2str(counter)]);
							gain=getfield(state.phys.settings, ['mVPerVOut' num2str(counter)]);
							if state.cycle.VCRCPulse
								makePulsePattern(state.cycle.VCRCPulse, 0);
								RSPattern=eval(['state.pulses.pulsePattern' num2str(state.cycle.VCRCPulse)])';
							end
						end
					else
						extraGain=getfield(state.phys.settings, ['extraGain' num2str(counter)]);
						gain=1;
					end
					if isempty(output)
						output=(extraGain/gain)*eval(['state.pulses.pulsePattern' num2str(patternNum)])';
					else
						pattern=eval(['state.pulses.pulsePattern' num2str(patternNum)]);
						len=max(size(pattern, 2), size(output,1));

						if len>size(output,1)
							output(end+1:len,end)=output(end,end);		% fill with last point repeated
						end
						if len>size(pattern, 2)
							pattern(end+1:len)=pattern(end);		% fill with last point repeated							
						end
						output(1:len,end+1) = (extraGain/gain)*pattern(1:len)';
					end
					if ~isempty(RSPattern)
						len=min(size(RSPattern,1),size(output,1));
						output(1:len, counter+1)=output(1:len, counter+1)+(RSPattern(1:len)/gain);
					end
				end
			end
			if (state.cycle.lastPulseUsed0==0) && (state.cycle.lastPulseUsed1==0)
				disp('setupPhysDaqPulse : No ouput selected.  Using 1 second of blank output');
				output=zeros(round(state.phys.settings.outputRate),1);
			end

			state.phys.daq.output=output;				% save the output data for next time
			state.phys.internal.needNewOutputData=0;
		end

		putdata(physOutputDevice, state.phys.daq.output);
	end
	
	if (state.phys.internal.runningMode==1)
		numberOfInputSamples=Inf;
		state.phys.internal.samplesPerStripe...
			= round((state.phys.settings.runViewSliceDuration*state.phys.settings.inputRate)/state.phys.internal.stripes);
	else
		if state.cycle.inputTracksOutputList(state.cycle.currentCyclePosition)==1
			if (state.cycle.lastPulseUsed0==0) && (state.cycle.lastPulseUsed1==0)
				disp('*** WARNING: Input duration tracks output is enable but no output is selected ***')
				disp('***          Input duration set to 1 second default ***')
				numberOfInputSamples=round(state.phys.settings.inputRate/state.phys.internal.stripes)*state.phys.internal.stripes;
			else				
				numberOfInputSamples=round((size(state.phys.daq.output,1)*state.phys.settings.inputRate/state.phys.settings.outputRate)/state.phys.internal.stripes)*state.phys.internal.stripes;
			end
			state.phys.internal.samplesPerStripe=numberOfInputSamples/state.phys.internal.stripes;
		else			
			if (state.cycle.recordingDurationList(state.cycle.currentCyclePosition)==0)
				if (state.cycle.lastPulseUsed0==0) && (state.cycle.lastPulseUsed1==0)
					disp('*** WARNING: No input duration given. Set to 1 second default ***')
					numberOfInputSamples=round(state.phys.settings.inputRate/state.phys.internal.stripes)*state.phys.internal.stripes;
				else				
					numberOfInputSamples=round((size(state.phys.daq.output,1)*state.phys.settings.inputRate/state.phys.settings.outputRate)/state.phys.internal.stripes)*state.phys.internal.stripes;
				end
				state.phys.internal.samplesPerStripe=numberOfInputSamples/state.phys.internal.stripes;
			elseif state.cycle.recordingDurationList(state.cycle.currentCyclePosition)==Inf
				numberOfInputSamples=Inf;
				state.phys.internal.samplesPerStripe...
					= round((state.phys.settings.runViewSliceDuration*state.phys.settings.inputRate)/state.phys.internal.stripes);
			else
				numberOfInputSamples=...
					round(...
					(state.cycle.recordingDurationList(state.cycle.currentCyclePosition)*state.phys.settings.inputRate)...
					/state.phys.internal.stripes)*state.phys.internal.stripes;
				state.phys.internal.samplesPerStripe=numberOfInputSamples/state.phys.internal.stripes;
			end
		end
	end
	
	
	set(physInputDevice, 'SamplesPerTrigger', numberOfInputSamples);
	set(physInputDevice, 'SamplesAcquiredFcnCount', state.phys.internal.samplesPerStripe);


    % HANDLE AUX PHYS OUTPUT BOARD -- but only if the imaging board is not
    % doing it
    
    
	if ~state.phys.internal.runningMode
		if state.phys.daq.auxOutputBoardIndex
		   chanNeeded=find(...
				[state.cycle.aux4List(state.cycle.currentCyclePosition) ...
				state.cycle.aux5List(state.cycle.currentCyclePosition) ...
				state.cycle.aux6List(state.cycle.currentCyclePosition) ...
				state.cycle.aux7List(state.cycle.currentCyclePosition)])+3;
			if ~isempty(chanNeeded) && ...
					(state.phys.internal.forceTrigger || ~state.cycle.imageOnList(state.cycle.currentCyclePosition))

				delete(get(physAuxOutputDevice, 'Channel'));

				if ~isempty(chanNeeded)
					chanAdded=addchannel(physAuxOutputDevice, chanNeeded);
					set(chanAdded, 'OutputRange', [-10 10], 'UnitsRange', [-10 10]);

					nPoints=size(state.phys.daq.output,1);
					state.phys.daq.auxOutput=zeros(nPoints, length(chanNeeded));

					counter=1;
					for channel=chanNeeded
						patternNum=eval(['state.cycle.aux' num2str(channel) 'List(state.cycle.currentCyclePosition);']);
						makePulsePattern(patternNum, 0);
						pattern=eval(['state.pulses.pulsePattern' num2str(patternNum)]);
						pSize=size(pattern, 2);
						if nPoints > pSize
							pattern=[pattern repmat(pattern(end), 1, nPoints-pSize)];
						end
						state.phys.daq.auxOutput(1:nPoints, counter)=pattern(1,1:nPoints)';
						counter=counter+1;
					end

					putdata(physAuxOutputDevice, state.phys.daq.auxOutput);
					state.phys.internal.needNewAuxOutputData=0;
				end
			end
		end
	end

	
			
