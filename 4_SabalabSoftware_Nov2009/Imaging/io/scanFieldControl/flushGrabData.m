function flushGrabData
	global state
	global grabOutput pcellGrabOutput

	try
		deviceList=[];
		stop(grabOutput)
		
		if state.pcell.pcellOn
			stop(pcellGrabOutput);
		end
		
		if state.pcell.pcellOn
			if get(pcellGrabOutput, 'SamplesAvailable')>0
				deviceList=pcellGrabOutput;
			end
		end
		
		if get(grabOutput, 'SamplesAvailable')>0
			if isempty(deviceList)
				deviceList=grabOutput;
			else
				deviceList(end+1)=grabOutput;
			end
		end
		
		if ~isempty(deviceList)
			'secondary in grab flushGrabData'
			start(deviceList);
			stop(deviceList);
	
			while ~any(strcmp(get(deviceList, 'Running'), repmat('Off', length(deviceList), 1)))
				pause(.01);
			end
		end
	catch
		disp(['flushGrabData: ' lasterr]);
	end
