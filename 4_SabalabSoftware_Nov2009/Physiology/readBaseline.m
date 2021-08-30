function readBaseline
	global state

	start(state.phys.daq.baselineDevice);
	
	while ~strcmp(get(state.phys.daq.baselineDevice, 'Running'), 'Off')
		pause(0.01);
	end
	
	baseline=mean(getdata(state.phys.daq.baselineDevice));
	
	pos=0;
	for counter=0:1
		type=getfield(state.phys.settings, ['channelType' num2str(counter)]);
		if type > 1
			scounter=num2str(counter);
			if eval(['state.phys.settings.currentClamp' scounter]);
				eval(['state.phys.cellParams.vm' scounter '=round(10*baseline(1+pos*2)*state.phys.settings.mVPerVIn' scounter ...
						'/state.phys.settings.inputGain' scounter ')/10;']);
% 				eval(['state.phys.cellParams.im' scounter '=round(10*baseline(2+pos*2)*state.phys.settings.pAPerVIn' scounter ')/125;']); %kludge fitz
				eval(['state.phys.cellParams.im' scounter '=round(10*baseline(2+pos*2)*state.phys.settings.pAPerVIn' scounter ')/10;']);                
			else
				eval(['state.phys.cellParams.im' scounter '=round(10*baseline(1+pos*2)*state.phys.settings.pAPerVIn' scounter ...
						'/state.phys.settings.inputGain' scounter ')/10;']);
				eval(['state.phys.cellParams.vm' scounter '=round(10*baseline(2+pos*2)*state.phys.settings.mVPerVIn' scounter ')/10;']);
			end
			pos=pos+1;
			updateGUIByGlobal(['state.phys.cellParams.vm' scounter]);
			updateGUIByGlobal(['state.phys.cellParams.im' scounter]);
		end
	end
	

	