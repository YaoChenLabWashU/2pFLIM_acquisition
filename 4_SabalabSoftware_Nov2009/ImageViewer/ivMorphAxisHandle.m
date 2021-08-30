function axis=ivMorphAxisHandle
	global state
	if state.imageViewer.selectionChannelIsProj
		axis=state.imageViewer.projAxis(state.imageViewer.morphChannel);
	else
		axis=state.imageViewer.axis(state.imageViewer.morphChannel) 
	end
