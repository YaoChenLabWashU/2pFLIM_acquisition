function out=mp285SetVelocity(vel, res)

	out=1;
	if nargin==0
		vel=80;
		res=0;
	elseif nargin==1
		res=0;
	elseif nargin>2
		disp('mp285SetVelocity: Expect only upto 2 arguments.');
		return
	end
	
	global state
	if state.motor.motorOn==0
		return
	end

	if length(state.motor.serialPortHandle) == 0
		disp(['mp285SetVelocity: mp285 not configured']);
		state.motor.lastPositionRead=[];
		return;
	end

	state.motor.velocity=vel;
	if res==1
		vel=bitor(2^15,vel);
	end
	
	% flush all the junk out
	mp285Flush;
	fwrite(state.motor.serialPortHandle, 'V');
	fwrite(state.motor.serialPortHandle, vel, 'uint16');
	fwrite(state.motor.serialPortHandle, 13);
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
	