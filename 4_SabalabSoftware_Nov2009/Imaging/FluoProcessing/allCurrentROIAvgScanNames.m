function out=allCurrentROIAvgScanNames(epochs, pulses, channels, rois)
	global state
	out={};
	
	if nargin==0
		epochs=[];
		pulses=[];
		channels=[];
		rois=[];
	elseif nargin~=4
		error('allCurrentROIAvgScanNames : expect 4 inputs');
	end
	
	if isempty(epochs)
		epochs=state.epoch;
	end
	
	if isempty(pulses)
		try
			if state.cycle.useCyclePos
				pulses=1:size(state.cycle.delayList, 2);
			else			
				pulses=state.cycle.da0List;
				pulses=pulses(pulses>=0);
			end
		catch
			pulses=0;
		end
	end
	
	if isempty(channels)
		for channelCounter=1:state.init.maximumNumberOfInputChannels
			if getfield(state.analysis, ['anaChannel' num2str(channelCounter)])
				channels(end+1)=channelCounter;
			end
		end
	end
	
	if isempty(rois)
		rois=1:state.analysis.numberOfROI;
	end
	
	for epoch=epochs
		for pulse=pulses
			for channel=channels
				for roi=rois
					name=ROIAvgScanName(epoch, pulse, channel, roi);
					if isempty(out)
						out={name};
					elseif ~any(strcmp(out, name))
						out{end+1}=name;
					end						
				end
			end
		end
	end
