function resetImageProperties(moveWindows)
	global state 

	if nargin<1
		moveWindows=1;
	end
	setStatusString('Making image windows...');
	axisPosition = [0 0 1 1];
	
	% This loop sets up the aspect ratios for the figures
	updateClim;
	
	setupScanImageFigurePositions;
	imageAspectRatio = state.internal.imageAspectRatioBias*state.acq.scanAmplitudeY/state.acq.scanAmplitudeX/(state.acq.linesPerFrame/state.acq.pixelsPerLine);

	set(state.internal.GraphFigure, 'Visible', 'off');
	set(state.internal.MaxFigure, 'Visible', 'off');
	% This loop updates the appropriate images, figures and axes.
	
    if state.acq.dualLaserMode==1   % lasers go simulataneously therefor one image window per laser
        channelList=1:state.init.maximumNumberOfInputChannels;
    else
        channelList=[1:state.init.maximumNumberOfInputChannels 11:10+state.init.maximumNumberOfInputChannels];
    end
    
	for channelCounter = channelList % Count through all the channels
        inputChannelCounter=mod(channelCounter, 10);
		if moveWindows
			set(state.internal.GraphFigure(channelCounter), ...
				'Position', eval(['state.windowPositions.image' num2str(channelCounter) '_position'])...
				);
		end
		set(state.internal.axis(channelCounter),...
			'XLim',  [0 state.acq.pixelsPerLine], ...
			'YLim', [0 state.acq.linesPerFrame], ...
			'Position', axisPosition, ...
			'DataAspectRatio', [imageAspectRatio 1 1]...
			);
		
		if state.acq.imagingChannel(inputChannelCounter)	% is thsi one to be imaged?
			set(state.internal.GraphFigure(channelCounter), 'Visible', 'on');
		end
		
		if moveWindows
			set(state.internal.MaxFigure(channelCounter), ...
				'Position', eval(['state.windowPositions.maxImage' num2str(channelCounter) '_position'])...
				);
		end
		set(state.internal.maxaxis(channelCounter),...
			'XLim',  [0 state.acq.pixelsPerLine], ...
			'YLim', [0 state.acq.linesPerFrame], ...
			'Position', axisPosition, ...
			'DataAspectRatio', [imageAspectRatio 1 1]...
			);
		
		if state.acq.maxImage(inputChannelCounter)	% is thsi one to be imaged?
			set(state.internal.MaxFigure(channelCounter), 'Visible', 'on');
		end
		
	end

	if moveWindows
		set(state.internal.compositeFigure, ...
			'Position', state.windowPositions.compositeImage_position...
			);
	end
	set(state.internal.compositeAxis, ...
		'XLim',  [0 state.acq.pixelsPerLine], ...
		'YLim', [0 state.acq.linesPerFrame], ...
		'Position', axisPosition, ...
		'DataAspectRatio', [imageAspectRatio 1 1]...
		);
	if state.internal.composite	% is thsi one to be imaged?
		set(state.internal.compositeFigure, 'Visible', 'on');
	else
		set(state.internal.compositeFigure, 'Visible', 'off');
	end
	
	
	setStatusString('');
