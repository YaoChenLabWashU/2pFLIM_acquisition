function definePosition(pos)
	global state
	if (nargin<1)
		pos=state.motor.position;
	end
	
	if length(state.motor.positionVectors)==0
		state.motor.positionVectors=zeros(pos, 3);
	end
	updateMotorPosition;
	if state.motor.position>size(state.motor.positionVectors,1)
		for i=size(state.motor.positionVectors,1)+1:state.motor.position
			state.motor.positionVectors(i,:)=[nan,nan,nan];
		end
	end
	state.motor.positionVectors(pos,:)=[state.motor.absXPosition state.motor.absYPosition state.motor.absZPosition];
	disp(['*** Staged position #' num2str(pos) ' defined as ' num2str(state.motor.positionVectors(pos,1)) ...
			', ' num2str(state.motor.positionVectors(pos,2)) ', ' num2str(state.motor.positionVectors(pos,3)) ' ***']);
    if nargin<1
        state.motor.position=state.motor.position+1;
    	updateGUIByGlobal('state.motor.position');
    end
	
	state.cycle.lastPositionUsed=-1;