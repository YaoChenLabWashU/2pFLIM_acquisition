function updatePcellOutput
	global state 
	
	for pcellCounter=1:state.pcell.numberOfPcells
		if eval(['state.pcell.pcellActive' num2str(pcellCounter)])
			
			pockellData = powerToPcellVoltage(eval(['state.pcell.pcellFlyBack' num2str(pcellCounter)]), pcellCounter)...
				*ones(state.internal.lengthOfXData ,1);					% Data for On Cell
		
			state.internal.lineDelay = state.acq.lineDelay/state.acq.msPerLine; % calculate fractional line delay
			pockelStart = round(state.internal.lengthOfXData * ...
				(state.acq.lineDelay+state.acq.mirrorLag-state.pcell.pcellDelay)/state.acq.msPerLine);
		
			pockellEnd =  round(state.internal.lengthOfXData * ...
				((state.acq.lineDelay+state.acq.mirrorLag-state.pcell.pcellDelay)/state.acq.msPerLine+state.acq.fillFraction));
		
			pockellData(pockelStart:pockellEnd)=powerToPcellVoltage(eval(['state.pcell.pcellScanning' num2str(pcellCounter)]), pcellCounter);
		
			if pcellCounter==1
				pcellOut = repmat(pockellData, [state.acq.linesPerFrame 1]); 						% Final Pockell Data for one frame
			else
				pcellOut(:, pcellCounter) = repmat(pockellData, [state.acq.linesPerFrame 1]); 		% Final Pockell Data for one frame
			end
		else
			pockellData = zeros(state.internal.lengthOfXData ,1);					% Data for On Cell
		
			if pcellCounter==1
				pcellOut = repmat(pockellData, [state.acq.linesPerFrame 1]); 						% Final Pockell Data for one frame
			else
				pcellOut(:, pcellCounter) = repmat(pockellData, [state.acq.linesPerFrame 1]); 		% Final Pockell Data for one frame
			end
		end
	end
	
	if state.pcell.timedShutter		% using a line for shutter control
		pcellOut(:,end+1) = 5 * state.shutter.open*ones(state.internal.lengthOfXData*state.acq.linesPerFrame,1);
		pcellOut(end,end) = 5 * state.shutter.closed;
	end
	
	state.acq.pockellDataOutput = pcellOut; % save data without boxes for focusing
	
	if state.pcell.timedShutter		% using a line for shutter control
		pcellOut(end,end) = 5 * state.shutter.open;
	end

	pcellOut=repmat(pcellOut, state.acq.numberOfFrames, 1);
	
	for counter=1:length(state.pcell.boxListStartX)
		if state.pcell.boxListActive(counter) & eval(['state.pcell.pcellActive' num2str(state.pcell.boxListBoxChannel(counter))])
			if state.pcell.boxListStartX(counter)<1 | ...
					state.pcell.boxListStartY(counter)<1 | ...
					state.pcell.boxListEndX(counter)<1 | ...
					state.pcell.boxListEndY(counter)<1
				disp(['updatePcellOutput: Box #' num2str(counter) ' is not completely defined. Skipping.']);
			else
				startX=round(state.internal.lengthOfXData*(state.internal.fractionStart+state.pcell.boxListStartX(counter)*state.internal.fractionPerPixel));
				endX=round(state.internal.lengthOfXData*(state.internal.fractionStart+state.pcell.boxListEndX(counter)*state.internal.fractionPerPixel));
				
				pow=powerToPcellVoltage(state.pcell.boxListPowerLevel(counter),state.pcell.boxListBoxChannel(counter));
				
				if ~isempty(pow)
					if state.pcell.boxListFrameNumber(counter)<=state.acq.numberOfFrames
						addLine=(state.pcell.boxListFrameNumber(counter)-1)*state.acq.linesPerFrame;
						for line = addLine + state.pcell.boxListStartY(counter) : addLine + state.pcell.boxListEndY(counter)
							pcellOut(...
								(line-1) * state.internal.lengthOfXData+startX : ...
								(line-1) * state.internal.lengthOfXData+endX, state.pcell.boxListBoxChannel(counter)) ...
								= pow;
						end
					end
				end
			end
		end
	end

	if state.pcell.timedShutter	% using a line for shutter control
		pcellOut(end, end) = 5 * state.shutter.closed;
		if state.pcell.shutterDelay > 0	
			pcellOut(1:round(state.pcell.shutterDelay/(state.acq.pixelTime*1000)),end) = ...
				5 * state.shutter.closed * ones(round(state.pcell.shutterDelay/(state.acq.pixelTime*1000)), 1);
		end
	end
	state.acq.pockellDataOutputGrab = pcellOut; % with boxes for grabing
	
	if isfield(state, 'blaster')
		if isfield(state.blaster, 'active')
			if state.blaster.active
				zeroPow1 = powerToPcellVoltage(0, 1);
				zeroPow2 = powerToPcellVoltage(0, 2);
				
				for counter=1:state.acq.numberOfFrames
					startBlankX = state.acq.msPerLine * state.acq.linesPerFrame * counter/1000 - state.blaster.duration/1000;
				
					start = round(startBlankX*state.acq.outputRate);
					stop = round((startBlankX + state.blaster.duration/1000) * state.acq.outputRate);
					state.acq.pockellDataOutputGrab(start : stop, 1) = zeroPow1;
					state.acq.pockellDataOutputGrab(start : stop, 2) = zeroPow2;
					if counter==1
						state.acq.pockellDataOutput(start : stop, 1) = zeroPow1;
						state.acq.pockellDataOutput(start : stop, 2) = zeroPow2;
					end
					stop = round((startBlankX + state.blaster.start/1000 + state.blaster.width/1000) * state.acq.outputRate);
					
					lastStop=start-1;
				
					f=find(counter==state.blaster.frameList);
					if ~isempty(f)
						for blasterCounter=f
							start = round(...
									(startBlankX + ...
									state.blaster.startList(blasterCounter)/1000) ...
									* state.acq.outputRate);
							stop = round(...
									(startBlankX + ...
									state.blaster.startList(blasterCounter)/1000 + ...
									state.blaster.widthList(blasterCounter)/1000) ...
									* state.acq.outputRate);
							state.acq.pockellDataOutputGrab(start : stop, 2) = powerToPcellVoltage(state.blaster.ampList(blasterCounter), 2);
						end
					end
				end
			end
		end
	end
			
