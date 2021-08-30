function ivSetWindowBounds(x, y)
	global state
	
	
	for channel=find(state.imageViewer.channelsOn)
		set(state.imageViewer.axis(channel), 'Xlim', x, 'Ylim', y);
		set(state.imageViewer.projAxis(channel), 'Xlim', x, 'Ylim', y);
	end
	if state.imageViewer.compositeOn
		set(state.imageViewer.compositeAxis, 'Xlim', x, 'Ylim', y);
	end

	