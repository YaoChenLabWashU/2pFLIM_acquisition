function updateClim(channelList, frame)
	global state
	
	if nargin<2
		frame=[];
	end
	
	if (nargin<1) || isempty(channelList)
		channelList=find(state.acq.acquiringChannel.*state.acq.imagingChannel);
		if state.acq.dualLaserMode==2
			channelList=[channelList channelList+10];
		end
	end
	
	for counter=channelList
		try
			low = getfield(state.internal, ['lowPixelValue' num2str(counter)]);
			high = getfield(state.internal, ['highPixelValue' num2str(counter)]);
			if ishandle(state.internal.axis(counter))
				set([state.internal.axis(counter) state.internal.maxaxis(counter)], 'CLim', [low high]);
			end
		catch
		end
	end
	
	if nargin==2
		siRedrawImages(channelList, frame);
	elseif nargin==1
		siRedrawImages(channelList);
	else
		siRedrawImages
	end
	
