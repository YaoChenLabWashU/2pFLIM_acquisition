function phEndAcquisitionProcessing
	global state

	global physData
	for counter=1:size(state.phys.acquisitionFiles,2)
		channel=state.phys.acquisitionFiles{1,counter};			% what DA #
		if (channel==0) || (channel==1)				% do series resistance processing for 1st 2 channels
			if eval(['state.phys.settings.channelType' num2str(channel)])>1		% if channel is a clamp
				% if channel is in V-clamp and a RS check pulse is selected
				if ~eval(['state.phys.settings.currentClamp' num2str(channel)])	&& state.cycle.VCRCPulse
					% voltage clamp calculation of passive parameters
					[rin, rs, cm, calcRsError]=calcRs(physData(counter,:), ...		% data
						1000/state.phys.settings.inputRate, ...									% dx
						state.pulses.amplitudeList(state.cycle.VCRCPulse), ...		% amp
						state.pulses.delayList(state.cycle.VCRCPulse), ...			% pulse start
						state.pulses.pulseWidthList(state.cycle.VCRCPulse), ...		% pulse width
						max(state.pulses.delayList(state.cycle.VCRCPulse)-50, 1),...	% baseline start
						0.99*state.pulses.delayList(state.cycle.VCRCPulse));		% baseline end
					if calcRsError
						disp('processPhysData: calcRs returned an error');
					end
					eval(['state.phys.cellParams.rm' num2str(channel) '=round(10*rin)/10;']);
					eval(['state.phys.cellParams.rs' num2str(channel) '=round(10*rs)/10;']);
					eval(['state.phys.cellParams.cm' num2str(channel) '=round(10*cm)/10;']);
				elseif eval(['state.phys.settings.currentClamp' num2str(channel)])&& state.cycle.CCRCPulse
					% current clamp check of Rin
					dx=1000/state.phys.settings.inputRate;
                    
					baselineV=mean(physData(counter, ...
						round((state.pulses.delayList(state.cycle.CCRCPulse)-50)/dx) ...
						: ...
						round((state.pulses.delayList(state.cycle.CCRCPulse)-1)/dx)...
						));
					peakV=mean(physData(counter, ...
						round((state.pulses.delayList(state.cycle.CCRCPulse)+0.8*state.pulses.pulseWidthList(state.cycle.CCRCPulse))/dx) ...
						: ...
						round((state.pulses.delayList(state.cycle.CCRCPulse)+state.pulses.pulseWidthList(state.cycle.CCRCPulse))/dx-1)...
						));
					rin=1000*(peakV-baselineV)/state.pulses.amplitudeList(state.cycle.CCRCPulse);
					eval(['state.phys.cellParams.rm' num2str(channel) '=round(10*rin)/10;']);
					eval(['state.phys.cellParams.rs' num2str(channel) '=NaN;']);
					eval(['state.phys.cellParams.cm' num2str(channel) '=NaN;']);
				else
					eval(['state.phys.cellParams.rm' num2str(channel) '=NaN;']);
					eval(['state.phys.cellParams.rs' num2str(channel) '=NaN;']);
					eval(['state.phys.cellParams.cm' num2str(channel) '=NaN;']);
				end

				updateGUIByGlobal(['state.phys.cellParams.rm' num2str(channel)]);
				updateGUIByGlobal(['state.phys.cellParams.rs' num2str(channel)]);
				updateGUIByGlobal(['state.phys.cellParams.cm' num2str(channel)]);
			end
		end

		% store the data in a wave that contains the acq #
		name=physTraceName(channel, state.files.lastAcquisition);
		state.phys.acquisitionFiles{3, counter}=name;

		waveo(name, physData(counter,:), ...
			'xscale', [0 1000/state.phys.settings.inputRate]);
		setfield(name, 'headerString', state.headerString);

		% auto save to disk?

		eval(['global ' name]);
		if state.files.autoSave
			save(fullfile(state.files.savePath, name), name);
		end

		% online averaging?
		if getfield(state.phys.settings, ['avg' num2str(channel)])
			if state.cycle.useCyclePos
				avgName=physAvgName(state.epoch, channel, state.cycle.lastPositionUsed);
			else
				avgName=physAvgName(state.epoch, channel, state.cycle.lastPulseUsed0);
			end

			avgin(name, avgName);
			state.phys.acquisitionFiles{4, counter}=avgName;

			if state.files.autoSave
				eval(['global ' avgName]);
				save(fullfile(state.files.savePath, avgName), avgName);
			end
		end%

	end

	% Make a note in the auto notebook and save it
	addEntryToNotebook(2, ...
		[datestr(clock,13) ' (' num2str(state.phys.cellParams.minInCell0) ' min): Acq # ' num2str(state.files.lastAcquisition) ...
		' CycPos ' num2str(state.cycle.currentCyclePosition) ' Rep ' num2str(state.cycle.repeatsDone) ...
		' Patterns ' num2str(state.cycle.lastPulseUsed0) ', ' num2str(state.cycle.lastPulseUsed1) ]);


