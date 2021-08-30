function lineScanProcess(channel1, channel2, flChannelIndex, lsChannelIndex, offsets, numROI)

	if length(lsChannelIndex)>1
		error('lineScanProcess: only 1 channel index expected for the line scan channel');
	end
	
	avgLineScan=calcLineScan(eval(['channel' num2str(lsChannelIndex)]), 0, 0, 7);
	waveo('avgLineScanWave', avgLineScan);
	
	[roix, roiy]=findROI_LineScan(avgLineScan, numROI, .3, 20, 26, 22)
	
	for counter=1:numROI
		if counter>length(roix)
			waveo(['roi' num2str(counter) 'WaveX'], []);
			waveo(['roi' num2str(counter) 'WaveY'], []);
		else
			waveo(['roi' num2str(counter) 'WaveX'], roix(counter,:)-1);
			waveo(['roi' num2str(counter) 'WaveY'], roiy(counter,:));
		end			
	end
	
	for channel=flChannelIndex
		channel
		fluorData=roiFluor(eval(['channel' num2str(channel)]), roix);
		for counter=1:size(fluorData,1)
			waveo(['c' num2str(channel) 'r' num2str(counter) 'ScanWave'], fluorData(counter,:));
		end
	end
	
	