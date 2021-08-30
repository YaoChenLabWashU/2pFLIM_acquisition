function updatePeakDisplay
	global state
	if state.analysis.displayPeak > size(state.analysis.setup{state.analysis.displayLine, 7}, 1)
		state.analysis.setup{state.analysis.displayLine, 7}(end+1, :)=[1 0 0];
		state.analysis.displayPeak = size(state.analysis.setup{state.analysis.displayLine, 7}, 1);
		updateGUIByGlobal('state.analysis.displayPeak')
	end
	state.analysis.peakMode	= state.analysis.setup{state.analysis.displayLine, 7}(state.analysis.displayPeak, 1);
	state.analysis.peakStart	= state.analysis.setup{state.analysis.displayLine, 7}(state.analysis.displayPeak, 2);
	state.analysis.peakEnd		= state.analysis.setup{state.analysis.displayLine, 7}(state.analysis.displayPeak, 3);
	updateGUIByGlobal('state.analysis.peakMode');
	updateGUIByGlobal('state.analysis.peakStart');
	updateGUIByGlobal('state.analysis.peakEnd');

