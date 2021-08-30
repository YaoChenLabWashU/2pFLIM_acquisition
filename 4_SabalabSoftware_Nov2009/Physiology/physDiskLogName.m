function out=physDiskLogName(counter)
	global state
	
	if nargin<1
		counter=state.files.lastAcquisition;
	end
		
	if isnumeric(counter)
		counter=num2str(counter);
	end
	out=['ContAcqLog_' counter '.daq'];
