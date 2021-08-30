function plotROIScansMultiPanel(channels, rois)
	global state
	
	if nargin<2
		rois=1:state.analysis.numberOfROI;
	end
	if nargin<1
		channels=find([1:state.init.maximumNumberOfInputChannels].*...
			[state.analysis.plot1 state.analysis.plot2 state.analysis.plot3 state.analysis.plot4].*...
			[state.analysis.anaChannel1 state.analysis.anaChannel2 state.analysis.anaChannel3 state.analysis.anaChannel4]);
		if state.acq.dualLaserMode==2
			channels=[channels channels+10];
		end
	end
	
	colorList='kgrbmckkkkkgrbmckkkk';

	sq=floor(sqrt(length(channels)));
	
	if sq==sqrt(length(channels))
		xl=sq;
		yl=sq;
	else
		xl=sq;
		yl=sq+1;
	end
	
	panelCounter=1;
 	for channel=channels
		roiCounter=1;
		for roi=rois
			if ~iswave(ROIScanName(channel, roi))
				wave(ROIScanName(channel, roi), []);
			end
			if (panelCounter==1) && (roiCounter==1)
				figure('Color', 'w', 'DoubleBuffer', 'on', 'CloseRequestFcn', 'plotWaveDeleteFcn','KeyPressFcn','plotKeyPressFcn',...
					  'WindowButtonDownFcn','plotButtonDwnFcn','WindowButtonUpFcn','plotButtonUpFcn');			
				set(gcf, 'NumberTitle', 'off', 'Name', 'ROI Fluorescence Data');
			end
			subplot(xl,yl,panelCounter);
			append([ROIScanName(channel, roi)]);
			title(['Chan ' num2str(channel) ' ROI ' num2str(rois)]);
			roiCounter=roiCounter+1;
			setPlotProps(ROIScanName(channel, roi), 'color', colorList(channel+1), 'LineWidth', roiCounter*.5);
		end
		panelCounter=panelCounter+1;
	end
	
