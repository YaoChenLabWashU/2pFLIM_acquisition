function temp=mp285Flush
temp=[];
try
	global state
	state.motor.positionPending=0;
	state.motor.movePending=0;
	
	if state.motor.motorOn==0
		return
	end

  
	if length(state.motor.serialPortHandle) == 0
		disp(['MP285Talk: MP285 not configured']);
		return;
	end
	n=get(state.motor.serialPortHandle,'BytesAvailable');
	if  n > 0
		temp=fread(state.motor.serialPortHandle,n); 
	end
catch
end
