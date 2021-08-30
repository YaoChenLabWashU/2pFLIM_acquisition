function ivMaxProject(dim, channels)
	global state
	
	if nargin<1
		dim=3;
	end
	if nargin<2
		channels=find(state.imageViewer.dataChannels(1:14).*...
			(state.imageViewer.anaChannels(1:14)+state.imageViewer.anaMaxChannels(1:14)));
	end
	
	if ~iscell(state.imageViewer.projectionData)
		state.imageViewer.projectionData={};
		state.imageViewer.projectionIndex={};
	end
	
	for channel=channels
		disp(['*** projecting channel ' num2str(channel) ' dimension ' num2str(dim)]);
		if dim==3 & length(size(state.imageViewer.tsStackData{state.imageViewer.tsFileCounter, channel}))<3
			Y=state.imageViewer.tsStackData{state.imageViewer.tsFileCounter, channel};
			I=Y;
			I(:,:)=1;
		else
			[Y, I]=max(state.imageViewer.tsStackData{state.imageViewer.tsFileCounter, channel}, [], dim);
        end
        state.imageViewer.projectionDataAll{dim, channel}=squeeze(Y);
       

		state.imageViewer.projectionData{channel}=squeeze(Y);
		state.imageViewer.projectionIndexData{channel}=I;
		if dim==3
			state.imageViewer.tsCoredFlatProjection{state.imageViewer.tsFileCounter, channel} = ...
				state.imageViewer.projectionData{channel};
			state.imageViewer.tsCoredFlatProjectionIndex{state.imageViewer.tsFileCounter, channel} = ...
				state.imageViewer.projectionIndexData{channel};
		end			
	end
	ivUpdateProjFigures(channels)
    
    
    
    
  