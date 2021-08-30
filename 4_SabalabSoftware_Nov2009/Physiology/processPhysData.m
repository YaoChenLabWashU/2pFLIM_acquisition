function processPhysData(ai, SamplesAcquired)
	global state physInputDevice

	if state.phys.internal.stopInfiniteAcq
		stop(physInputDevice);
		setPhysStatusString('Proccesing...');
	end
	
	% extract the data
	data=getdata(physInputDevice, state.phys.internal.samplesPerStripe);

	% do the proper scaling

	persistent channelList HWChannelList

	if state.phys.internal.stripeCounter==1
		% record the trigger time
		channelList=get(physInputDevice, 'Channel');
		HWChannelList=get(channelList, 'HwChannel');
		if ~iscell(HWChannelList)
			HWChannelList={HWChannelList};
		end
		
		eventLog=get(physInputDevice, 'EventLog');
		f=find(strcmp({eventLog.Type}, 'Trigger'));
		if isempty(f)
			disp('*** processPhysData: ERROR:  No trigger information returned');
			abortPhysiology;
			return
		end
		state.phys.internal.triggerClock=eventLog(f(1)).Data.AbsTime;
		updateMinInCell(state.phys.internal.triggerClock);

		state.phys.acquisitionFiles=cell(4, length(channelList));
		% this cell structure will save information about the waves of each
		% channel as follows:
		%	state.phys.acquisitionFiles{1, :} will have the AD channel #
		%	state.phys.acquisitionFiles{2, :} will have the name of the
		%		display wave (e.g. dataWave0)
		%	state.phys.acquisitionFiles{3, :} will have the name of the
		%		acquisition wave (e.g. AD0_9)
		%	state.phys.acquisitionFiles{4, :} will have the name of the
		%		average wave (e.g. AD0_e1p1avg)
	end

	% At this point, we got the data and recorded the trigger time.

	% Below, put it in data waves, calculate Rs if appropriate, store headerString,
	% save, average, and, if desired, kill

	startData=state.phys.internal.samplesPerStripe*(state.phys.internal.stripeCounter-1)+1;
	endData=state.phys.internal.samplesPerStripe*state.phys.internal.stripeCounter;

	global physData
	for counter=1:length(channelList)
		channel=HWChannelList{counter};			% what DA #

		physData(counter, startData:endData)=...
			state.phys.internal.channelGains(channel+1)*data(:,counter)';

		if state.phys.internal.stripeCounter==1
			state.phys.acquisitionFiles{1, counter}=channel;
			state.phys.acquisitionFiles{2, counter}=['dataWave' num2str(channel)];
			if ~iswave(['dataWave' num2str(channel)])
				waveo(['dataWave' num2str(channel)], physData(counter), ...
					'xscale', [0 1000/state.phys.settings.inputRate]);
			else
				setWave(['dataWave' num2str(channel)], 'xscale', [0 1000/state.phys.settings.inputRate]);
				eval(['global dataWave' num2str(channel)]);
				eval(['dataWave' num2str(channel) '(startData:endData)=physData(counter, startData:endData);']);
			end

			setfield(['dataWave' num2str(channel)], 'headerString', state.headerString);
		end
 		if (state.phys.internal.stripeCounter==state.phys.internal.stripes)
			setWave(['dataWave' num2str(channel)], 'data', physData(counter,:))
		else
			eval(['global dataWave' num2str(channel)]);
			eval(['dataWave' num2str(channel) '(startData:endData)=physData(counter, startData:endData);']);
		end

		% this adds a small leading blank as the data appears on the screen
		if state.phys.internal.stripeCounter<state.phys.internal.stripes
			eval(['dataWave' num2str(channel) '(endData+1:round(endData+state.phys.internal.samplesPerStripe/2))=NaN;']);
		end
	end

	
	if (state.phys.internal.stripeCounter==state.phys.internal.stripes) || state.phys.internal.stopInfiniteAcq % last one, process everything
		if (get(physInputDevice, 'SamplesPerTrigger')==Inf) && ~state.phys.internal.stopInfiniteAcq
			% we are in the live mode and continuing.  Let's overwrite data
			state.phys.internal.stripeCounter=1;
			return
		end
		
		if (get(physInputDevice, 'SamplesPerTrigger')==Inf) && state.files.autoSave && state.phys.settings.reloadContAcq
			% we were in infinite mode.  We need to reload data from the
			% drive
			phReloadLoggedData(fullfile(state.files.savePath, physDiskLogName));
		end
			
		phEndAcquisitionProcessing
		global physOutputDevice
		while strcmp(get(physOutputDevice, 'Running'), 'On')
			setPhysStatusString('waiting for output');
			pause(0.05);
		end
		timerRegisterPackageDone('Physiology');
	else
		state.phys.internal.stripeCounter=state.phys.internal.stripeCounter+1;
		if (get(physInputDevice, 'SamplesPerTrigger')==Inf)
			setPhysStatusString('Infinite acq');
		end
	end


