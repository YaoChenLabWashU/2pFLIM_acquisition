function startMoveStackFocus
global state

% decrementZPosition.m*****
% function that will decrement the Z position by state.motor.zStepSize and update the abs and relative
% positions.
%
% Written By: Thomas Pologruto
% Cold Spring Harbor Labs
% January 5, 2001


%	updateMotorPosition(0);		% Update Motor Position

	% BSMOD2 added below to handle peizo stack focusing
if state.piezo.usePiezo
	state.piezo.next_pos = state.piezo.next_pos + state.acq.zStepSize;
	oldStatus=state.internal.statusString;
	setStatusString('Moving stage...');
	piezoUpdatePosition;
	setStatusString(oldStatus);
else
	state.motor.absZPosition = state.motor.absZPosition + state.acq.zStepSize; % Calcualte New value
	state.motor.relZPosition = state.motor.absZPosition - state.motor.offsetZ; % Calculate relativveZ Position
	updateGUIByGlobal('state.motor.relZPosition');
	state.motor.distance=sqrt(state.motor.relXPosition^2+state.motor.relYPosition^2+state.motor.relZPosition^2);
	updateGUIByGlobal('state.motor.distance');

	newPos(1,1) = state.motor.absXPosition;		% Set X Position to new value
	newPos(1,2) = state.motor.absYPosition;		% Set X Position to new value
	newPos(1,3) = state.motor.absZPosition;		% Set X Position to new value

	oldStatus=state.internal.statusString;
	setStatusString('Moving stage...');
	mp285StartMove(newPos);
	setStatusString(oldStatus);
end