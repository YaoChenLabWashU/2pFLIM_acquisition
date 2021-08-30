function axis=ivSelectionAxisHandle
	global state
	if state.imageViewer.selectionChannel==0
		axis=state.imageViewer.compositeAxis;
		return
	end
	if state.imageViewer.selectionChannelIsProj
		axis=state.imageViewer.projAxis(state.imageViewer.selectionChannel);
	else
		axis=state.imageViewer.axis(state.imageViewer.selectionChannel);
	end
