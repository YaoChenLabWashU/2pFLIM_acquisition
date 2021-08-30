function ivUpdateSelectionDisplay
	global state
	if ~isempty(state.imageViewer.lineHandles)
		set(state.imageViewer.lineHandles, 'color', 'b', 'linewidth', 1);
		set(state.imageViewer.lineHandlesRef, 'color', 'b', 'linewidth', 1);
		if state.imageViewer.currentSelection>0 & state.imageViewer.currentSelection<=length(state.imageViewer.lineHandles)
			set(state.imageViewer.lineHandles(state.imageViewer.currentSelection), 'color', 'g', 'linewidth', 2);		
			set(state.imageViewer.lineHandlesRef(state.imageViewer.currentSelection), 'color', 'g', 'linewidth', 2);		
		end
	end