function out=mp285ReadAnswer
	out=[];
	global state
	if length(state.motor.serialPortHandle) == 0
		disp(['MP285Talk: MP285 not configured']);
		return;
	end

	time=clock;
	done=0;
	while ~done
		n=get(state.motor.serialPortHandle,'BytesAvailable');
		if  n > 0
			temp=fread(state.motor.serialPortHandle,n); 
			% GY MODIFIED NEXT TWO LINES 20120413
            out=[out; temp];
            % out=[out temp];
			%if temp(end)==13;
			if temp(end)==13 || temp(end)==10
                done=1;
			end
			time=clock;
		end
		if etime(clock,time)>2
			disp('mp285ReadAnswer: Time out: no data in 2 secs');
			done=1;
		end
	end
		
