function ivSetXYLims(XLim, YLim)
	global state
	
	if nargin<2
		YLim=[1 state.imageViewer.nPixelsY];
	end
	if nargin<1
		XLim=[1 state.imageViewer.nPixelsX];
	end
	for channel=find(state.imageViewer.channelsOn)
		set(state.imageViewer.axis(channel), 'Xlim', XLim, 'Ylim', YLim);
		set(state.imageViewer.projAxis(channel), 'Xlim', XLim, 'Ylim', YLim);
	end
	set(state.imageViewer.compositeAxis, 'Xlim', XLim, 'Ylim', YLim);
	