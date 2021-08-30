function setMotorOffsets
global state gh

% setMotorOffsets.m*****
% Function that will upate the Motor offsets, Relative, and Absolute Positions.


currentPos = mp285GetPos;	% Get current Position

% Set the Offsets
state.motor.offsetX = currentPos(1,1);
state.motor.offsetY = currentPos(1,2);
state.motor.offsetZ = currentPos(1,3);

% Set the relative values
state.motor.relXPosition = state.motor.absXPosition - state.motor.offsetX; 
updateGUIByGlobal('state.motor.relXPosition');
state.motor.relYPosition = state.motor.absYPosition - state.motor.offsetY; 
updateGUIByGlobal('state.motor.relYPosition');
state.motor.relZPosition = state.motor.absZPosition - state.motor.offsetZ;
updateGUIByGlobal('state.motor.relZPosition');

% Set the absolute Positions
state.motor.absXPosition = currentPos(1,1);
updateGUIByGlobal('state.motor.absXPosition');
state.motor.absYPosition = currentPos(1,2);
updateGUIByGlobal('state.motor.absYPosition');
state.motor.absZPosition = currentPos(1,3);
updateGUIByGlobal('state.motor.absZPosition');