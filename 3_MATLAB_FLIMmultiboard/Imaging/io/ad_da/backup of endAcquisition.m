function endAcquisition
	global state imageData projectionData
    % MODIFIED gy 2010-2011 for multiFLIM
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
    % GY TODO:  if we processed the imagedata from SPC before now, we could collect max projection on it
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
	% Done Acquisition of the last slice
        % if FLIM is operating, read the data from the board NOW and put it
        % into channel 4 image.  Note that only one frame is acquired
        % ADDED GY 20110125
        global spc lastAcquiredFrame 
        %spc.errCode,
        if timerGetActiveStatus('zFLIM')
            spc_readPageFLIM;
            if spc.errCode
            else
              for fc=1:min(2,numel(spc.projects))  % save up to two channels of data in imaging ch4, ch5
                lastAcquiredFrame{fc+3}=spc.projects{fc}; % TODO temporary fix -
              end
              % in FLIMspeak, the projection is the sum of photons over all lifetime bins
              if state.internal.keepAllSlicesInMemory
                if state.acq.averaging
                    framePosition=state.internal.zSliceCounter + 1;
                else
                    framePosition=(state.internal.frameCounter + state.internal.zSliceCounter*state.acq.numberOfFrames);
                end
              else
                if state.acq.averaging
                	framePosition=1;
                else
                    framePosition = state.internal.frameCounter;
                end
              end
              % temporary fix TODO gy distributing spc 'projection' counts into ordinary image channels
              % looks like if frames are not averaged, we only put the spc counts into the final frame
              for fc=1:min(2,numel(spc.projects))  % save up to two channels of data in imaging ch4, ch5
                imageData{fc+3}(:,:,framePosition)=spc.projects{fc}; % TODO temporary fix -
                state.acq.(['pmtOffsetChannel' num2str(fc+3)])=0;
              end
            end
            updateClim(4);  % TODO gy - right now will not display ch 5, but will save it (writeData)
        end        
        
        %
        
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
                
        % GY: added to enable zFLIM to Process:
        if timerGetActiveStatus('zFLIM')
            timerRegisterPackageDone('zFLIM');
        end
    else  %GY TODO what do we do for ZSlices with FLIM??
	% Between Acquisitions or ZSlices
		% setStatusString('Next Slice...');  GYMOD
        
        % to acquire FLIM slices, we will need to distribute data, store
        % our file (named for the slice!)
        
		
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

		setStatusString('Acquiring next slice...');  % GYMOD

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
	

	
	
	