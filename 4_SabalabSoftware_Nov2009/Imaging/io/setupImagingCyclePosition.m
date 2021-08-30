function setupImagingCyclePosition
	global state
	global gh
	
	redo=0;
	needToAllocate=0;
	
	state.acq.zStepSize = state.cycle.zStepSizeList(state.cycle.currentCyclePosition);
	updateGUIByGlobal('state.acq.zStepSize');
	
	if state.acq.autoTrack ~= state.cycle.trackerList(state.cycle.currentCyclePosition)
		state.acq.autoTrack=state.cycle.trackerList(state.cycle.currentCyclePosition);
		updateGUIByGlobal('state.acq.autoTrack');
	end
		
	if state.cycle.blasterList(state.cycle.currentCyclePosition)>0
		if ~state.blaster.active
			state.blaster.active=1;
			updateGUIByGlobal('state.blaster.active');
			if state.blaster.blankImaging
				state.internal.needNewPcellPowerOutput=1;
			end	
			redo=1;
		end
		if state.blaster.currentConfig ~= state.cycle.blasterList(state.cycle.currentCyclePosition)
			redo=1;
			c=get(gh.blaster.Config, 'Children');
			set(c, 'Checked', 'off');
			f=find(strcmp(get(c, 'Label'), [num2str(state.cycle.blasterList(state.cycle.currentCyclePosition))...
					' ' state.blaster.allConfigs{state.cycle.blasterList(state.cycle.currentCyclePosition),1}]));
			if ~isempty(f)
				set(c(f(1)), 'Checked', 'on');
			end
		end
	elseif state.blaster.active
		state.blaster.active=0;
		updateGUIByGlobal('state.blaster.active');
		if state.blaster.blankImaging
			state.internal.needNewPcellPowerOutput=1;
		end	
		redo=1;
	end
	state.blaster.currentConfig = state.cycle.blasterList(state.cycle.currentCyclePosition);
		
	%% Added by TN Apr 01 2005
	try
		if state.cycle.scanSetupList(state.cycle.currentCyclePosition) ~= 0 
			if state.acq.zoomFactor~=state.cycle.scanSetupList(state.cycle.currentCyclePosition);
				state.acq.zoomFactor=state.cycle.scanSetupList(state.cycle.currentCyclePosition);
				updateGUIByGlobal('state.acq.zoomFactor');
				state.internal.needNewRotatedMirrorOutput=1;
			end
			%	restoreScan(state.cycle.scanSetupList(state.cycle.currentCyclePosition));
		end
	catch
		disp(['ERROR ' lasterr]);
	end
	%% End TN Apr 01 2005
	
	if state.acq.lineScan ~= state.cycle.linescanList(state.cycle.currentCyclePosition)
		state.acq.lineScan = state.cycle.linescanList(state.cycle.currentCyclePosition);
		state.internal.needNewRotatedMirrorOutput=1;
		updateGUIByGlobal('state.acq.lineScan');
		redo=1;
	end
	
	if state.acq.numberOfZSlices ~= state.cycle.numberOfZSlicesList(state.cycle.currentCyclePosition)
		state.acq.numberOfZSlices = state.cycle.numberOfZSlicesList(state.cycle.currentCyclePosition);
		updateGUIByGlobal('state.acq.numberOfZSlices');
		needToAllocate=1;
	end
	
	global grabInput
	if state.acq.numberOfFrames ~= state.cycle.framesList(state.cycle.currentCyclePosition)
		state.acq.numberOfFrames = state.cycle.framesList(state.cycle.currentCyclePosition);
		updateGUIByGlobal('state.acq.numberOfFrames');
		set(grabInput, 'SamplesPerTrigger', state.internal.samplesPerFrame*state.acq.numberOfFrames);
		needToAllocate=1;
		redo=1;
	end
	
	if state.acq.averaging~=state.cycle.avgFramesList(state.cycle.currentCyclePosition)
		state.acq.averaging=state.cycle.avgFramesList(state.cycle.currentCyclePosition);
		updateGUIByGlobal('state.acq.averaging');
		needToAllocate=1;
	end

	if needToAllocate
		preallocateMemory;
	end

	if redo
		state.internal.needNewRepeatedMirrorOutput=1;
		state.internal.needNewPcellRepeatedOutput=1;
	end
	


	
	