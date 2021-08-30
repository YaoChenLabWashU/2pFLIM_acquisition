function ivUpdateLUT(channels)
	global state gh
	
	if nargin<1
		channels=find(state.imageViewer.channelsOn);
	end
	for channel=channels
		set(state.imageViewer.axis(channel), 'CLim', ...
			[getfield(state.imageViewer, ['lowLUT' num2str(channel)]) getfield(state.imageViewer, ['highLUT' num2str(channel)])]);
		set(state.imageViewer.projAxis(channel), 'CLim', ...
			[getfield(state.imageViewer, ['lowLUT' num2str(channel)]) getfield(state.imageViewer, ['highLUT' num2str(channel)])]);
	end
	ivUpdateComposite
