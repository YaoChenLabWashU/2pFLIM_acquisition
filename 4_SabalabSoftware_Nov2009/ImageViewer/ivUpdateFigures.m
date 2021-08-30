function ivUpdateFigures(channels)
	global state gh

	if nargin<1
		channels=find(state.imageViewer.dataChannels(1:14).*...
			(state.imageViewer.anaChannels(1:14)+state.imageViewer.anaMaxChannels(1:14)).*...
			state.imageViewer.viewChannels(1:14));
	end

	state.imageViewer.displayedSlice=max(min(state.imageViewer.displayedSlice, state.imageViewer.nSlices),1);
	updateGUIByGlobal('state.imageViewer.displayedSlice');

	minSlice=max(state.imageViewer.displayedSlice-state.imageViewer.displayedSliceSmear,1);
	maxSlice=min(state.imageViewer.displayedSlice+state.imageViewer.displayedSliceSmear,state.imageViewer.nSlices);
	for channel=channels
		if state.imageViewer.displayedSliceSmear==0
			state.imageViewer.displaySliceData{channel} ...
				= state.imageViewer.tsCoredStackData{state.imageViewer.tsFileCounter, channel}...
				(:, :, state.imageViewer.displayedSlice);
%				= state.imageViewer.stackData{channel}(:, :, state.imageViewer.displayedSlice);
		else
			if state.imageViewer.projectionMode==1	% max proj
	 			state.imageViewer.displaySliceData{channel}  ...
 					= max(state.imageViewer.tsCoredStackData{state.imageViewer.tsFileCounter, channel}(:,:,minSlice:maxSlice), [], 3);
			elseif state.imageViewer.projectionMode==2 % avg proj
				state.imageViewer.displaySliceData{channel}  ...
					= mean(double(state.imageViewer.tsCoredStackData{state.imageViewer.tsFileCounter, channel}(:,:,minSlice:maxSlice)), 3);
			elseif state.imageViewer.projectionMode==3 % sum proj
				state.imageViewer.displaySliceData{channel}  ...
					= sum(state.imageViewer.tsCoredStackData{state.imageViewer.tsFileCounter, channel}(:,:,minSlice:maxSlice), 3);
			end
		end
		set(state.imageViewer.imagehandle(channel), ...
			'CData', state.imageViewer.displaySliceData{channel});
	end
	ivUpdateComposite
	drawnow

