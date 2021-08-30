function ivUpdateComposite
	global state
	if state.imageViewer.compositeOn
		lockChannels=[state.imageViewer.compositeLockRed state.imageViewer.compositeLockGreen state.imageViewer.compositeLockBlue];
		compData=zeros(state.imageViewer.nPixelsY, state.imageViewer.nPixelsX, 3);
		if any(lockChannels)
			oldData=get(state.imageViewer.compositeImagehandle, 'CData');
			for channel=find(lockChannels)
				compData(:, :, channel)=oldData(:, :, channel);
			end
		end
		for channel=find(state.imageViewer.dataChannels(1:14).*state.imageViewer.anaChannels(1:14))
			color=getfield(state.imageViewer, ['compositeChannel' num2str(channel)]);
			if color<4
				low=getfield(state.imageViewer, ['lowLUT' num2str(channel)]);
				hi=getfield(state.imageViewer, ['highLUT' num2str(channel)]);
				if state.imageViewer.compositeProjection
					compData(:, :, color) = compData(:, :, color) + ...
						min(max(...
						(double(state.imageViewer.tsCoredFlatProjection{state.imageViewer.tsFileCounter, channel}(1:state.imageViewer.nPixelsY, 1:state.imageViewer.nPixelsX))-low)/max(hi-low,1)...
						,0),1);					
				else
					compData(:, :, color) = compData(:, :, color) + ...
						min(max(...
						(double(state.imageViewer.displaySliceData{channel}(1:state.imageViewer.nPixelsY, 1:state.imageViewer.nPixelsX))-low)/max(hi-low,1)...
						,0),1);
				end
			elseif color~=4
				low=getfield(state.imageViewer, ['lowLUT' num2str(channel)]);
				hi=getfield(state.imageViewer, ['highLUT' num2str(channel)]);
				fColor=[0 0 0];
 				switch color
					case 5 % gray
 						fColor=[1 1 1];
				end
				for colorNumber=1:3
					if state.imageViewer.compositeProjection
			 				compData(:, :, colorNumber) = ...
     						min(max(...
								compData(:, :, colorNumber) +  ...
     							fColor(colorNumber)*(double(state.imageViewer.tsCoredFlatProjection{state.imageViewer.tsFileCounter,channel}(1:state.imageViewer.nPixelsY, 1:state.imageViewer.nPixelsX))-low)/max(hi-low,1)...
     							,0),1);
					else
		 				compData(:, :, colorNumber) = ...
     						min(max(...
								compData(:, :, colorNumber) +  ...
     							fColor(colorNumber)*(double(state.imageViewer.displaySliceData{channel}(1:state.imageViewer.nPixelsY, 1:state.imageViewer.nPixelsX))-low)/max(hi-low,1)...
     							,0),1);
						end
					end
			end
		end
		set(state.imageViewer.compositeImagehandle, 'CData', compData)
	end
