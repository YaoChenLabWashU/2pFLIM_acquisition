function plotROIScans(channels, rois)
	global state
	
	if nargin<2
		rois=1:state.analysis.numberOfROI;
	end
	if nargin<1
		channels=find([1:state.init.maximumNumberOfInputChannels].*[state.analysis.plot1 state.analysis.plot2 state.analysis.plot3 state.analysis.plot4]);
	end
	
	colorList='brkgmcykkkkkkkkkk';
	
 	for counter=channels
		first=1;
		if getfield(state.analysis, ['anaChannel' num2str(counter)])
			for roiCounter=rois
				if ~iswave(ROIScanName(counter, roiCounter))
					wave(ROIScanName(counter, roiCounter), []);
				end
				if first
					evalin('base', ['plot(' ROIScanName(counter, roiCounter) ');']);
					drawnow;
					set(gcf, 'NumberTitle', 'off');
					set(gcf, 'Name', ['Chan ' num2str(counter) ', ROI ' num2str(rois) ' Fluor']);
					first=0;
				else
					evalin('base', ['append(' ROIScanName(counter, roiCounter) ');']);
					setPlotProps(ROIScanName(counter, roiCounter), 'color', colorList(roiCounter));
				end
			end
		end
	end