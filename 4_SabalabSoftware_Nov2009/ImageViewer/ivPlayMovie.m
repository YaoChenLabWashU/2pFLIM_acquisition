function ivPlayMovie(objects, backwards)
	if nargin<2
		backwards=0;
	end
	if nargin<1
		objects=0;
	end
	
	global state
	
	if backwards
		list=state.imageViewer.tsNumberOfFiles:-1:1;
	else
		list=1:5:state.imageViewer.tsNumberOfFiles;
	end
	
	for counter=list
		ivFlipTimeSeries(counter);
				
		if (objects)
			ivHighlightObject;
		end
		drawnow; 
	end