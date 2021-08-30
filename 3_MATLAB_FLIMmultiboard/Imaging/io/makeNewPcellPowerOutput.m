function makeNewPcellPowerOutput
	global state
	
%	state.internal.lineDelay = state.acq.lineDelay/state.acq.msPerLine; % calculate fractional line delay
	
	if state.acq.bidi
		pStart =  1+round(state.internal.lengthOfXData * ...
			((1-state.acq.fillFraction)/2+...
			(state.acq.lineDelay/2+state.acq.mirrorLag-state.pcell.pcellDelay)/state.acq.msPerLine));
		pEnd =  1+round(state.internal.lengthOfXData * ...
			((1-state.acq.fillFraction)/2++state.acq.fillFraction+...
			(state.acq.lineDelay/2+state.acq.mirrorLag-state.pcell.pcellDelay)/state.acq.msPerLine));
	else
		pStart = round(state.internal.lengthOfXData * ...
			(state.acq.lineDelay+state.acq.mirrorLag-state.pcell.pcellDelay)/state.acq.msPerLine);
		pEnd =  round(state.internal.lengthOfXData * ...
			((state.acq.lineDelay+state.acq.mirrorLag-state.pcell.pcellDelay)/state.acq.msPerLine+state.acq.fillFraction));
	end
	
	if state.acq.dualLaserMode==1	% both lasers on at the same time
		state.acq.pcellPowerOutput=zeros(state.internal.lengthOfXData*state.acq.linesPerFrame, 2*state.pcell.numberOfPcells);
	elseif state.acq.dualLaserMode==2
		state.acq.pcellPowerOutput=zeros(2*state.internal.lengthOfXData*state.acq.linesPerFrame, 2*state.pcell.numberOfPcells);
	end
	
	for pcellCounter=1:state.pcell.numberOfPcells
		% the power while imaging
		scanningPowerRaw=getfield(state.pcell, ['pcellScanning' num2str(pcellCounter)]);
		if state.blaster.active && state.blaster.blankImaging
			scanningPower=powerToPcellVoltage(0, pcellCounter);
		else
			scanningPower=powerToPcellVoltage(scanningPowerRaw, pcellCounter);			
		end

		% the power while flying back
		flybackPowerRaw = getfield(state.pcell, ['pcellFlyBack' num2str(pcellCounter)]);		
		if flybackPowerRaw==-1
			flybackPower=scanningPower;
		else
			flybackPower=powerToPcellVoltage(flybackPowerRaw, pcellCounter);
		end
		
		% Fill with the flyback
		pOut = flybackPower*ones(state.internal.lengthOfXData, 1);	
		% Fill scanning portion
		pOut(max(pStart,1):min(pEnd,state.internal.lengthOfXData))=scanningPower;	
		
		if state.acq.dualLaserMode==1	% both lasers on at the same time
			if state.acq.bidi %bidirectional scan so flip alternate lines
				state.acq.pcellPowerOutput(:, pcellCounter)  = repmat(pOut, [state.acq.linesPerFrame 1]); 
				%state.acq.pcellPowerOutput(:, pcellCounter) = repmat([pOut; flipdim(pOut, 1)], [state.acq.linesPerFrame/2 1]);
			else % unidirectional scan 
				state.acq.pcellPowerOutput(:, pcellCounter)  = repmat(pOut, [state.acq.linesPerFrame 1]); 
			end
		elseif state.acq.dualLaserMode==2 % alternate each laser in each scan
			dualPowerRaw = getfield(state.pcell, ['pcellDualLevel' num2str(pcellCounter)]);
			if dualPowerRaw==-1
				dualPower=scanningPower;
			else
				dualPower=powerToPcellVoltage(dualPowerRaw, pcellCounter);
			end
			pOutDual=flybackPower*ones(state.internal.lengthOfXData, 1);	
			pOutDual(max(pStart,1):min(pEnd,state.internal.lengthOfXData))=dualPower;	
			
			if state.acq.bidi	
				if mod(pcellCounter, 2)==1		 
					state.acq.pcellPowerOutput(:, pcellCounter) = repmat([pOut; flipdim(pOutDual, 1)], [state.acq.linesPerFrame 1]);
				else
					state.acq.pcellPowerOutput(:, pcellCounter) = repmat([pOutDual; flipdim(pOut, 1)], [state.acq.linesPerFrame 1]);
				end
			else
				if mod(pcellCounter, 2)==1		 
					state.acq.pcellPowerOutput(:, pcellCounter) = repmat([pOut; pOutDual], [state.acq.linesPerFrame 1]);
				else
					state.acq.pcellPowerOutput(:, pcellCounter) = repmat([pOutDual; pOut], [state.acq.linesPerFrame 1]);
				end
			end
		end

		if (scanningPowerRaw>0) || ((state.acq.dualLaserMode==2) && (dualPowerRaw>0))
			state.acq.pcellPowerOutput(:, pcellCounter + state.pcell.numberOfPcells) = 5 * state.shutter.open;
		else
			state.acq.pcellPowerOutput(:, pcellCounter + state.pcell.numberOfPcells) = 5 * state.shutter.closed;
		end				
    end
    
    % GY - prepare a line/frame clock for SPC/FLIM
	if state.acq.createLineClock 
		pOut = 5*ones(state.internal.lengthOfXData, 1);	
		% Fill scanning portion
        pOut(max(pStart,1):min(pEnd,state.internal.lengthOfXData))=0;
        % gy modified for dualLaserMode 201204
        if state.acq.dualLaserMode==1
            % first the line clock
            state.acq.pcellPowerOutput(:, end+1)  = repmat(pOut, [state.acq.linesPerFrame 1]); 	
            % now the frame clock
            pOut = zeros(state.internal.lengthOfXData, 1);	
            state.acq.pcellPowerOutput(:, end+1)  = repmat(pOut, [state.acq.linesPerFrame 1]); 	
            state.acq.pcellPowerOutput(1:max(pStart-1,1), end)=5;
        elseif state.acq.dualLaserMode==2 % alternate each laser in each scan
            if state.spc.internal.dualLaserModeFLIMAcquire
                % if true, acquire both channels on FLIM board
                % first the line clock
                state.acq.pcellPowerOutput(:, end+1)  = repmat(pOut, [2*state.acq.linesPerFrame 1]);
                % now the frame clock
                pOut = zeros(state.internal.lengthOfXData, 1);
                state.acq.pcellPowerOutput(:, end+1)  = repmat(pOut, [2*state.acq.linesPerFrame 1]);
                state.acq.pcellPowerOutput(1:max(pStart-1,1), end)=5;
            else % state.spc.internal.dualLaserModeFLIMAcquire is false
                % only enable FLIM acquisition during the first laser (odd-numbered) lines
                % first the line clock
                pNull = 5*ones(state.internal.lengthOfXData, 1); % dummy line with NO acquisition
                % repeat a doubled line:  first the regular line, then the dummy line
                state.acq.pcellPowerOutput(:, end+1)  = repmat([pOut;pNull], [state.acq.linesPerFrame 1]);
                % now the frame clock
                pOut = zeros(state.internal.lengthOfXData, 1);
                state.acq.pcellPowerOutput(:, end+1)  = repmat(pOut, [2*state.acq.linesPerFrame 1]);
                state.acq.pcellPowerOutput(1:max(pStart-1,1), end)=5;
            end
        end
	end		
		

		