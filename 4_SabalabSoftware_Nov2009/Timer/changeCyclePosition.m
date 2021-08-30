function changeCyclePosition(pos)
	global state 
	

	
	try
		if nargin==1
			state.cycle.currentCyclePosition=pos;
			updateGUIByGlobal('state.cycle.currentCyclePosition');
		end
		global state
		state.cycle.repeatsDone=0;
		updateGUIByGlobal('state.cycle.repeatsDone');
		if state.cycle.currentCyclePosition>length(state.cycle.delayList)
			state.cycle.currentCyclePosition = length(state.cycle.delayList);
			updateGUIByGlobal('state.cycle.currentCyclePosition');
		end
		applyAdvancedCyclePosition;

		if state.cycle.loopingStatus
			timerCallPackageFunctions('Setup');
		end
		
	catch
		disp(['changeCyclePosition : ' lasterr]);
	end
