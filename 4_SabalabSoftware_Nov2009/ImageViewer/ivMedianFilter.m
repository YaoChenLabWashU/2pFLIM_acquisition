function ivMedianFilter(channels)
	global state
	if nargin<1
		channels=find(state.imageViewer.dataChannels(1:14).*...
			(state.imageViewer.anaChannels(1:14)+state.imageViewer.anaMaxChannels(1:14)));
	end

	for channel=channels
		disp([' *** filtering channel ' num2str(channel)])
		for sliceCounter=1:state.imageViewer.nSlices
            if ~isempty(state.imageViewer.tsStackData{state.imageViewer.tsFileCounter, channel})
    			state.imageViewer.tsStackData{state.imageViewer.tsFileCounter, channel}(:, :, sliceCounter) = ...
			    	medfilt2(state.imageViewer.tsStackData{state.imageViewer.tsFileCounter, channel}(:, :, sliceCounter),[3 3]);
            end
		end
	end
	ivUpdateFigures(channels);
