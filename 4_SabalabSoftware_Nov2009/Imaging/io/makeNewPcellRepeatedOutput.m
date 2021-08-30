function makeNewPcellRepeatedOutput
	
	global state pcellGrabOutput
	actualOutputRate = get(pcellGrabOutput, 'SampleRate');

	state.acq.pcellRepeatedOutput = repmat(state.acq.pcellPowerOutput, state.acq.numberOfFrames, 1);

	zeroPower = [powerToPcellVoltage(0, 1) powerToPcellVoltage(0, 2)];
	shutterLead=round(state.internal.lengthOfXData*state.pcell.shutterDelay/(state.acq.msPerLine));

	if state.acq.dualLaserMode==1
		lineFactor=1;		
		lineOffset=0;
	elseif state.acq.dualLaserMode==2;
		lineFactor=2;
		lineOffset=1;
	else
		disp('makeNewPCellRepeatedOutput needs to handle dualLaserMode');
		return
	end

	
	% by default the boxes apply to all slices
	% will be changed below if we find a valid box that is slice specific
	state.pcell.boxSliceSpecific=0;
		
	pcellFractionStart=state.internal.startDataColumnInLine/state.internal.samplesPerLine;

	% loop throug the boxes
	for counter=1:settingsManager('getsetlength', 'pcellBox') 		% loop through each box
		% is the box active?
		if settingsManager('extractval', 'pcellBox', counter, 'state.pcell.boxActiveStatus') 
			sliceNumber=settingsManager('extractval', 'pcellBox', counter, 'state.pcell.boxSliceNumber');	% get the slice #
			frameNumber=settingsManager('extractval', 'pcellBox', counter, 'state.pcell.boxFrameNumber');	% get the frame #

			
			% are there enougth frames and slices in the current acq?
			if (sliceNumber<=state.acq.numberOfZSlices) && ((frameNumber <= state.acq.numberOfFrames) || frameNumber==999)
				x1=settingsManager('extractval', 'pcellBox', counter, 'state.pcell.boxStartX');		% extact the coordinates
				x2=settingsManager('extractval', 'pcellBox', counter, 'state.pcell.boxEndX');
				y1=settingsManager('extractval', 'pcellBox', counter, 'state.pcell.boxStartY');
				y2=settingsManager('extractval', 'pcellBox', counter, 'state.pcell.boxEndY');
				
                if frameNumber==999
                    frameNumbers=1:state.acq.numberOfFrames;
                else
                    frameNumbers=frameNumber;
                end
                
				% is the box fully defined ?
				if x1<1 || x2<1 || y1<1 || y2<1
					disp(['updatePcellOutput: Box #' num2str(counter) ' is not completely defined. Skipping.']);
				else
					startX = round(state.internal.lengthOfXData * (pcellFractionStart + x1 * state.internal.fractionPerPixel));	% calculate the starting pixel
					endX = round(state.internal.lengthOfXData * (pcellFractionStart + x2 * state.internal.fractionPerPixel)); % calculate the endind pixel
					
					% loop through the laser pcells
					for laserChannel=1:2
						powerSetting=settingsManager('extractval', 'pcellBox', counter, ['state.pcell.boxPowerLevel' num2str(laserChannel)]);
						
						% did they actually specify a slice?
						if sliceNumber>0 && powerSetting>=0 && state.acq.numberOfZSlices>1
							% if so, then we have valid, slice specific
							% p-cell control
							state.pcell.boxSliceSpecific=1;
						end

						% is there a specific request for power?  and is
						% it applied to the current slice?
						if powerSetting>=0 && ...
								(sliceNumber==0 || ...
								((state.internal.zSliceCounter+1>=sliceNumber-state.internal.blastSliceRange)...
                                && (state.internal.zSliceCounter+1<=sliceNumber+state.internal.blastSliceRange)))	% otherwise don't alter the power

							% get the voltage level for the power setting
							powerVoltage = powerToPcellVoltage(...		
								powerSetting, ...
								laserChannel);
					%		[counter x1 x2 y1 y2]
							% is there a valid power setting?
							if ~isempty(powerVoltage)
                                for frameNumber=frameNumbers
                                    addLine=(frameNumber-1) * state.acq.linesPerFrame;	% calculate the offset to the first line of the relevant frame
                                    for line = lineFactor*(addLine + y1 : addLine + y2)	- lineOffset*(2-laserChannel)		% loop through the lines of the box
                                        state.acq.pcellRepeatedOutput(...
                                            (line-1) * state.internal.lengthOfXData + (startX : endX), ...	% pixel limits
                                            laserChannel...													% laser channel
                                            ) = powerVoltage;

                                        % open shutter, if necessary
                                        if powerVoltage ~= zeroPower(laserChannel)
                                            state.acq.pcellRepeatedOutput(...
                                                max(...
                                                (line-1) * state.internal.lengthOfXData + startX - shutterLead(laserChannel)...
                                                , 1)...
                                                : (line-1) * state.internal.lengthOfXData + endX, ...
                                                laserChannel+state.pcell.numberOfPcells) = 5 * state.shutter.open;
                                        end								
                                    end
                                end
							end
						end
					end
				end
			end
		end
	end

	if state.blaster.active
		for lineCounter=1:size(state.blaster.allConfigs{state.blaster.currentConfig, 2},1)
			pulseNumber=state.blaster.allConfigs{state.blaster.currentConfig, 2}(lineCounter, 2);
			if pulseNumber
				if state.blaster.widthFromPattern
					width=state.pulses.pulseWidthList(pulseNumber);
				else
					width=state.blaster.allConfigs{state.blaster.currentConfig, 2}(lineCounter, 3);
				end
				
				if state.blaster.powerFromPattern
					power1=0;
					power2=state.pulses.amplitudeList(pulseNumber);	% this is a cludge and this should be set so that each channel is controlled separately
				else
					power1=state.blaster.allConfigs{state.blaster.currentConfig, 2}(lineCounter, 4);
					power2=state.blaster.allConfigs{state.blaster.currentConfig, 2}(lineCounter, 5);
                    try
                        state.pcell.pcellBlasterPower2=state.pcell.pcellPowerCal2(1+round(power2));
                    catch
                        state.pcell.pcellBlasterPower2=-1;
                    end
                    updateHeaderString('state.pcell.pcellBlasterPower2');                    
				end
				
				blastPower = [powerToPcellVoltage(power1, 1) powerToPcellVoltage(power2, 2)];
				try
					for patternCounter=1:max(state.pulses.patternRepeatsList(pulseNumber), 1)
						start=state.pulses.delayList(pulseNumber) + (patternCounter-1)*state.pulses.patternISIList(pulseNumber);
						for counter=1:state.pulses.numPulsesList(pulseNumber)
							startPulse = 1 + round(start * state.acq.outputRate/1000);
							stop = 1 + round((start + width) * state.acq.outputRate/1000);
							
							for pcellCounter=1:state.pcell.numberOfPcells
								% start blanking at the requested prePark
								% time or when the shutter closes,
								% whichever is first
								openShutter = 1 + max(startPulse-shutterLead(pcellCounter), 0);
								startBlank = 1 + max(round((start - state.blaster.prePark) * state.acq.outputRate/1000), 0);								
%								startBlank = min(1 + max(round((start - state.blaster.prePark) * state.acq.outputRate/1000), 0), openShutter);
								state.acq.pcellRepeatedOutput(startBlank : stop, pcellCounter) = zeroPower(pcellCounter); % apply blank to pcell
								state.acq.pcellRepeatedOutput(startPulse : stop, pcellCounter) = blastPower(pcellCounter); % apply pulse to pcell
								if blastPower(pcellCounter) ~= zeroPower(pcellCounter) % do we need to open the shutter?
									state.acq.pcellRepeatedOutput(openShutter : stop, pcellCounter + state.pcell.numberOfPcells) ...
										= 5 * state.shutter.open;	% open shutter for laser
								end			
							end
							
							start=start + state.pulses.isiList(pulseNumber);
						end	
					end
				catch
					disp('*** Error in applyBlasterParking.  Physiology must be loaded to use blaster');
					error(['applyBlasterParking : ' lasterr]);
				end
			end
		end			
	end

	% make sure pcells and shutters are closed at the end of the
	% acquisition
	for counter=1:state.pcell.numberOfPcells
		state.acq.pcellRepeatedOutput(end, counter) = zeroPower(counter);
		state.acq.pcellRepeatedOutput(end, counter + state.pcell.numberOfPcells) = 5 * state.shutter.closed;
	end
	