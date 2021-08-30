function ivUpdateVisibleWindows
	global state
	for channel=[1:state.imageViewer.maxChannels 11:(state.imageViewer.maxChannels+10)];
		if state.imageViewer.dataChannels(channel) & state.imageViewer.viewChannels(channel)
			set(state.imageViewer.figure(channel), 'Visible', 'on');
		else
			set(state.imageViewer.figure(channel), 'Visible', 'off');
		end
		if state.imageViewer.dataChannels(channel) & state.imageViewer.maxViewChannels(channel)
			set(state.imageViewer.projFigure(channel), 'Visible', 'on');
		else
			set(state.imageViewer.projFigure(channel), 'Visible', 'off');
		end
	end
