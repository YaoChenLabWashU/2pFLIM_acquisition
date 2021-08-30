function gotoZero
	global state
		
	setStatusString('Moving to (0,0,0)');
	mp285SetVelocity(state.motor.velocityFast);
	state.motor.absXPosition=state.motor.offsetX;
	state.motor.absYPosition=state.motor.offsetY;
	state.motor.absZPosition=state.motor.offsetZ;
	setMotorPosition;
	updateRelativeMotorPosition;
	mp285SetVelocity(state.motor.velocitySlow);
	disp(['*** Staged moved to relative (0,0,0) ***']);
	setStatusString('');
		