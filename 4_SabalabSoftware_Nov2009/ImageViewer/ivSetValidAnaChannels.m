function ivSetValidAnaChannels
% setAnaChannels
%	looks at the channels that have data and are selected for analysis and
%	creates an array with those indices.  In addition channels selected for
%	analysis on are saved with negative numbers
	global state
	
	if length(state.imageViewer.dataChannels)>20
		state.imageViewer.dataChannels=state.imageViewer.dataChannels(1:20);
	end
	temp = find(state.imageViewer.anaChannels.*state.imageViewer.dataChannels);
	temp2 = find(state.imageViewer.anaMaxChannels.*state.imageViewer.dataChannels);
	state.imageViewer.validAnaChannels=[temp -temp2];