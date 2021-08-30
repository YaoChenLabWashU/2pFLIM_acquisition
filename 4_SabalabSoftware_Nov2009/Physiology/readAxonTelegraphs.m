function readTelegraphs

	global state

	try
		start(state.phys.daq.telegraphDevice);
		
		while ~strcmp(get(state.phys.daq.telegraphDevice, 'Running'), 'Off')
			pause(0.01);
		end
		
		telegraphs=mean(getdata(state.phys.daq.telegraphDevice));
		
		pos=1;
		for channel=0:1
			type=getfield(state.phys.settings, ['channelType' num2str(channel)]);
			if type == 2
                gain=state.phys.settings.axonGainList(round(2*telegraphs(pos)));
				eval(['state.phys.settings.inputGain' num2str(channel) '=gain;']);
				updateGUIByGlobal(['state.phys.settings.inputGain' num2str(channel)]);
				
              	if round(telegraphs(pos+1))>=4 	% we are in VC mode
					if getfield(state.phys.settings, ['currentClamp' num2str(channel)])	% but we were in CC mode
						setVoltageClamp(channel);
					end
				else		% we are in CC mode
					if ~getfield(state.phys.settings, ['currentClamp' num2str(channel)]) % but we were in VC mode
						setCurrentClamp(channel);
					end
					pos=pos+2;
				end
			end
		end
	catch
		disp('readAxonTelegraph: Telegraph read error');
	end