function listPositions
	global state

	for pos=1:size(state.motor.positionVectors,1)
		disp(['*** Staged position #' num2str(pos) ' defined as relative position: (' ...
				num2str(state.motor.positionVectors(pos,1)-state.motor.offsetX) ', ' ...
				num2str(state.motor.positionVectors(pos,2)-state.motor.offsetY) ', ' ...
				num2str(state.motor.positionVectors(pos,3)-state.motor.offsetZ) ') ***']);
	end
	
		