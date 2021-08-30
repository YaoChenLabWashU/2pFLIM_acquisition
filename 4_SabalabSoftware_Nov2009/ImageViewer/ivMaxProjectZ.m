function ivMaxProjectZ(channels)
	global state
	
	if nargin<1
		channels=find(state.imageViewer.channelsOn);
	end

	ivMaxProject(3, channels);
	