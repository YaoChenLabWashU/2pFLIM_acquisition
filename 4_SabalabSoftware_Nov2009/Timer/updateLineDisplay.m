function updateLineDisplay
	global state
	if state.analysis.displayLine > size(state.analysis.setup, 1)
		state.analysis.displayLine = size(state.analysis.setup, 1)+1;
		updateGUIByGlobal('state.analysis.displayLine');
		state.analysis.setup(state.analysis.displayLine, :)={1 0 1 1 0 0 [1 0 0] {}};
	end
	
	state.analysis.channelSelection 	= state.analysis.setup{state.analysis.displayLine, 1};
	state.analysis.pulsePattern		= state.analysis.setup{state.analysis.displayLine, 2};
	state.analysis.roiSelection		= state.analysis.setup{state.analysis.displayLine, 3};
	state.analysis.baselineMode		= state.analysis.setup{state.analysis.displayLine, 4};
	state.analysis.baselineStart		= state.analysis.setup{state.analysis.displayLine, 5};
	state.analysis.baselineEnd			= state.analysis.setup{state.analysis.displayLine, 6};
	updateGUIByGlobal('state.analysis.channelSelection');
	updateGUIByGlobal('state.analysis.pulsePattern');
	updateGUIByGlobal('state.analysis.roiSelection');
	updateGUIByGlobal('state.analysis.baselineMode');
	updateGUIByGlobal('state.analysis.baselineStart');
	updateGUIByGlobal('state.analysis.baselineEnd');
	state.analysis.displayPeak=1;
	updateGUIByGlobal('state.analysis.displayPeak')
	updatePeakDisplay;
	
