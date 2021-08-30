function plotROIBaselines(channels, rois)
	global state
	
	if nargin<2
		rois=1:state.analysis.numberOfROI;
	end
	if nargin<1
		channels=find([1:state.init.maximumNumberOfInputChannels].*[state.analysis.plot1 state.analysis.plot2 state.analysis.plot3]);
	end

	colorList='brkgmcykkkkkkkkkkk';

	totalCounter=1;
	first=1;
	for channel=channels
		for roiCounter=rois
			wname=[ROIScanName(channel, roiCounter) '_rf0'];
			if ~iswave(wname)
				wave(wname, 0, 'xscale', [1 1]);
			end
			eval(['global ' wname]);
			if first
				plot(wname);
				set(gcf, 'NumberTitle', 'off');
				set(gcf, 'Name', ['Chan ' num2str(channels) ', ROI ' num2str(rois) ' BASELINES']);
				first=0;
			else
				append(wname);
			end
			setPlotProps(wname, 'linestyle', 'none', 'marker','o', 'markerFaceColor', colorList(totalCounter), 'markerEdgeColor', colorList(totalCounter));
			totalCounter=totalCounter+1;
		end
	end
