function avginROIScans(acqNumber, channels, rois)
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
				if ~iswave(ROIScanName(counter, roiCounter))
					wave(ROIScanName(counter, roiCounter), []);
				end
				if isempty(acqNumber)
					avgin(ROIScanName(counter, roiCounter), ROIAvgScanName(state.epoch, pulse, counter, roiCounter));
				else
					avgin(ROIScanName(counter, roiCounter, acqNumber), ROIAvgScanName(state.epoch, pulse, counter, roiCounter));
                end
                duplicateo(ROIAvgScanName(state.epoch, pulse, counter, roiCounter), ROIAvgScanName(0, pulse, counter, roiCounter))
			end
		end
	end