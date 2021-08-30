function changeBoxNumber
	global state
	
	if ishandle(state.pcell.currentBoxHandle) & state.pcell.currentBoxHandle~=0
		set(state.pcell.currentBoxHandle, 'Color', [1 0 0]);
		drawnow;
	end
	state.pcell.currentBoxHandle=-1;

	if state.pcell.currentBoxNumber>length(state.pcell.boxListStartX)
		newBox;
	else
		recallBoxSettings(state.pcell.currentBoxNumber);
	end
	