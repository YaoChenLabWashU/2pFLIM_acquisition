function putCurrentInCyclePos(posNum)
	global state
	if nargin<1
		posNum=state.cycle.displayCyclePosition;
	end

		try
		global state
		persistent guiOrder
		if isempty(guiOrder) || ~iscell(guiOrder)
			guiOrder={'repeats', 'delay', 'frames', 'blaster', 'imageOn', 'physOn', 'tracker', 'avgFrames', 'linescan', 'da0', 'da1', 'aux4', 'aux5', 'aux6', 'aux7'};
		end
		
		state.internal.cycleChanged=1;
		state.cycle.numberOfZSlices=state.acq.numberOfZSlices;
		updateGUIByGlobal('state.cycle.numberOfZSlices');
		state.cycle.numberOfZSlicesList(state.cycle.displayCyclePosition)=state.cycle.numberOfZSlices;
		
		state.cycle.frames=state.acq.numberOfFrames;
		updateGUIByGlobal('state.cycle.frames');
		state.cycle.framesList(state.cycle.displayCyclePosition)=state.cycle.frames;
	
		state.cycle.avgFrames =state.acq.averaging ;
		updateGUIByGlobal('state.cycle.avgFrames ');
		state.cycle.avgFramesList(state.cycle.displayCyclePosition)=state.cycle.avgFrames ;

		state.cycle.zStepSize =state.acq.zStepSize ;
		updateGUIByGlobal('state.cycle.zStepSize ');
		state.cycle.zStepSizeList(state.cycle.displayCyclePosition)=state.cycle.zStepSize ;

		state.cycle.linescan =state.acq.lineScan ;
		updateGUIByGlobal('state.cycle.linescan ');
		state.cycle.linescanList(state.cycle.displayCyclePosition)=state.cycle.linescan ;

		if state.cycle.displayCyclePosition==state.cycle.currentCyclePosition 
			applyAdvancedCyclePosition;
		end
	catch
		disp(lasterr);
	end
