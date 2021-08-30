function updateRelativeMotorPosition(update)

	if nargin<1
		update=1;
	end
	global state
	state.motor.relXPosition = state.motor.absXPosition - state.motor.offsetX; % Calculate absoluteX Position
	state.motor.relYPosition = state.motor.absYPosition - state.motor.offsetY; % Calculate absoluteY Position
	state.motor.relZPosition = state.motor.absZPosition - state.motor.offsetZ; % Calculate absoluteZ Position
	state.motor.distance=sqrt(state.motor.relXPosition^2+state.motor.relYPosition^2+state.motor.relZPosition^2);
	if update
		updateGUIByGlobal('state.motor.relXPosition');
		updateGUIByGlobal('state.motor.relYPosition');
		updateGUIByGlobal('state.motor.relZPosition');
		updateGUIByGlobal('state.motor.distance');
	end
	
