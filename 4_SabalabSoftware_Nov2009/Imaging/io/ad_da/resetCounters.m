function resetCounters
global state

% Function that resets the counters for a new acquisition at the end of acquisitions or ABORT.

	state.internal.frameCounter=0;
	updateGUIByGlobal('state.internal.frameCounter');
	state.internal.stripeCounter=0;
	
	state.internal.zSliceCounter=0;
	updateGUIByGlobal('state.internal.zSliceCounter');

	if state.pcell.boxSliceSpecific
		state.internal.needNewPcellRepeatedOutput=1;
	end

