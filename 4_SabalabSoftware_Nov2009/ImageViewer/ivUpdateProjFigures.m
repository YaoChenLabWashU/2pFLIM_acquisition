function ivUpdateProjFigures(channels)
	global state gh
	if nargin<1
		channels=find(state.imageViewer.channelsOn);
	end
	
	for channel=channels
		set(state.imageViewer.projImagehandle(channel), ...
			'CData', state.imageViewer.tsCoredFlatProjection{state.imageViewer.tsFileCounter, channel});
	end
