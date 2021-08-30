function undoMotorAction
	global state

	% state.motor.lastAction : 0, 1==define, 2==shiftXY, 3=shiftXYZ
	% state.motor.oldParams={lastStagePositionNumber, values}
	%		values	= last XYZ coords, if lastAction=1
	%				= XY shift, if lastAction=2
	%				= XYZ shift, if lastAction=3
    
    switch state.motor.lastAction
        case 0
            disp('undoMotorAction: undo not possible. No action taken');
          
        case 1
            pos=state.motor.oldParams{1};
            coords=state.motor.oldParams{2};

            if isempty(coords)
                disp('position was not previously deinfed. Cannot undo');
            else
                state.motor.positionVectors(pos,:)=coords;
            end
            
        case 2
            
        case 3
            
            
        otherwise
            disp('undoMotorAction: unknown action to undo');
    end
    
    state.motor.lastAction=0;


	
	