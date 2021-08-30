function gotoPosition(pos)
	global state
	if nargin<1
		pos=state.motor.position;
    end
    
    if size(state.motor.positionVectors,1)<pos
		setStatusString(['Position #' num2str(pos) ' not defined']);
		disp(['gotoPosition: ERROR position #' num2str(pos) ' not defined.  Returning.']);
		return
	end

	if sum(isnan(state.motor.positionVectors(pos,:)))>0
		setStatusString(['Position #' num2str(pos) ' not defined.']);
		disp(['gotoPosition: ERROR position #' num2str(pos) ' not defined (Contains NAN).  Returning.']);
		return
	end

	if abs(state.motor.positionVectors(pos,1)-state.motor.offsetX)>state.motor.maxXYMove ...
			|| abs(state.motor.positionVectors(pos,2)-state.motor.offsetY)>state.motor.maxXYMove ...
			|| abs(state.motor.positionVectors(pos,3)-state.motor.offsetZ)>state.motor.maxZMove
		setStatusString(['Position #' num2str(pos) ' too far.']);
		disp(['gotoPosition: ERROR position #' num2str(pos) ' is too far from origin.  Returning.']);
		disp(['gotoPosition: If you really want this position, reset origin or change limits in .ini file']);
		return
	end
	
	setStatusString(['Moving to position #' num2str(pos)]);
	mp285SetVelocity(state.motor.velocityFast);
	state.motor.absXPosition=state.motor.positionVectors(pos,1);
	state.motor.absYPosition=state.motor.positionVectors(pos,2);
	state.motor.absZPosition=state.motor.positionVectors(pos,3);
	setMotorPosition;
	updateRelativeMotorPosition;
	mp285SetVelocity(state.motor.velocitySlow);
	disp(['*** Staged moved to position #' num2str(pos) ' ***']);
	setStatusString('');