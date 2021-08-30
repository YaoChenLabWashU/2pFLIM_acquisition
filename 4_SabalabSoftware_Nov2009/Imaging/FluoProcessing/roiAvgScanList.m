function out=roiAvgScanList(epochs, pulses, channels, rois)
	global state
	out={};
	
	if nargin<1
		epochs=state.epoch;
	end
	if nargin<2
		if state.cycle.useCyclePos
			pulses=1:size(state.cycle.delayList, 2);
		else			
			pulses=state.cycle.da0List;
			pulses=unique(pulses(pulses>=0));
		end
	end
	if nargin<3
		channels=[];
		for channelCounter=1:state.init.maximumNumberOfInputChannels
			if getfield(state.analysis, ['anaChannel' num2str(channelCounter)])
				channels(end+1)=channelCounter;
			end
		end
	end		
	if nargin<4
		rois=1:state.analysis.numberOfROI;
	end
	
	out={};
	for epoch=epochs
		for pulse=pulses
			for channel=channels
				for roi=rois
					name=ROIAvgScanName(epoch, pulse, channel, roi);
					if iswave(name)
						out{end+1}=name;
					end
				end
			end
		end
	end
