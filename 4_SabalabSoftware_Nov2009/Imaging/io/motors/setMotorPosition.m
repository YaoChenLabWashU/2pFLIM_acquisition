function setMotorPosition(newPos)
global state

% setMotorPosition.m****
% Function that updates the mp285 motor position with the global state.motor.absXPosition
%
% Written By: Thomas Pologruto
% Modified: Bernardo Sabatini 1/12/1 - combined set[X,Y,Z]MotorPosition functions into this one
% Cold Spring Harbor Labs
% January 5, 2001

	if nargin<1
		newPos(1,1) = state.motor.absXPosition;		% Set X Position to new value
		newPos(1,2) = state.motor.absYPosition;		% Set X Position to new value
		newPos(1,3) = state.motor.absZPosition;		% Set X Position to new value
	elseif size(newPos) ~= 3
		newPos(1,1) = state.motor.absXPosition;		% Set X Position to new value
		newPos(1,2) = state.motor.absYPosition;		% Set X Position to new value
		newPos(1,3) = state.motor.absZPosition;		% Set X Position to new value
	end		


	setStatusString('Moving stage...');
	mp285SetPos(newPos);
	
	state.motor.absXPosition=newPos(1,1);
	state.motor.absYPosition=newPos(1,2);
	state.motor.absZPosition=newPos(1,3);
	updateHeaderString('state.motor.absXPosition');
	updateHeaderString('state.motor.absYPosition');
	updateHeaderString('state.motor.absZPosition');

	setStatusString('Move done');
	
