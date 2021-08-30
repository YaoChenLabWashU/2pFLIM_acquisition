function moveToRelativePosition(h)
% updateRelPos.m*****
% Function that is the call back for the GUis associated with these values.
% When they are changed on the screen, the folowing happen:
% 1) GenericCallback updates the global state.motor.relXPosition to new desired value.
	% N.B. This is done prior to this execution.
% 3) The absolute coordinate is defined, saved as state.motor.absXPosition, and updated.
% 2) The motor position is updated by setXMotorPosition to this value.

	global state gh
	state.motor.absXPosition = state.motor.relXPosition + state.motor.offsetX; % Calculate absoluteX Position
	state.motor.absYPosition = state.motor.relYPosition + state.motor.offsetY; % Calculate absoluteX Position
	state.motor.absZPosition = state.motor.relZPosition + state.motor.offsetZ; % Calculate absoluteX Position
	mp285SetVelocity(state.motor.velocityFast);
	setMotorPosition;	% Sets X Motor Position to state.motor.absXPosition
	mp285SetVelocity(state.motor.velocitySlow);
