function storeBoxSettings
	global state
	
	state.pcell.boxListStartX(state.pcell.currentBoxNumber)=state.pcell.currentStartX;
	state.pcell.boxListStartY(state.pcell.currentBoxNumber)=state.pcell.currentStartY;
	state.pcell.boxListEndX(state.pcell.currentBoxNumber)=state.pcell.currentEndX;
	state.pcell.boxListEndY(state.pcell.currentBoxNumber)=state.pcell.currentEndY;
	state.pcell.boxListActive(state.pcell.currentBoxNumber)=state.pcell.currentActiveStatus;
	state.pcell.boxListHandles(state.pcell.currentBoxNumber)=state.pcell.currentBoxHandle;
	state.pcell.boxListPowerLevel(state.pcell.currentBoxNumber)=state.pcell.currentPowerLevel;
	state.pcell.boxListBoxChannel(state.pcell.currentBoxNumber)=state.pcell.currentBoxChannel;
	state.pcell.boxListFrameNumber(state.pcell.currentBoxNumber)=state.pcell.currentFrameNumber;

	
