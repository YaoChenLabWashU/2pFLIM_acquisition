function recallBoxSettings(boxNum)
	global state
	
	if nargin<1
		boxNum=state.pcell.currentBoxNumber;
	end
	
	state.pcell.currentStartX=state.pcell.boxListStartX(boxNum);
	state.pcell.currentStartY=state.pcell.boxListStartY(boxNum);
	state.pcell.currentEndX=state.pcell.boxListEndX(boxNum);
	state.pcell.currentEndY=state.pcell.boxListEndY(boxNum);
	state.pcell.currentActiveStatus=state.pcell.boxListActive(boxNum);
	state.pcell.currentBoxHandle=state.pcell.boxListHandles(boxNum);
	state.pcell.currentPowerLevel=state.pcell.boxListPowerLevel(state.pcell.currentBoxNumber);
	state.pcell.currentBoxChannel=state.pcell.boxListBoxChannel(state.pcell.currentBoxNumber);
	state.pcell.currentFrameNumber=state.pcell.boxListFrameNumber(state.pcell.currentBoxNumber);

% 	updateGUIByGlobal('state.pcell.currentStartX');
% 	updateGUIByGlobal('state.pcell.currentStartY');
% 	updateGUIByGlobal('state.pcell.currentEndX');
% 	updateGUIByGlobal('state.pcell.currentEndY');
	updateGUIByGlobal('state.pcell.currentActiveStatus');
	updateGUIByGlobal('state.pcell.currentPowerLevel');
	updateGUIByGlobal('state.pcell.currentBoxChannel');
	updateGUIByGlobal('state.pcell.currentFrameNumber');

	if ishandle(state.pcell.currentBoxHandle) & state.pcell.currentBoxHandle~=0
		set(state.pcell.currentBoxHandle,'Color',[0 0 1]);
		drawnow;
	end

	
