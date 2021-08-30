function ivPadSlices
	global state
	
	channelList=find(state.imageViewer.channelsOn);
	maxSlices=0;
	
	for fileCounter=1:state.imageViewer.tsNumberOfFiles
		for channel=channelList(1)
			maxSlices=max(maxSlices, size(state.imageViewer.tsStackData{fileCounter, channel},3));
		end
	end
	
	for fileCounter=1:state.imageViewer.tsNumberOfFiles
		for channel=channelList
			s=size(state.imageViewer.tsStackData{fileCounter, channel});
			if length(s)<3
				s(3)=1;
			end
			if s(3)<maxSlices
				for sliceCounter=s(3)+1:maxSlices
					state.imageViewer.tsStackData{fileCounter, channel}(:, :, sliceCounter)=zeros(s(1), s(2), 1);
				end
			end
		end
	end

	