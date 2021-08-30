function setPcellsToDefault
	global state


	if ~state.pcell.pcellOn
		return
	end
	
	global pcellFocusOutput pcellGrabOutput
	stop([pcellFocusOutput pcellGrabOutput]);
	vec=[];

	for counter=1:state.pcell.numberOfPcells
        pow=getfield(state.pcell, ['pcellDefaultLevel' num2str(counter)]);
        if pow==-1
          pow=getfield(state.pcell, ['pcellScanning' num2str(counter)]);          
        end
		vec(counter)=powerToPcellVoltage(pow, counter);
		vec(counter+state.pcell.numberOfPcells) = 5 * state.shutter.closed;
	end

	if state.acq.createLineClock %201204 && ~(state.acq.dualLaserMode==2) % skip if alternating lasers gy 20101129
		vec(end+1)=0;
		vec(end+1)=0;		
	end
	putsample(pcellFocusOutput, vec);	


			