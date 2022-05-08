function endAcquisition
	global state imageData projectionData spc lastAcquiredFrame FLIMchannels
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

    % GY: if we're doing FLIM, go ahead and read the data, and distribute
    % to the normal channels
    if timerGetActiveStatus('zFLIM')
        spc_readPageFLIM;
        if ~spc.errCode
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
            % distributing spc 'projection' counts into ordinary image channels 
            % according to the selections in FLIMgui
            % looks like if frames are not averaged, we only put the spc counts into the final frame
            % we (optionally) divide by number of frames here, to make it easy to tell
            % when spc board is saturating
            if state.spc.acq.imageChannel1content  % non-zero means we act
                if state.spc.acq.imageChannel1divN
                    divBy=state.acq.numberOfFrames/state.spc.acq.imageScale;  % imageScale is multiplier
                else divBy=1/state.spc.acq.imageScale;  % imageScale is multiplier
                end
                ok=0;
                switch state.spc.acq.imageChannel1content
                    case 1  % image 1 = FLIM channel 1
                        if bitget(state.spc.FLIMchoices(1),2) % only if we're acquiring this channel
                            lastAcquiredFrame{1}=spc.projects{1}/divBy;
                            ok=1;
                        end
                    case 2  % image 1 = FLIM channel 2
                        if bitget(state.spc.FLIMchoices(2),2)
                            lastAcquiredFrame{1}=spc.projects{2}/divBy;
                            ok=1;
                        end
                    case 5  % image 1 = FLIM channels 1 + 2
                        if all(bitget(state.spc.FLIMchoices([1 2]),2))
                            lastAcquiredFrame{1}=(spc.projects{1}+spc.projects{2})/divBy;
                            ok=1;
                        end
                end
                if ok
                    imageData{1}(:,:,framePosition)=lastAcquiredFrame{1};
                    state.acq.pmtOffsetChannel1=0;
                    updateClim(1);
                end
            end
            % now for image channel 2
            if state.spc.acq.imageChannel2content  % non-zero means we act
                if state.spc.acq.imageChannel2divN
                    divBy=state.acq.numberOfFrames/state.spc.acq.imageScale;  % imageScale is multiplier
                else divBy=1/state.spc.acq.imageScale;  % imageScale is multiplier
                end
                ok=0;
                switch state.spc.acq.imageChannel2content
                    case 3  % image 2 = FLIM channel 3
                        if bitget(state.spc.FLIMchoices(1),2) % only if we're acquiring this channel
                            lastAcquiredFrame{2}=spc.projects{1}/divBy;
                            ok=1;
                        end
                    case 4  % image 2 = FLIM channel 4
                        if bitget(state.spc.FLIMchoices(2),2)
                            lastAcquiredFrame{2}=spc.projects{2}/divBy;
                            ok=1;
                        end
                    case 6  % image 1 = FLIM channels 3 + 4
                        if all(bitget(state.spc.FLIMchoices([3 4]),2))
                            lastAcquiredFrame{2}=(spc.projects{1}+spc.projects{2})/divBy;
                            ok=1;
                        end
                end
                if ok
                    imageData{2}(:,:,framePosition)=lastAcquiredFrame{2};
                    state.acq.pmtOffsetChannel2=0;
                    updateClim(2);
                end
            end
            % now for image channel 4
            if state.spc.acq.imageChannel4content  % non-zero means we act
                if state.spc.acq.imageChannel4divN
                    divBy=state.acq.numberOfFrames/state.spc.acq.imageScale;  % imageScale is multiplier
                else divBy=1/state.spc.acq.imageScale;  % imageScale is multiplier
                end
                ok=0;
                switch state.spc.acq.imageChannel4content
                    case 1  % image 1 = FLIM channel 1
                        if bitget(state.spc.FLIMchoices(1),2)
                            lastAcquiredFrame{4}=spc.projects{1}/divBy;
                            ok=1;
                        end
                    case 2  % image 1 = FLIM channel 2
                        if bitget(state.spc.FLIMchoices(2),2)
                            lastAcquiredFrame{4}=spc.projects{2}/divBy;
                            ok=1;
                        end
                    case 3  % image 1 = FLIM channel 3
                        if bitget(state.spc.FLIMchoices(3),2)
                            lastAcquiredFrame{4}=spc.projects{3}/divBy;
                            ok=1;
                        end
                    case 4  % image 1 = FLIM channel 4
                        if bitget(state.spc.FLIMchoices(4),2)
                            lastAcquiredFrame{4}=spc.projects{4}/divBy;
                            ok=1;
                        end
                    case 5 %case 5 added for spc(1)+spc(3) (2 channels of the router); Yao 5/7/2022
                        if bitget(state.spc.FLIMchoices(1),2)|bitget(state.spc.FLIMchoices(3),2)
                            lastAcquiredFrame{4}=(spc.projects{1}+spc.projects{3})/divBy;
                            ok=1;
                        end
                end
                % ALWAYS STORE SOMETHING (otherwise the Imaging package
                % complains that it has nothing to save)
                imageData{4}(:,:,framePosition)=lastAcquiredFrame{4};
                if state.acq.dualLaserMode==2  % FLIMdualLaserMode
                    % MEANINGLESS DATA, but prevents Imaging from complain
                    imageData{14}(:,:,framePosition)=lastAcquiredFrame{4};
                end
                if ok
                    state.acq.pmtOffsetChannel4=0;
                    updateClim(4);
                end
            end
        end
    end
    
    
	% Calculate and display any projections
    % GY: note that spc channels are already collecting max proj over zSlices
    %    (so don't specify them for max'ing)
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
    else  
	% Between Acquisitions or ZSlices
		% setStatusString('Next Slice...');  GYMOD
        
        % already acquired and read the FLIM data (GY)
        		
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
		
        % GY: added to enable zFLIM to Process:
        if timerGetActiveStatus('zFLIM')
            timerStart_zFLIM;  % reinitialize the acquisition for the next slice
        end

		timerStart_Imaging;
        
		global grabInput
		start(grabInput);
		trigger(grabInput);
	end
	

	
	
	