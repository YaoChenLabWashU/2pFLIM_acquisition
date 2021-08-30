function plotROIAvgScans(epochs, pulses, channels, rois)
	global state
	
	if nargin==0
		epochs=[];
		pulses=[];
		channels=[];
		rois=[];
	elseif nargin~=4
		error('allCurrentROIAvgScanNames : expect 4 inputs');
	end

	if isempty(channels)
		channels=find([1:state.init.maximumNumberOfInputChannels].*[state.analysis.plot1 state.analysis.plot2 state.analysis.plot3 state.analysis.plot4]);
	end
	
	if isempty(epochs)
		epochs=state.epoch;
	end
	
	colorList='brkgmcykkkkkkkkkk';
	
	for channel=channels
		if getfield(state.analysis, ['anaChannel' num2str(channel)])
			roiScanNames=allCurrentROIAvgScanNames(epochs, pulses, channel, rois);
			first=1;
			counter=1;
			for name=roiScanNames
				if ~iswave(name{1})
					wave(name{1}, []);
				end
				if first
					evalin('base', ['plot(' name{1} ');']);
					set(gcf, 'NumberTitle', 'off');
					set(gcf, 'Name', ['Epoch ' num2str(epochs) ' Chan ' num2str(channels) ' FLUOR AVGS']);
					drawnow;
					first=0;
				else
					evalin('base', ['append(' name{1} ');']);	
				end
				setPlotProps(name{1}, 'color', colorList(counter));
				counter=counter+1;
			end
		end
	end