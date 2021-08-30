function saveROIScans(acqNumber, channels, rois)
	global state
	
	if nargin<3
		rois=1:state.analysis.numberOfROI;
	end
	if nargin<2
		channels=1:state.init.maximumNumberOfInputChannels;
	end
	if nargin<1
		acqNumber=[];
	end
	
	if state.cycle.useCyclePos
		pulse=state.cycle.lastPositionUsed;
	else
		pulse=roiPulseNum;
	end
	
 	for counter=channels
		if getfield(state.analysis, ['anaChannel' num2str(counter)])
			for roiCounter=rois
				if ~isempty(acqNumber)
					scanName=ROIScanName(counter, roiCounter, acqNumber);
					if iswave(scanName)
						eval(['global ' scanName]);
						save(fullfile(state.files.savePath, scanName), scanName);
%						disp(['	*** Saved to disk : ' fullfile(state.files.savePath, scanName)]);
					end
				end
				avgName=ROIAvgScanName(state.epoch, pulse, counter, roiCounter);
				if iswave(avgName)
					eval(['global ' avgName]);
					save(fullfile(state.files.savePath, avgName), avgName);
%					disp(['	*** Saved to disk : ' fullfile(state.files.savePath, avgName)]);
				end
			end
		end
	end

