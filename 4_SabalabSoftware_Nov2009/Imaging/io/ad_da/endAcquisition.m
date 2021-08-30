function endAcquisition
	global state imageData projectionData

	% endAcquisition.m*****
	% Function called at the end of the acquistion that will park the laser, close the shutter,
	% write the data to disk, reset the counters (internal), reset the currentMode, and make the 
	% Grab One and Loop buttons visible.
	%
	% Written By: Thomas Pologruto and Bernardo Sabatini
	% Harvard Medical School
	% Cold Spring Harbor Labs
	% 2001-2009
	
	setPcellsToDefault % close shutters and pcells
	
	% Calculate and display any projections
	if ((state.acq.numberOfFrames==1) || state.acq.averaging) && any(state.acq.maxImage)
		if state.internal.keepAllSlicesInMemory % BSMOD 1/18/2
			position = state.internal.zSliceCounter + 1;
		else
			position = 1;
		end

        channelList=find(state.acq.acquiringChannel.*state.acq.maxImage);
        if state.acq.dualLaserMode==2   % lasers go simulataneously therefor one image window per laser
            channelList=[channelList channelList+10];
        end

		for channel = channelList
			inputChannel=mod(channel, 10);
			if state.internal.zSliceCounter==0			% BSMOD2 2/27/2
				projectionData{channel} = imageData{channel}(:,:,position);
			else
				if state.acq.maxMode==0
					projectionData{channel} = max(imageData{channel}(:,:,position), ...
						projectionData{channel});
				else
					projectionData{channel} = ...
						(imageData{channel}(:,:,state.internal.zSliceCounter + 1) + ...
						state.internal.zSliceCounter*projectionData{channel})/(state.internal.zSliceCounter + 1);
					%  BSMOD 1/18/2 eliminated reliance on position for above 2 lines
				end
			end
			% Displays the current Max images on the screen as they are acquired.
			set(state.internal.maximagehandle(channel), 'EraseMode', 'none', 'CData', ...
				projectionData{channel});
		end
		
		drawnow;	
		setStatusString('Saving projections');
		writeMaxData;
	end
	
	state.internal.zSliceCounter = state.internal.zSliceCounter + 1;
	updateGUIByGlobal('state.internal.zSliceCounter');
	
	if state.internal.zSliceCounter >= state.acq.numberOfZSlices
	% Done Acquisition.
		if state.files.autoSave		% BSMOD - Check status of autoSave option
			setStatusString('Saving images');
			writeData;
		end
		
		parkMirrors;
		
		if state.acq.numberOfZSlices > 1
			if state.piezo.usePiezo
				piezoWait;
			else
				mp285FinishMove(1);	% check that movement worked during stack
			end
			executeGoHome;
		end				

		siRedrawImages
		setStatusString('Cleaning up');
		timerRegisterPackageDone('Imaging');	
	else
	% Between Acquisitions or ZSlices
		setStatusString('Next Slice...');
		
		if state.files.autoSave		% BSMOD - Check status of autoSave option
			setStatusString('Saving images');
			writeData;
		end
	
		state.internal.frameCounter = 0;
		updateGUIByGlobal('state.internal.frameCounter');
				
		% if there is slice specific pcell control, remake the pcell output
		if state.pcell.boxSliceSpecific
			makeNewPcellRepeatedOutput;
		end

		setStatusString('Acquiring...');

		if state.piezo.usePiezo
			piezoWait;
		else
			mp285FinishMove(0);	% check that movement worked during stack
		end
		
		timerStart_Imaging;
		global grabInput
		start(grabInput);
		trigger(grabInput);
	end
	

	
	
	