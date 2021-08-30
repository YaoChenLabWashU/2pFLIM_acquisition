function exportEpochAvgs(epoch)
	global state
	if nargin<1
		epoch=state.epoch;
	end
	
	list=[physAvgList(epoch) roiAvgScanList(epoch)];
	exportAvg(list);
	