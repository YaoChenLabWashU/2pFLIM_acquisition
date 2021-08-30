function applyShift(position)
	global state
	
	if isempty(state.motor.positionVectors)
		disp('applyShift: No positions defined');
		return
	end
	
	n=size(state.motor.positionVectors);
	n=n(1);
	if position>n
		disp(['applyShift: Position ' num2str(position) ' not defined.']);
		return
	end
	
	flag=updateMotorPosition;
	if isempty(flag)
		disp('applyShiftXY : Unable to shift XY.  MP285 Error');
		beep;
	else
		sh=state.motor.lastPositionRead-state.motor.positionVectors(position, :);
		for i=1:n
			state.motor.positionVectors(i,:)=state.motor.positionVectors(i,:)+sh;
		end
	end
	