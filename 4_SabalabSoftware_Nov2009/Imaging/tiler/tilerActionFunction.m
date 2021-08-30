function tilerActionFunction(ai, SamplesAcquired)
	global state gh

	state.tiler.tileCounter=state.tiler.tileCounter+1;

    XCounter=state.tiler.counterLookup(1, state.tiler.tileCounter);
    YCounter=state.tiler.counterLookup(2, state.tiler.tileCounter);
    
    if ai==state.tiler.mirrorInputObj
		inputData = getdata(ai, state.tiler.mirrorPointsPerPulse)';
        state.tiler.mirrorDataIn(...
            :, ...
            (XCounter - 1 + (YCounter-1)*state.tiler.nTilesX)*state.tiler.mirrorInputPointsPerPulse + 1 : ...
            (XCounter + (YCounter-1)*state.tiler.nTilesX)*state.tiler.mirrorInputPointsPerPulse) = ...
            inputData(:,1:state.tiler.mirrorInputPointsPerPulse);
        prefix='mirror';
	elseif ai==state.tiler.physInputObj
		inputData = getdata(ai, state.tiler.physPointsPerPulse); 
		prefix='phys';
	end

    updateGUIByGlobal('state.tiler.tileCounter');

	for counter=1:size(inputData, 1)
		channelString=num2str(state.tiler.mirrorChannelsOn(counter));
		eval(['global ' prefix 'DataWave' channelString]);
		eval([prefix 'DataWave' channelString ...
				'.data(state.tiler.counterLookup(2, state.tiler.tileCounter), state.tiler.counterLookup(1, state.tiler.tileCounter))' ...
				' = mean(inputData(counter, 1:state.tiler.mirrorInputPointsPerPulse));']);
      	set([prefix 'LastWave' channelString], 'data', inputData(counter, 1:state.tiler.mirrorInputPointsPerPulse));
    end

	
	if state.tiler.tileCounter==state.tiler.nTilesX * state.tiler.nTilesY
	    if ai==state.tiler.mirrorInputObj
			for counter=1:size(state.tiler.mirrorDataIn, 1)
				channelString=num2str(state.tiler.mirrorChannelsOn(counter));
				name=['tilerMirror_' channelString '_' num2str(state.files.fileCounter)];
				waveo(name, state.tiler.mirrorDataIn(counter, :));
				if state.files.autoSave
					eval(['global ' name]);
					save(fullfile(state.files.savePath, name), name);
				end
			end
			state.files.fileCounter=state.files.fileCounter+1;
			updateGUIByGlobal('state.files.fileCounter');
		else
			'phys not implemented'
		end
		set(gh.tilerControls.doitButton, 'String', 'DO IT');
		turnOnAllChildren(gh.tilerControls.figure1);
		setTilerStatusString('Reset');		
	end
	