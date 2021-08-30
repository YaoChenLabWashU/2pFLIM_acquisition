function tilerSetupForStart
	global state
	
	if get(state.tiler.mirrorOutputObj, 'SamplesAvailable') > 0
		try
			start(state.tiler.mirrorOutputObj);
			stop(state.tiler.mirrorOutputObj);
		
			while ~strcmp(get(state.tiler.mirrorOutputObj, 'Running'), 'Off') 
				pause(.001);
			end
		catch
			disp(['makeTilerOutput: Error in flushing mirrorOutputObj: ' lasterr]);
		end
	end
	
	if get(state.tiler.pcellOutputObj, 'SamplesAvailable') > 0
		try
			start(state.tiler.pcellOutputObj);
			stop(state.tiler.pcellOutputObj);
		
			while ~strcmp(get(state.tiler.pcellOutputObj, 'Running'), 'Off')
				pause(.001);
			end
		catch
			disp(['makeTilerOutput: Error in flushing pcellOutputObj : ' lasterr]);
		end
	end

	state.tiler.mirrorChannelsOn=[];
	for counter=0:3
		if getfield(state.tiler, ['mirrorAcq' num2str(counter)])
			state.tiler.mirrorChannelsOn(end+1)=counter;
			set(['mirrorDataWave' num2str(counter)], 'data', zeros(state.tiler.nTilesY, state.tiler.nTilesX));
		end
	end
	
	for counter=0:7
		if getfield(state.tiler, ['physAcq' num2str(counter)])
			set(['physDataWave' num2str(counter)], 'data', zeros(state.tiler.nTilesY, state.tiler.nTilesX));
		end
	end
	
    state.tiler.mirrorDataIn = zeros(length(state.tiler.mirrorChannelsOn), state.tiler.mirrorInputPointsPerPulse);
    
	flushData(state.tiler.mirrorInputObj);
	flushData(state.tiler.physInputObj);
	
	putdata(state.tiler.mirrorOutputObj, state.tiler.mirrorOutput);
	putdata(state.tiler.pcellOutputObj, state.tiler.pcellOutput);
	
	drawnow