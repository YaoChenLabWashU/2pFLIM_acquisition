function flushFocusData
	global state
	global focusOutput pcellFocusOutput
	
	try
		stop(focusOutput)
		if state.pcell.pcellOn
			stop(pcellFocusOutput)
		end

		deviceList=[];
		if state.pcell.pcellOn
			if get(pcellFocusOutput, 'SamplesAvailable')>0
				deviceList=pcellFocusOutput;
			end
		end
		if get(focusOutput, 'SamplesAvailable')>0
			if isempty(deviceList)
				deviceList=focusOutput;
			else
				deviceList(end+1)=focusOutput;
			end
		end
		
		if ~isempty(deviceList)
			'secondary in flushFocusData'
			start(deviceList);
			stop(deviceList);
	
			while ~any(strcmp(get(deviceList, 'Running'), repmat('Off', length(deviceList), 1)))
				pause(.001);
			end
		end
	catch
		disp(['flushFocusData: ' lasterr]);
	end

