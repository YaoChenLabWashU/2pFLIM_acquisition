function distance
	global state
	
	updateMotorPosition;
	state.motor.distance=sqrt(state.motor.relXPosition^2+state.motor.relYPosition^2+state.motor.relZPosition^2);
	updateGUIByGlobal('state.motor.distance');
	