function resetROIAvgScans
	global state
	
	if nargin<2
		rois=1:state.analysis.numberOfROI;
	end
	if nargin<1
		channels=1:state.init.maximumNumberOfInputChannels;
	end
	
 	roiScanNames=allCurrentROIAvgScanNames(state.epoch, [], [], []);
	for name=roiScanNames
		resetAverage(name{1});
	end
