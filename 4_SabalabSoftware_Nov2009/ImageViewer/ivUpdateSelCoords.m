function ivUpdateSelCoords
	global state
	
	if ~isempty(state.imageViewer.definedLines)
		if state.imageViewer.currentSelection>0 & state.imageViewer.currentSelection<=length(state.imageViewer.definedLines)
			state.imageViewer.selX0=state.imageViewer.definedLines(state.imageViewer.currentSelection, 1);
			state.imageViewer.selX1=state.imageViewer.definedLines(state.imageViewer.currentSelection, 2);
			state.imageViewer.selY0=state.imageViewer.definedLines(state.imageViewer.currentSelection, 3);
			state.imageViewer.selY1=state.imageViewer.definedLines(state.imageViewer.currentSelection, 4);
		else
			state.imageViewer.selX0=0;
			state.imageViewer.selX1=0;
			state.imageViewer.selY0=0;
			state.imageViewer.selY1=0;
		end
		updateGUIByGlobal('state.imageViewer.selY0');
		updateGUIByGlobal('state.imageViewer.selX0');
		updateGUIByGlobal('state.imageViewer.selY1');
		updateGUIByGlobal('state.imageViewer.selX1');
	end
