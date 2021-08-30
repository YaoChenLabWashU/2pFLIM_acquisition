function ivRerunAxesAnalysis(objects, filecounters)
	global state
	
	if nargin<2
		filecounters=1:state.imageViewer.tsNumberOfFiles;
	end
	if nargin<1
		objects=1:length(state.imageViewer.objectCenters);
	end
	
	for object=objects
		for file=filecounters
			ivFlipTimeSeries(file)
			ivHighlightObject(object)
			drawnow
			ivDefineObjectAxes(1)
		end
	end
	
	