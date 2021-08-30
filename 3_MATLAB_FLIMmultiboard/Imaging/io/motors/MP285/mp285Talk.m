function out=mp285Talk(in, verbose)
	out=[];
	global state
	if state.motor.motorOn==0
		disp('mp285Talk: state.motor.motorOn is set to off.');
		return
	end

	if nargin < 1
 	    disp(['mp285Talk: expect string argument to send to mp285 via serial port']);
		return	
	end 

	if length(state.motor.serialPortHandle) == 0
		disp(['mp285Talk: mp285 not configured']);
		return;
	end
 
	if nargin < 2
		verbose=0;
	end 

	n=get(state.motor.serialPortHandle,'BytesAvailable');
	if n > 0
		temp=fread(state.motor.serialPortHandle,n); 
		if verbose
			temp=char(reshape(temp,1,length(temp)));
			disp(['mp285Talk: [' num2str(double(temp)) '] = ' temp(1:end-1) ...
					' flushed from mp285 serial port buffer']);
		end
	end

	fwrite(state.motor.serialPortHandle, [in 13]);
	if verbose 
		disp(['mp285Talk: [' num2str(double(in)) ' CR] sent to mp285. ']);	
    end
    
    % gy: instead of mp285ReadAnswer
	[textln,~,msg]= fgetl(state.motor.serialPortHandle); % should return no terminator
	if ~isempty(msg)		% check if CR was returned
		disp(['mp285SetVelocity: ' msg]); 
		out=1;
		return;
	elseif length(textln)>0 % | out(1)~=13 % not sure if this shd be 1 or 0
		disp(['mp285SetVelocity: mp285 returned an error:' num2str(textln)]);
		out=1;
		return
	end
		
	out=0;
	
% 	temp=mp285ReadAnswer;
% 	temp=reshape(temp,1,length(temp));
% 	if length(temp)==0
% 		disp('mp285Talk: mp285 Timed out without returning anything');
% 	else
% 		if length(temp)>1 | temp(1)~=13
% 			disp(['mp285Talk: mp285 did not return 13']);
% 		end
% 		if verbose
% 			disp(['mp285Talk: mp285 returned [' num2str(double(temp)) '] = ' char(temp(1:end-1))]);
% 		end
% 	end
% 	out=temp;
		
